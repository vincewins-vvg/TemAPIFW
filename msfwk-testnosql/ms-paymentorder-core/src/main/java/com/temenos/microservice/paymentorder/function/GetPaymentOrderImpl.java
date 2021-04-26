package com.temenos.microservice.paymentorder.function;

import static com.temenos.microservice.framework.core.util.OpenAPIUtil.formatDate;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.commons.io.IOUtils;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.file.reader.FileReaderConstants;
import com.temenos.microservice.framework.core.file.reader.MSStorageReadAdapter;
import com.temenos.microservice.framework.core.file.reader.MSStorageReadAdapterFactory;
import com.temenos.microservice.framework.core.file.reader.StorageReadException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.tracer.Tracer;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.view.EnumCurrency;
import com.temenos.microservice.paymentorder.view.ExchangeRate;
import com.temenos.microservice.paymentorder.view.GetPaymentOrderParams;
import com.temenos.microservice.paymentorder.view.PaymentOrder;
import com.temenos.microservice.paymentorder.view.PaymentOrderStatus;
import com.temenos.microservice.paymentorder.view.PaymentStatus;
import com.temenos.microservice.paymentorder.exception.StorageException;

/**
 * GetPaymentOrderImpl.
 * 
 * @author kdhanraj
 *
 */
public class GetPaymentOrderImpl implements GetPaymentOrder {

	@Override
	public PaymentOrderStatus invoke(Context ctx, GetPaymentOrderInput input) throws FunctionException {
		validateInput(input);
		GetPaymentOrderParams params = input.getParams().get();

		validateParam(params);
		return executeGetPaymentOrder(params);
	}

