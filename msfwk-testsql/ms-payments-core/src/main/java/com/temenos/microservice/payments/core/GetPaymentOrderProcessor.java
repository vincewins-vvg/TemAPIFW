package com.temenos.microservice.payments.core;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.temenos.microservice.framework.core.util.OpenAPIUtil.formatDate;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.file.reader.FileReader;
import com.temenos.microservice.framework.core.file.reader.FileReaderConstants;
import com.temenos.microservice.framework.core.file.reader.FileReaderException;
import com.temenos.microservice.framework.core.file.reader.FileReaderFactory;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.function.GetPaymentOrderInput;
import com.temenos.microservice.payments.view.EnumCurrency;
import com.temenos.microservice.payments.view.ExchangeRate;
import com.temenos.microservice.payments.view.GetPaymentOrderParams;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentOrderStatus;
import com.temenos.microservice.payments.view.PaymentStatus;

@Component
public class GetPaymentOrderProcessor {
	public static Charset charset = Charset.forName("UTF-8");
	public static CharsetEncoder encoder = charset.newEncoder();

	public PaymentOrderStatus invoke(Context ctx, GetPaymentOrderInput input) throws FunctionException {
		validateInput(input);
		GetPaymentOrderParams params = input.getParams().get();
		validateParam(params);
		return executeGetPaymentOrder(params);
	}

	private PaymentOrderStatus executeGetPaymentOrder(GetPaymentOrderParams params) throws FunctionException {

		com.temenos.microservice.payments.entity.PaymentOrder paymentOrder = (com.temenos.microservice.payments.entity.PaymentOrder) PaymentOrderDao
				.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.findById(params.getPaymentId().get(0), com.temenos.microservice.payments.entity.PaymentOrder.class);

		if (paymentOrder != null) {
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
			if (paymentOrder.getFileContent() != null) {
				ByteBuffer byteBuffer;
				try {
					byteBuffer = encoder.encode(CharBuffer.wrap((paymentOrder.getFileContent())));
					order.setFileContent(byteBuffer);
				} catch (Exception e) {
					throw new RuntimeException(e.getMessage());
				}
			}
			order.setPaymentDate(formatDate(paymentOrder.getPaymentDate()));

			com.temenos.microservice.payments.view.Card card = new com.temenos.microservice.payments.view.Card();
			if (paymentOrder.getPaymentMethod() != null && paymentOrder.getPaymentMethod().getCard() != null) {
				card.setCardid(paymentOrder.getPaymentMethod().getCard().getCardid());
				card.setCardname(paymentOrder.getPaymentMethod().getCard().getCardname());
				card.setCardlimit(paymentOrder.getPaymentMethod().getCard().getCardlimit());

				com.temenos.microservice.payments.view.PaymentMethod paymentMethod = new com.temenos.microservice.payments.view.PaymentMethod();
				paymentMethod.setId(paymentOrder.getPaymentMethod().getId());
				paymentMethod.setName(paymentOrder.getPaymentMethod().getName());
				paymentMethod.setExtensionData((Map<String, String>) paymentOrder.getPaymentMethod().getExtensionData());
				paymentMethod.setCard(card);
				order.setPaymentMethod(paymentMethod);

				List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
				for (com.temenos.microservice.payments.entity.ExchangeRate erEntity : paymentOrder.getExchangeRates()) {
					ExchangeRate exchangeRate = new ExchangeRate();
					exchangeRate.setId(erEntity.getId());
					exchangeRate.setName(erEntity.getName());
					exchangeRate.setValue(erEntity.getValue());
					exchangeRates.add(exchangeRate);
				}
				order.setExchangeRates(exchangeRates);
			}
			com.temenos.microservice.payments.view.PayeeDetails payeeDtls = new com.temenos.microservice.payments.view.PayeeDetails();
			if (paymentOrder.getPayeeDetails() != null) {
				payeeDtls.setPayeeName(paymentOrder.getPayeeDetails().getPayeeName());
				payeeDtls.setPayeeType(paymentOrder.getPayeeDetails().getPayeeType());
				order.setPayeeDetails(payeeDtls);
			}
			try {

				String StorageUrl = Environment.getEnvironmentVariable("FILE_STORAGE_URL", null);
				String STORAGE_HOME = Environment.getEnvironmentVariable(Environment.TEMN_MSF_STORAGE_HOME, FileReaderConstants.EMPTY);
				if(StorageUrl != null && STORAGE_HOME != null) {
					FileReader fileReader = FileReaderFactory.getFileReaderInstance();
					InputStream is = fileReader.getFileAsInputStream(StorageUrl);
					byte[] bytes = IOUtils.toByteArray(is);
					ByteBuffer fileReadWrite = ByteBuffer.wrap(bytes);
					paymentStatus.setFileReadWrite(fileReadWrite);
				}
				} catch (FileNotFoundException e ) {
					throw new InvalidInputException(new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
				} catch (IOException e) {
					throw new InvalidInputException(new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
				} catch (FileReaderException e) {
					throw new InvalidInputException(new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
				}
			paymentOrderStatus.setPaymentOrder(order);
			paymentOrderStatus.setPaymentStatus(paymentStatus);
			return paymentOrderStatus;
		}
		return new PaymentOrderStatus();
	}

	private void validateParam(GetPaymentOrderParams params) throws InvalidInputException {
		List<String> paymentIds = params.getPaymentId();
		if (paymentIds == null || paymentIds.isEmpty()) {
			throw new InvalidInputException(new FailureMessage("Input param is empty", "PAYM-PORD-A-2001"));
		}
		if (paymentIds.size() != 1) {
			throw new InvalidInputException(
					new FailureMessage("Invalid paymentId param. Only one paymentId expected", "PAYM-PORD-A-2002"));
		}
		if (paymentIds.get(0).isEmpty()) {
			throw new InvalidInputException(
					new FailureMessage("Invalid paymentId param. PaymentId is empty", "PAYM-PORD-A-2003"));
		}
	}

	private void validateInput(GetPaymentOrderInput input) throws InvalidInputException {
		if (!input.getParams().isPresent()) {
			throw new InvalidInputException(new FailureMessage("Input param is empty", "PAYM-PORD-A-2001"));
		}
	}
}
