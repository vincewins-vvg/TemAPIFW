/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.funciton.test;

import java.math.BigDecimal;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.camel.CamelContext;
import org.apache.camel.Exchange;
import org.apache.camel.impl.DefaultCamelContext;
import org.apache.camel.support.DefaultExchange;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.BinaryData;
import com.temenos.microservice.framework.core.function.FunctionInputBuilder;
import com.temenos.microservice.framework.core.function.HttpRequest;
import com.temenos.microservice.framework.core.function.HttpRequestContext;
import com.temenos.microservice.framework.core.function.HttpRequestTransformer;
import com.temenos.microservice.framework.core.function.camel.CamelHttpRequestTransformer;
import com.temenos.microservice.paymentorder.function.CreateNewPaymentOrder;
import com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl;
import com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderInput;
import com.temenos.microservice.paymentorder.function.FileDownload;
import com.temenos.microservice.paymentorder.function.FileDownloadImpl;
import com.temenos.microservice.paymentorder.function.FileDownloadInput;
import com.temenos.microservice.paymentorder.function.FileUpload;
import com.temenos.microservice.paymentorder.function.FileUploadImpl;
import com.temenos.microservice.paymentorder.function.FileUploadInput;
import com.temenos.microservice.paymentorder.function.GetPaymentOrder;
import com.temenos.microservice.paymentorder.function.GetPaymentOrderImpl;
import com.temenos.microservice.paymentorder.function.GetPaymentOrderInput;
import com.temenos.microservice.paymentorder.function.UpdatePaymentOrder;
import com.temenos.microservice.paymentorder.function.UpdatePaymentOrderImpl;
import com.temenos.microservice.paymentorder.function.UpdatePaymentOrderInput;
import com.temenos.microservice.paymentorder.view.ApiResponse;
import com.temenos.microservice.paymentorder.view.Card;
import com.temenos.microservice.paymentorder.view.DocumentDetails;
import com.temenos.microservice.paymentorder.view.DownloadApiResponse;
import com.temenos.microservice.paymentorder.view.EnumCurrency;
import com.temenos.microservice.paymentorder.view.ExchangeRate;
import com.temenos.microservice.paymentorder.view.FileDownloadParams;
import com.temenos.microservice.paymentorder.view.FileUploadRequest;
import com.temenos.microservice.paymentorder.view.GetPaymentOrderParams;
import com.temenos.microservice.paymentorder.view.PaymentMethod;
import com.temenos.microservice.paymentorder.view.PaymentOrder;
import com.temenos.microservice.paymentorder.view.PaymentOrderStatus;
import com.temenos.microservice.paymentorder.view.PaymentStatus;
import com.temenos.microservice.paymentorder.view.UpdatePaymentOrderParams;

public class PaymentOrderFunctionUnitTest {

	@Before
	public void setup() {
		System.getProperties().setProperty("class.outbox.dao",
				"com.temenos.microservice.framework.core.outbox.OutboxDaoImpl");
		System.getProperties().setProperty("class.inbox.dao",
				"com.temenos.microservice.framework.core.inbox.InboxDaoImpl");
		System.getProperties().setProperty("class.package.name", "com.temenos.microservice.payments.function");
	}