	private PaymentOrderStatus executeGetPaymentOrder(GetPaymentOrderParams params) throws FunctionException {
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		String sortKey = null;
		String  paymentOrderId = null;
		if(params.getPaymentId() != null && params.getPaymentId().get(0) != null) {
			paymentOrderId = params.getPaymentId().get(0).replace("PO~","");
			sortKey = paymentOrderId.substring(0,paymentOrderId.indexOf("~"));
		}
		Optional<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderOpt = paymentOrderDao
		.getByPartitionKeyAndSortKey(params.getPaymentId().get(0),sortKey);
		if (paymentOrderOpt.isPresent()) {
			com.temenos.microservice.paymentorder.entity.PaymentOrder paymentOrder = paymentOrderOpt.get();
			PaymentStatus paymentStatus = new PaymentStatus();
			paymentStatus.setPaymentId(paymentOrder.getPaymentOrderId());
			paymentStatus.setStatus(paymentOrder.getStatus());
			paymentStatus.setDetails(paymentOrder.getPaymentDetails());

			PaymentOrderStatus paymentOrderStatus = new PaymentOrderStatus();
			PaymentOrder order = new PaymentOrder();
			order.setAmount(paymentOrder.getAmount());
			order.setCurrency(Enum.valueOf(EnumCurrency.class, paymentOrder.getCurrency()));
			order.setFromAccount(paymentOrder.getDebitAccount());
			order.setToAccount(paymentOrder.getCreditAccount());
			order.setPaymentDetails(paymentOrder.getPaymentDetails());
			order.setPaymentReference(paymentOrder.getPaymentReference());
			order.setExtensionData(paymentOrder.getExtensionData());
			order.setFileContent(paymentOrder.getFileContent());
			order.setPaymentDate(formatDate(paymentOrder.getPaymentDate()));

			com.temenos.microservice.paymentorder.view.Card card = new com.temenos.microservice.paymentorder.view.Card();
			if (paymentOrder.getPaymentMethod() != null && paymentOrder.getPaymentMethod().getCard() != null) {
				card.setCardid(paymentOrder.getPaymentMethod().getCard().getCardid());
				card.setCardname(paymentOrder.getPaymentMethod().getCard().getCardname());
				card.setCardlimit(paymentOrder.getPaymentMethod().getCard().getCardlimit());

				com.temenos.microservice.paymentorder.view.PaymentMethod paymentMethod = new com.temenos.microservice.paymentorder.view.PaymentMethod();
				paymentMethod.setId(paymentOrder.getPaymentMethod().getId());
				paymentMethod.setName(paymentOrder.getPaymentMethod().getName());
				paymentMethod
						.setExtensionData((Map<String, String>) paymentOrder.getPaymentMethod().getExtensionData());
				paymentMethod.setCard(card);
				order.setPaymentMethod(paymentMethod);

				List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
				for (com.temenos.microservice.paymentorder.entity.ExchangeRate erEntity : paymentOrder
						.getExchangeRates()) {
					ExchangeRate exchangeRate = new ExchangeRate();
					exchangeRate.setId(erEntity.getId());
					exchangeRate.setName(erEntity.getName());
					exchangeRate.setValue(erEntity.getValue());
					exchangeRates.add(exchangeRate);
				}
				order.setExchangeRates(exchangeRates);
			}
			com.temenos.microservice.paymentorder.view.PayeeDetails payeeDtls = new com.temenos.microservice.paymentorder.view.PayeeDetails();
			if (paymentOrder.getPayeeDetails() != null) {
				payeeDtls.setPayeeName(paymentOrder.getPayeeDetails().getPayeeName());
				payeeDtls.setPayeeType(paymentOrder.getPayeeDetails().getPayeeType());
				order.setPayeeDetails(payeeDtls);
			}
			if(params.getGetFromStorageFile()!= null && params.getGetFromStorageFile().get(0) != null) {
			try {
				String StorageUrl = Environment.getEnvironmentVariable("FILE_STORAGE_URL", null);
				String STORAGE_HOME = Environment.getEnvironmentVariable(Environment.TEMN_MSF_STORAGE_HOME, FileReaderConstants.EMPTY);
				if(StorageUrl != null && STORAGE_HOME != null) {
					MSStorageReadAdapter fileReader = MSStorageReadAdapterFactory.getStorageReadAdapterInstance();
					InputStream is = fileReader.getFileAsInputStream(StorageUrl);
					byte[] bytes = IOUtils.toByteArray(is);
					ByteBuffer fileReadWrite = ByteBuffer.wrap(bytes);
					paymentStatus.setFileReadWrite(fileReadWrite);
				}
				} catch (FileNotFoundException e ) {
					Tracer.getSpan().addEvent("PaymentOrder retrieval failed due to " + e.getMessage());
					throw new StorageException(new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));	
				} catch (IOException e) {
					Tracer.getSpan().addEvent("PaymentOrder retrieval failed due to " + e.getMessage());
					throw new InvalidInputException(new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
				} catch (StorageReadException e) {
					Tracer.getSpan().addEvent("PaymentOrder retrieval failed due to " + e.getMessage());
					throw new StorageException(new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));	
				}
			}
			paymentOrderStatus.setPaymentOrder(order);
			paymentOrderStatus.setPaymentStatus(paymentStatus);
			Tracer.getSpan().addEvent("PaymentOrder Retrived Sucessfully");
			return paymentOrderStatus;
		}
		return new PaymentOrderStatus();
	}

	private void validateParam(GetPaymentOrderParams params) throws InvalidInputException {
		List<String> paymentIds = params.getPaymentId();
		if (paymentIds == null || paymentIds.isEmpty()) {
			Tracer.getSpan().addEvent("PaymentOrder retrieval failed due to invalid Input");
			throw new InvalidInputException(new FailureMessage("Input param is empty", "PAYM-PORD-A-2001"));
		}
		if (paymentIds.size() != 1) {
			Tracer.getSpan().addEvent("PaymentOrder retrieval failed due to invalid Input");
			throw new InvalidInputException(
					new FailureMessage("Invalid paymentId param. Only one paymentId expected", "PAYM-PORD-A-2002"));
		}
		if (paymentIds.get(0).isEmpty()) {
			Tracer.getSpan().addEvent("PaymentOrder retrieval failed due to invalid Input");
			throw new InvalidInputException(
					new FailureMessage("Invalid paymentId param. PaymentId is empty", "PAYM-PORD-A-2003"));
		}
	}

	private void validateInput(GetPaymentOrderInput input) throws InvalidInputException {
		if (!input.getParams().isPresent()) {
			Tracer.getSpan().addEvent("PaymentOrder retrieval failed due to invalid Input");
			throw new InvalidInputException(new FailureMessage("Input param is empty", "PAYM-PORD-A-2001"));
		}
	}
}
