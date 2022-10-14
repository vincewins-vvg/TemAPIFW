/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function;

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
import java.util.Optional;
import java.util.UUID;

import javax.ws.rs.InternalServerErrorException;

import org.apache.commons.io.IOUtils;

import com.temenos.connect.InboxOutbox.logger.InboxOutboxConstants;
import com.temenos.inboxoutbox.core.GenericCommand;
import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
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
import com.temenos.microservice.framework.core.function.OutOfSequenceException;
import com.temenos.microservice.framework.core.function.Request;
import com.temenos.microservice.framework.core.function.ResponseStatus;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.framework.core.util.DataTypeConverter;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.framework.core.util.SequenceUtil;
import com.temenos.microservice.paymentorder.entity.Card;
import com.temenos.microservice.paymentorder.entity.PayeeDetails;
import com.temenos.microservice.paymentorder.event.CreatePaymentEvent;
import com.temenos.microservice.paymentorder.event.POFailedEvent;
import com.temenos.microservice.paymentorder.event.PayeeDetailsEvent;
import com.temenos.microservice.paymentorder.exception.StorageException;
import com.temenos.microservice.paymentorder.view.ExchangeRate;
import com.temenos.microservice.paymentorder.view.PaymentOrder;
import com.temenos.microservice.paymentorder.view.PaymentStatus;
import com.temenos.microservice.paymentorder.view.UpdatePaymentOrderParams;

/**
 * CreateNewPaymentOrderImpl.
 * 
 * @author kdhanraj
 *
 */
public class CreateNewPaymentOrderImpl implements CreateNewPaymentOrder {
	public static final String DATE_FORMAT = "yyyy-MM-dd";
	private boolean isCreated;
	private String storageURL = "FILE_STORAGE_URL";

	@Override
	public PaymentStatus invoke(Context ctx, CreateNewPaymentOrderInput input) throws FunctionException {
		PaymentOrderFunctionHelper.validateInput(input);

		PaymentOrder paymentOrder = input.getBody().get();

		List<String> errorList = paymentOrder.doValidate();
		if (errorList.size() > 0)
			throw new InvalidInputException(new FailureMessage(errorList.toString()));

		errorGenerationBasedOnInput(input, "process");
		PaymentOrderFunctionHelper.validatePaymentOrder(paymentOrder);
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
		ctx.setBusinessKey(paymentStatus.getPaymentId());
		return paymentStatus;
	}

	@Override
	public void preHook(final Context ctx, final CreateNewPaymentOrderInput input) throws FunctionException {
		errorGenerationBasedOnInput(input, "preHook");
		POFailedEvent poFailedEvent = new POFailedEvent();
		poFailedEvent.setAmount(input.getBody().get().getAmount());
		poFailedEvent.setCreditAccount(input.getBody().get().getToAccount());
		poFailedEvent.setCurrency(input.getBody().get().getCurrency().toString());
		poFailedEvent.setDebitAccount(input.getBody().get().getFromAccount());
		EventManager.raiseBusinessEvent(ctx, new GenericEvent("PreHookEvent", poFailedEvent));
	}

	@Override
	public void postHook(final Context ctx, final ResponseStatus responseStatus, final CreateNewPaymentOrderInput input,
			final PaymentStatus response) throws FunctionException {
		errorGenerationBasedOnInput(input, "postHook");
		POFailedEvent poFailedEvent = new POFailedEvent();
		poFailedEvent.setAmount(input.getBody().get().getAmount());
		poFailedEvent.setCreditAccount(input.getBody().get().getToAccount());
		poFailedEvent.setCurrency(input.getBody().get().getCurrency().toString());
		poFailedEvent.setDebitAccount(input.getBody().get().getFromAccount());
		EventManager.raiseBusinessEvent(ctx, new GenericEvent("PostHookEvent", poFailedEvent));
	}