	@Test
	public void testCreateNewPaymentOrder() {
		CreateNewPaymentOrder createNewPaymentOrder = new CreateNewPaymentOrderImpl();
		PaymentOrder paymentOrder = new PaymentOrder();
		Card card = new Card();
		card.setCardid(101L);
		card.setCardname("DEBIT");
		card.setCardlimit(BigDecimal.valueOf(5000));
		PaymentMethod method = new PaymentMethod();
		method.setId(101L);
		method.setName("CashPayment");
		method.setCard(card);
		paymentOrder.setPaymentMethod(method);
		List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
		ExchangeRate exchangeRate1 = new ExchangeRate();
		exchangeRate1.setId(1L);
		exchangeRate1.setName("USDINR");
		exchangeRate1.setValue(BigDecimal.valueOf(65));
		ExchangeRate exchangeRate2 = new ExchangeRate();
		exchangeRate2.setId(2L);
		exchangeRate2.setName("EURINR");
		exchangeRate2.setValue(BigDecimal.valueOf(80));
		exchangeRates.add(exchangeRate1);
		exchangeRates.add(exchangeRate2);
		paymentOrder.setAmount(new BigDecimal("100"));
		paymentOrder.setCurrency(EnumCurrency.USD);
		paymentOrder.setExpires(Long.valueOf("1"));
		paymentOrder.setFromAccount("70010");
		paymentOrder.setToAccount("70012");
		String fileContent = "R2FuZXNhbW9vcnRoaQ==";
		paymentOrder.setFileContent(ByteBuffer.wrap(fileContent.getBytes()));
		CreateNewPaymentOrderInput createNewPaymentOrderInput = new CreateNewPaymentOrderInput(paymentOrder);
		try {
			CamelContext ctx = new DefaultCamelContext();
			Exchange exchange = new DefaultExchange(ctx);
			HttpRequestTransformer<String> httpRequestTransformer = new CamelHttpRequestTransformer(
					"CreateNewPaymentOrder", exchange);
			HttpRequest<String> httpRequest = httpRequestTransformer.transform();
			HttpRequestContext context = FunctionInputBuilder.buildContext(httpRequest);
			PaymentStatus paymentStatus = createNewPaymentOrder.invoke(context, createNewPaymentOrderInput);
			Assert.assertNotNull(paymentStatus);
		} catch (FunctionException e) {
			Assert.fail(e.getMessage());
		}
	}

	@Test
	public void testGetPaymentOrder() {
		GetPaymentOrder getPaymentOrder = new GetPaymentOrderImpl();
		GetPaymentOrderParams getPaymentOrderParams = new GetPaymentOrderParams();
		getPaymentOrderParams.setPaymentId(Arrays.asList("PO~11544~100245~INR~600"));
		GetPaymentOrderInput getPaymentOrderInput = new GetPaymentOrderInput(getPaymentOrderParams);
		try {
			PaymentOrderStatus paymentOrderStatus = getPaymentOrder.invoke(null, getPaymentOrderInput);
			Assert.assertNotNull(paymentOrderStatus);
		} catch (FunctionException e) {
			Assert.fail(e.getMessage());
		}
	}

	@Test
	public void testUpdatePaymentOrders() {
		try {
			CreateNewPaymentOrder createNewPaymentOrder = new CreateNewPaymentOrderImpl();
			PaymentOrder paymentOrder = new PaymentOrder();
			Card card = new Card();
			card.setCardid(101L);
			card.setCardname("DEBIT");
			card.setCardlimit(BigDecimal.valueOf(5000));
			PaymentMethod method = new PaymentMethod();
			method.setId(101L);
			method.setName("CashPayment");
			method.setCard(card);
			paymentOrder.setPaymentMethod(method);
			List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
			ExchangeRate exchangeRate1 = new ExchangeRate();
			exchangeRate1.setId(1L);
			exchangeRate1.setName("USDINR");
			exchangeRate1.setValue(BigDecimal.valueOf(65));
			ExchangeRate exchangeRate2 = new ExchangeRate();
			exchangeRate2.setId(2L);
			exchangeRate2.setName("EURINR");
			exchangeRate2.setValue(BigDecimal.valueOf(80));
			exchangeRates.add(exchangeRate1);
			exchangeRates.add(exchangeRate2);
			paymentOrder.setAmount(new BigDecimal("100"));
			paymentOrder.setCurrency(EnumCurrency.USD);
			paymentOrder.setExpires(Long.valueOf("1"));
			paymentOrder.setFromAccount("70011");
			paymentOrder.setToAccount("70012");
			String fileContent = "R2FuZXNhbW9vcnRoaQ==";
			paymentOrder.setFileContent(ByteBuffer.wrap(fileContent.getBytes()));
			CreateNewPaymentOrderInput createNewPaymentOrderInput = new CreateNewPaymentOrderInput(paymentOrder);
			CamelContext ctx = new DefaultCamelContext();
			Exchange exchange = new DefaultExchange(ctx);
			HttpRequestTransformer<String> httpRequestTransformer = new CamelHttpRequestTransformer(
					"CreateNewPaymentOrder", exchange);
			HttpRequest<String> httpRequest = httpRequestTransformer.transform();
			HttpRequestContext context = FunctionInputBuilder.buildContext(httpRequest);
			PaymentStatus pymtStatus = createNewPaymentOrder.invoke(context, createNewPaymentOrderInput);

			UpdatePaymentOrder updatePaymentOrder = new UpdatePaymentOrderImpl();
			UpdatePaymentOrderParams orderParams = new UpdatePaymentOrderParams();
			orderParams.setPaymentId(Arrays.asList(pymtStatus.getPaymentId()));
			PaymentStatus paymentStatus = new PaymentStatus();
			paymentStatus.setDebitAccount("70011");
			paymentStatus.setDetails("Test");
			paymentStatus.setStatus("test");
			UpdatePaymentOrderInput paymentOrderInput = new UpdatePaymentOrderInput(orderParams, paymentStatus);
			PaymentStatus status = updatePaymentOrder.invoke(null, paymentOrderInput);
			Assert.assertNotNull(status);
		} catch (FunctionException e) {
			Assert.fail(e.getMessage());
		}
	}

