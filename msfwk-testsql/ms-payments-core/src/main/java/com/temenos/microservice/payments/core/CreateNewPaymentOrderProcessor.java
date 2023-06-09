/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.core;

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.text.ParseException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.ws.rs.InternalServerErrorException;

import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Component;

import com.temenos.inboxoutbox.core.GenericCommand;
import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.DatabaseOperationException;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.sql.BaseSqlDao;
import com.temenos.microservice.framework.core.file.reader.FileReaderConstants;
import com.temenos.microservice.framework.core.file.reader.MSStorageReadAdapter;
import com.temenos.microservice.framework.core.file.reader.MSStorageReadAdapterFactory;
import com.temenos.microservice.framework.core.file.reader.StorageReadException;
import com.temenos.microservice.framework.core.file.writer.MSStorageWriteAdapter;
import com.temenos.microservice.framework.core.file.writer.MSStorageWriteAdapterFactory;
import com.temenos.microservice.framework.core.file.writer.StorageWriteException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.function.InvocationFailedException;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.framework.core.util.DataTypeConverter;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.dao.AccountingDao;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.Card;
import com.temenos.microservice.payments.entity.ExchangeRate;
import com.temenos.microservice.payments.entity.PayeeDetails;
import com.temenos.microservice.payments.event.PaymentOrderCreated;
import com.temenos.microservice.payments.event.PayeeDetailsEvent;
import com.temenos.microservice.payments.exception.StorageException;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderInput;
import com.temenos.microservice.payments.function.PaymentOrderFunctionHelper;
import com.temenos.microservice.payments.function.UpdatePaymentOrderInput;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentStatus;
import com.temenos.microservice.payments.view.UpdatePaymentOrderParams;

@Component
public class CreateNewPaymentOrderProcessor {
	public static final String DATE_FORMAT = "yyyy-MM-dd";
	private boolean isCreated;
	private String storageURL = "FILE_STORAGE_URL";