	private PaymentStatus executePaymentOrder(Context ctx, PaymentOrder paymentOrder) throws FunctionException {
		String paymentOrderId = ("PO~" + paymentOrder.getFromAccount() + "~" + paymentOrder.getToAccount() + "~"
				+ paymentOrder.getCurrency() + "~" + paymentOrder.getAmount()).toUpperCase();
		if (paymentOrderId != null) {
			NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
					.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
			Optional<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderOpt = paymentOrderDao
					.getByPartitionKeyAndSortKey(paymentOrderId, paymentOrder.getFromAccount());
			if (paymentOrderOpt.isPresent()) {
				throw new InvalidInputException(
						new FailureMessage("Record already exists", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
			}
		}
		com.temenos.microservice.paymentorder.entity.PaymentOrder entity = createEntity(paymentOrderId, paymentOrder);
		// Business event raised from payment order microservice
//		POAcceptedEvent poAcceptedEvent = new POAcceptedEvent();
//		poAcceptedEvent.setPaymentOrderId(entity.getPaymentOrderId());
//		poAcceptedEvent.setAmount(entity.getAmount());
//		poAcceptedEvent.setCreditAccount(entity.getCreditAccount());
//		poAcceptedEvent.setCurrency(entity.getCurrency());
//		poAcceptedEvent.setDebitAccount(entity.getDebitAccount());
		
		CreatePaymentEvent paymentOrderEvent = new CreatePaymentEvent();
		paymentOrderEvent.setPaymentOrderId(entity.getPaymentOrderId());
		paymentOrderEvent.setAmount(entity.getAmount());
		paymentOrderEvent.setCreditAccount(entity.getCreditAccount());
		paymentOrderEvent.setCurrency(entity.getCurrency());
		paymentOrderEvent.setDebitAccount(entity.getDebitAccount());
		
		PayeeDetailsEvent payeeDetails = new PayeeDetailsEvent();
		payeeDetails.setPayeeName("Google pay");
		paymentOrderEvent.setPayeeDetails(payeeDetails);
		EventManager.raiseBusinessEvent(ctx, new GenericEvent("POAccepted", paymentOrderEvent), entity);
		raiseCommandEvent(ctx, entity);
		return readStatus(entity);
	}

	private com.temenos.microservice.paymentorder.entity.PaymentOrder createEntity(String paymentOrderId,
			PaymentOrder view) throws FunctionException {
		com.temenos.microservice.paymentorder.entity.PaymentOrder entity = new com.temenos.microservice.paymentorder.entity.PaymentOrder();
		com.temenos.microservice.paymentorder.entity.PaymentMethod method = new com.temenos.microservice.paymentorder.entity.PaymentMethod();
		com.temenos.microservice.paymentorder.entity.ExchangeRate exchangeRate = null;
		List<com.temenos.microservice.paymentorder.entity.ExchangeRate> exchangeRates = new ArrayList<com.temenos.microservice.paymentorder.entity.ExchangeRate>();

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
		entity.setStatus("INITIATED");
		entity.setPaymentMethod(method);
		entity.setExtensionData((Map<String, String>) view.getExtensionData());
		if (view.getFileContent() != null) {
			entity.setFileContent(view.getFileContent());
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
		if (view.getExchangeRates() != null) {
			for (ExchangeRate exchange : view.getExchangeRates()) {
				exchangeRate = new com.temenos.microservice.paymentorder.entity.ExchangeRate();
				exchangeRate.setId(exchange.getId());
				exchangeRate.setName(exchange.getName());
				exchangeRate.setValue(exchange.getValue());
				exchangeRates.add(exchangeRate);
			}
		}

		if (view.getPayeeDetails() != null) {
			PayeeDetails payeeDetails = new PayeeDetails();
			payeeDetails.setPayeeId(1234L);
			payeeDetails.setPayeeName(view.getPayeeDetails().getPayeeName());
			payeeDetails.setPayeeType(view.getPayeeDetails().getPayeeType());
			entity.setPayeeDetails(payeeDetails);
		}

		entity.setExchangeRates(exchangeRates);
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		paymentOrderDao.saveEntity(entity);
		return entity;
	}

	private PaymentStatus readStatus(com.temenos.microservice.paymentorder.entity.PaymentOrder paymentOrder)
			throws FunctionException {
		PaymentStatus paymentStatus = new PaymentStatus();
		paymentStatus.setPaymentId(paymentOrder.getPaymentOrderId());
		paymentStatus.setStatus(paymentOrder.getStatus());
		paymentStatus.setDetails(paymentOrder.getPaymentDetails());
		return paymentStatus;
	}

	public void raiseCommandEvent(Context ctx, com.temenos.microservice.paymentorder.entity.PaymentOrder entity) {
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
	private void errorGenerationBasedOnInput(CreateNewPaymentOrderInput input, String hookName)
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

	@Override
	public void isSequenceValid(final Context ctx) throws FunctionException {
		Request<String> request = (Request<String>) ctx.getRequest();
		Map<String, List<String>> headers = request.getHeaders();
		String businessKey = headers.get(InboxOutboxConstants.BUSINESS_KEY).get(0);
		Long sequenceNo = Long.valueOf(headers.get(InboxOutboxConstants.SEQUENCE_NO).get(0));
		String sourceId = headers.get(InboxOutboxConstants.EVENT_SOURCE).get(0);
		Long expectedSequenceNo = null;

		switch (Environment.getDatabase()) {
		case Environment.DATABASE_MONGODB:
			expectedSequenceNo = SequenceUtil.generateSequenceNumber(businessKey, sourceId);
			break;
		case Environment.DATABASE_POSTGRESQL:
			expectedSequenceNo = SequenceUtil.generateSequenceNumber(businessKey, sourceId);
			break;			
		case Environment.DATABASE_DYNAMODB:
			expectedSequenceNo = PaymentOrderFunctionHelper.validateAndUpdateSequenceNumber(businessKey, sourceId,
					sequenceNo);
			break;
		default:
			throw new InvalidInputException(
					new FailureMessage("Invalid database name", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}

		if (!expectedSequenceNo.equals(sequenceNo)) {
			throw new OutOfSequenceException("Invalid sequence number: " + sequenceNo);
		}
	}
}