	@Test
	@Ignore
	public void testFileUpload() {
		try {
			String data = "data";
			FileUploadRequest fileUploadRequest = new FileUploadRequest();
			DocumentDetails documentDetails = new DocumentDetails();
			documentDetails.setDocumentId("123456");
			documentDetails.setDocumentName("data");
			fileUploadRequest.setDocumentDetails(documentDetails);
			BinaryData binary = new BinaryData();
			binary.setFilename("textresult.txt");
			binary.setData(data.getBytes());
			binary.setMimetype("text/plain");
			List<BinaryData> list = new ArrayList<>();
			list.add(binary);
			fileUploadRequest.setAttachments(list);
			FileUploadInput fileUploadInput = new FileUploadInput(fileUploadRequest);
			FileUpload upload = new FileUploadImpl();
			ApiResponse apiresponse = upload.invoke(null, fileUploadInput);
			Assert.assertNotNull(apiresponse);
		} catch (Exception e) {
			Assert.fail(e.getMessage());
		}
	}

	@Test
	@Ignore
	public void testFileDownload() {
		try {
			String data = "data";
			FileUploadRequest fileUploadRequest = new FileUploadRequest();
			DocumentDetails documentDetails = new DocumentDetails();
			documentDetails.setDocumentId("123456");
			documentDetails.setDocumentName("data");
			fileUploadRequest.setDocumentDetails(documentDetails);
			BinaryData binary = new BinaryData();
			binary.setFilename("fileresult.txt");
			binary.setData(data.getBytes());
			binary.setMimetype("text/plain");
			List<BinaryData> binaryData = new ArrayList<>();
			binaryData.add(binary);
			fileUploadRequest.setAttachments(binaryData);
			FileUploadInput fileUploadInput = new FileUploadInput(fileUploadRequest);
			FileUpload upload = new FileUploadImpl();
			ApiResponse apiresponse = upload.invoke(null, fileUploadInput);

			List<String> list = new ArrayList<>();
			list.add("fileresult.txt");
			FileDownloadParams params = new FileDownloadParams();
			params.setFileName(list);
			FileDownloadInput input = new FileDownloadInput(params);
			FileDownload filedownload = new FileDownloadImpl();
			DownloadApiResponse upiResponse = filedownload.invoke(null, input);
			Assert.assertNotNull(upiResponse);
		} catch (Exception e) {
			Assert.fail(e.getMessage());
		}
	}
}