	public PaymentStatus invoke(Context ctx, CreateNewPaymentOrderInput input) throws FunctionException {
		PaymentOrderFunctionHelper.validateInput(input);
		PaymentOrder paymentOrder = input.getBody().get();

		// does validation based on swagger input
		List<String> errorList = paymentOrder.doValidate();
		if (errorList.size() > 0)
			throw new InvalidInputException(new FailureMessage(errorList.toString()));

		errorGenerationBasedOnInput(input, "process");
		PaymentOrderFunctionHelper.validatePaymentOrder(paymentOrder, ctx);
		PaymentStatus paymentStatus = executePaymentOrder(ctx, paymentOrder);
		try {
			if (paymentOrder.getFileReadWrite() != null) {
				String StorageUrl = Environment.getEnvironmentVariable(storageURL, null);
				if (StorageUrl != null) {
					MSStorageWriteAdapter fileWriter = MSStorageWriteAdapterFactory.getStorageWriteAdapterInstance();
					byte[] dst = new byte[paymentOrder.getFileReadWrite().remaining()];
					paymentOrder.getFileReadWrite().get(dst);
					InputStream content = new ByteArrayInputStream(dst);
					if (paymentOrder.getFileOverWrite() == true) {
						fileWriter.uploadFileAsInputStream(StorageUrl, content, true);
					} else {
						fileWriter.uploadFileAsInputStream(StorageUrl, content, false);
					}
					isCreated = true;
				}
			}
			if (isCreated) {
				String StorageUrl = Environment.getEnvironmentVariable(storageURL, null);
				String STORAGE_HOME = Environment.getEnvironmentVariable(Environment.TEMN_MSF_STORAGE_HOME,
						FileReaderConstants.EMPTY);
				if (StorageUrl != null && STORAGE_HOME != null) {
					MSStorageReadAdapter fileReader = MSStorageReadAdapterFactory.getStorageReadAdapterInstance();
					InputStream is = fileReader.getFileAsInputStream(StorageUrl);
					byte[] bytes = IOUtils.toByteArray(is);
					ByteBuffer fileReadWrite = ByteBuffer.wrap(bytes);
					paymentStatus.setFileReadWrite(fileReadWrite);
					isCreated = false;
				}
			}
		} catch (StorageWriteException e) {
			throw new InvalidInputException(
					new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		} catch (InternalServerErrorException e) {
			throw new InvalidInputException(
					new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		} catch (FileNotFoundException e) {
			throw new StorageException(
					new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		} catch (IOException e) {
			throw new InvalidInputException(
					new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		} catch (StorageReadException e) {
			throw new StorageException(
					new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}
		//ctx.setBusinessKey(paymentStatus.getPaymentId());
		return paymentStatus;
	}

	private PaymentStatus executePaymentOrder(Context ctx, PaymentOrder paymentOrder) throws FunctionException {
		String paymentOrderId = ("PO~" + paymentOrder.getFromAccount() + "~" + paymentOrder.getToAccount() + "~"
				+ paymentOrder.getCurrency() + "~" + paymentOrder.getAmount()).toUpperCase();
		if (paymentOrderId != null) {
			com.temenos.microservice.payments.entity.PaymentOrder paymentsOrder = (com.temenos.microservice.payments.entity.PaymentOrder) PaymentOrderDao
					.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
					.findById(paymentOrderId, com.temenos.microservice.payments.entity.PaymentOrder.class);
			if (paymentsOrder != null && paymentsOrder.getPaymentOrderId() != null) {
				throw new InvalidInputException(
						new FailureMessage("Record already exists", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
			}
		}
		com.temenos.microservice.payments.entity.PaymentOrder entity = createEntity(ctx, paymentOrderId, paymentOrder);
		// return readStatus(paymentOrder.getFromAccount(), paymentOrderId);
		return readStatus(entity);
	}

	private com.temenos.microservice.payments.entity.PaymentOrder createEntity(Context ctx, String paymentOrderId,
			PaymentOrder view) throws FunctionException {
		com.temenos.microservice.payments.entity.PaymentOrder entity = new com.temenos.microservice.payments.entity.PaymentOrder();
		com.temenos.microservice.payments.entity.PaymentMethod method = new com.temenos.microservice.payments.entity.PaymentMethod();

		entity.setPaymentOrderId(paymentOrderId);
		entity.setAmount(view.getAmount());
		entity.setCreditAccount(view.getToAccount());
		entity.setDebitAccount(view.getFromAccount());
		try {
			if (view.getPaymentDate() != null) {
				entity.setPaymentDate(DataTypeConverter.toDate(view.getPaymentDate(), DATE_FORMAT));
			} else {
				entity.setPaymentDate(Date.from(Instant.now()));
			}
		} catch (ParseException e) {
			throw new InvalidInputException(
					new FailureMessage("Error while parsing date. Check the inputted date format",
							MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}
		entity.setCurrency(view.getCurrency().toString());
		entity.setPaymentReference(view.getPaymentReference());
		entity.setPaymentDetails(view.getPaymentDetails());
		entity.setExtensionData((Map<String, String>) view.getExtensionData());
		entity.setStatus("INITIATED");
		entity.setPaymentMethod(method);

		if (view.getFileContent() != null) {
			try {
				entity.setFileContent(new String(view.getFileContent().array(), "UTF-8"));
			} catch (Exception e) {
				throw new RuntimeException(e.getMessage());
			}
		}

		if (view.getPaymentMethod() != null) {
			entity.getPaymentMethod().setId(view.getPaymentMethod().getId());
			entity.getPaymentMethod().setName(view.getPaymentMethod().getName());
			entity.getPaymentMethod()
					.setExtensionData((Map<String, String>) view.getPaymentMethod().getExtensionData());
			if (view.getPaymentMethod().getCard() != null) {
				Card card = new Card();
				card.setCardid(view.getPaymentMethod().getCard().getCardid());
				card.setCardname(view.getPaymentMethod().getCard().getCardname());
				card.setCardlimit(view.getPaymentMethod().getCard().getCardlimit());
				entity.getPaymentMethod().setCard(card);
			}
		}

		if (view.getPayeeDetails() != null) {
			PayeeDetails payeeDetails = new PayeeDetails();
			payeeDetails.setPayeeId(123);
			payeeDetails.setPayeeName(view.getPayeeDetails().getPayeeName());
			payeeDetails.setPayeeType(view.getPayeeDetails().getPayeeType());
			entity.setPayeeDetails(payeeDetails);
		}

		if (view.getExchangeRates() != null) {
			List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
			for (com.temenos.microservice.payments.view.ExchangeRate exchangeRt : view.getExchangeRates()) {
				ExchangeRate exchangeRate = new ExchangeRate();
				exchangeRate.setName(exchangeRt.getName());
				exchangeRate.setValue(exchangeRt.getValue());
				exchangeRates.add(exchangeRate);
			}
			entity.setExchangeRates(exchangeRates);
		}

		entity=PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.save(entity);
		PaymentOrderCreated paymentOrderEvent = new PaymentOrderCreated();
		paymentOrderEvent.setPaymentOrderId(entity.getPaymentOrderId());
		paymentOrderEvent.setAmount(entity.getAmount());
		paymentOrderEvent.setCreditAccount(entity.getCreditAccount());
		paymentOrderEvent.setCurrency(entity.getCurrency());
		paymentOrderEvent.setDebitAccount(entity.getDebitAccount());
		PayeeDetailsEvent payeeDetails = new PayeeDetailsEvent();
		payeeDetails.setPayeeName("Google pay");
		paymentOrderEvent.setPayeeDetails(payeeDetails);
		ctx.setBusinessKey(paymentOrderEvent.getPaymentOrderId());
		//Entry in ms_payment_accounting table
		List<com.temenos.microservice.payments.entity.Accounting> accountingEntities = createAccounting(view, paymentOrderId);
		EventManager.raiseBusinessEvent(ctx, new GenericEvent("POAccepted", paymentOrderEvent), entity, accountingEntities.get(0), accountingEntities.get(1));
		raiseCommandEvent(ctx, entity);
		return entity;
	}

	private List<com.temenos.microservice.payments.entity.Accounting> createAccounting(com.temenos.microservice.payments.view.PaymentOrder view, String paymentOrderId) throws DatabaseOperationException, DataAccessException {
		
		List<com.temenos.microservice.payments.entity.Accounting> entityArrayList = new ArrayList<com.temenos.microservice.payments.entity.Accounting>();
		com.temenos.microservice.payments.entity.Accounting debitAcct = new com.temenos.microservice.payments.entity.Accounting();
		com.temenos.microservice.payments.entity.Accounting creditAcct = new com.temenos.microservice.payments.entity.Accounting();
		
		//Entry for debit account
		debitAcct.setPaymentOrderId(paymentOrderId);
		debitAcct.setAccountNumber(view.getFromAccount());
		debitAcct.setAmount(view.getAmount());
		debitAcct.setCurrency(view.getCurrency().toString());
		debitAcct.setPaymentType("DEBIT");
		debitAcct.setProcessedDate(Date.from(Instant.now()));
		
		//Entry for credit account
		creditAcct.setPaymentOrderId(paymentOrderId);
		creditAcct.setAccountNumber(view.getToAccount());
		creditAcct.setAmount(view.getAmount());
		creditAcct.setCurrency(view.getCurrency().toString());
		creditAcct.setProcessedDate(Date.from(Instant.now()));
		creditAcct.setPaymentType("CREDIT");
		
		entityArrayList.add(debitAcct);
		entityArrayList.add(creditAcct);
		
		AccountingDao.getInstance(com.temenos.microservice.payments.entity.Accounting.class).getSqlDao()
		.saveOrMergeEntityList(entityArrayList, true);
		
		return entityArrayList;
		
	}

	private PaymentStatus readStatus(String debitAccount, String paymentOrderId) throws FunctionException {
		com.temenos.microservice.payments.entity.PaymentOrder paymentOrder = (com.temenos.microservice.payments.entity.PaymentOrder) PaymentOrderDao
				.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.findById(paymentOrderId, com.temenos.microservice.payments.entity.PaymentOrder.class);

		PaymentStatus paymentStatus = new PaymentStatus();
		paymentStatus.setPaymentId(paymentOrderId);
		paymentStatus.setStatus(paymentOrder.getStatus());
		paymentStatus.setDetails(paymentOrder.getPaymentDetails());
		return paymentStatus;
	}

	private PaymentStatus readStatus(com.temenos.microservice.payments.entity.PaymentOrder paymentOrder)
			throws FunctionException {
		PaymentStatus paymentStatus = new PaymentStatus();
		paymentStatus.setPaymentId(paymentOrder.getPaymentOrderId());
		paymentStatus.setStatus(paymentOrder.getStatus());
		paymentStatus.setDetails(paymentOrder.getPaymentDetails());
		return paymentStatus;
	}

	public void raiseCommandEvent(Context ctx, com.temenos.microservice.payments.entity.PaymentOrder entity) {
		GenericCommand updateCommand = new GenericCommand();

		updateCommand.setDateTime(new Date());
		updateCommand.setEventId(UUID.randomUUID().toString());
		updateCommand.setEventType(Environment.getMSName() + ".UpdatePaymentOrder");
		updateCommand.setStatus("New");
		updateCommand.setBusinessKey(entity.getPaymentOrderId());

		UpdatePaymentOrderParams params = new UpdatePaymentOrderParams();
		params.setPaymentId(Arrays.asList(entity.getPaymentOrderId()));

		PaymentStatus paymentStatus = new PaymentStatus();
		paymentStatus.setDebitAccount(entity.getDebitAccount());
		paymentStatus.setDetails("Payment order updated");
		paymentStatus.setStatus("Updated");
		paymentStatus.setPaymentId(entity.getPaymentOrderId());

		UpdatePaymentOrderInput input = new UpdatePaymentOrderInput(params, paymentStatus);

		updateCommand.setPayload(input);
		EventManager.raiseCommandEvent(ctx, updateCommand, entity);
	}

	/**
	 * Generates Exception based on "Descriptions" from input payload
	 * 
	 * @param input    -payload
	 * @param hookName - prehook,posthook,process
	 * @throws InvocationFailedException
	 */
	public void errorGenerationBasedOnInput(CreateNewPaymentOrderInput input, String hookName)
			throws InvocationFailedException {
		if (input == null || input.getBody() == null && input.getBody().get() == null)
			return;
		if (input.getBody().get().getDescriptions() != null && !input.getBody().get().getDescriptions().isEmpty()) {
			if (input.getBody().get().getDescriptions().get(0) == null)
				return;
			if (input.getBody().get().getDescriptions().get(0).equals(hookName + "BusinessFailure"))
				throw new InvocationFailedException("Business Failure error generated");
			if (input.getBody().get().getDescriptions().get(0).equals(hookName + "InfrastructureFailure"))
				throw new NullPointerException("Infrastructure Failure error generated");
		}
	}

}