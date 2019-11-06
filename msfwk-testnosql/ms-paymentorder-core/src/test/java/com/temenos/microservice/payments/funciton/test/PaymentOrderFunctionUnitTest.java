package com.temenos.microservice.payments.funciton.test;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.camel.CamelContext;
import org.apache.camel.Exchange;
import org.apache.camel.impl.DefaultCamelContext;
import org.apache.camel.impl.DefaultExchange;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.FunctionInputBuilder;
import com.temenos.microservice.framework.core.function.HttpJsonRequest;
import com.temenos.microservice.framework.core.function.HttpRequest;
import com.temenos.microservice.framework.core.function.HttpRequestContext;
import com.temenos.microservice.framework.core.function.HttpRequestTransformer;
import com.temenos.microservice.framework.core.function.camel.CamelHttpRequestTransformer;
import com.temenos.microservice.payments.view.Card;
import com.temenos.microservice.payments.view.ExchangeRate;
import com.temenos.microservice.payments.view.PaymentMethod;
import com.temenos.microservice.payments.view.PaymentOrder;

import com.temenos.microservice.payments.function.CreateNewPaymentOrder;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderInput;
import com.temenos.microservice.payments.function.GetPaymentOrder;
import com.temenos.microservice.payments.function.GetPaymentOrderImpl;
import com.temenos.microservice.payments.function.GetPaymentOrderInput;
import com.temenos.microservice.payments.function.GetPaymentOrders;
import com.temenos.microservice.payments.function.GetPaymentOrdersImpl;
import com.temenos.microservice.payments.function.GetPaymentOrdersInput;
import com.temenos.microservice.payments.function.UpdatePaymentOrder;
import com.temenos.microservice.payments.function.UpdatePaymentOrderImpl;
import com.temenos.microservice.payments.function.UpdatePaymentOrderInput;
import com.temenos.microservice.payments.view.ExchangeRate;
import com.temenos.microservice.payments.view.GetPaymentOrderParams;
import com.temenos.microservice.payments.view.PaymentMethod;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentOrderStatus;
import com.temenos.microservice.payments.view.PaymentOrders;
import com.temenos.microservice.payments.view.PaymentStatus;
import com.temenos.microservice.payments.view.UpdatePaymentOrderParams;

public class PaymentOrderFunctionUnitTest {

	@Ignore
	@Test
	public void testCreateNewPaymentOrder() {
		CreateNewPaymentOrder createNewPaymentOrder = new CreateNewPaymentOrderImpl();
		PaymentOrder paymentOrder = new PaymentOrder();
		Card card = new Card();
		card.setCardid(101L);
		card.setCardname("DEBIT");
		card.setCardlimit(BigDecimal.valueOf(5000));
		PaymentMethod method = new PaymentMethod();
		method.setId(1L);
        method.setName("Cash");
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
		paymentOrder.setCurrency("USD");
		paymentOrder.setExpires(Long.valueOf("1"));
		paymentOrder.setFromAccount("70010");
		paymentOrder.setToAccount("70012");
		CreateNewPaymentOrderInput createNewPaymentOrderInput = new CreateNewPaymentOrderInput(paymentOrder);
		try {
			CamelContext ctx = new DefaultCamelContext();
	        Exchange exchange = new DefaultExchange(ctx);
			HttpRequestTransformer<String> httpRequestTransformer = new CamelHttpRequestTransformer("CreateNewPaymentOrder", exchange);
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
		getPaymentOrderParams.setPaymentId(Arrays.asList("70010"));
		GetPaymentOrderInput getPaymentOrderInput = new GetPaymentOrderInput(getPaymentOrderParams);
		try {
			PaymentOrderStatus paymentOrderStatus = getPaymentOrder.invoke(null, getPaymentOrderInput);
			Assert.assertNotNull(paymentOrderStatus);
		} catch (FunctionException e) {
			Assert.fail(e.getMessage());
		}
	}

	//@Test
	public void testGetPaymentOrders() {
		GetPaymentOrders getPaymentOrders = new GetPaymentOrdersImpl();
		GetPaymentOrdersInput getPaymentOrdersInput = new GetPaymentOrdersInput();

		try {
			PaymentOrders paymentOrders = getPaymentOrders.invoke(null, getPaymentOrdersInput);
			Assert.assertNotNull(paymentOrders);
		} catch (FunctionException e) {
			Assert.fail(e.getMessage());
		}
	}

	@Test
	public void testUpdatePaymentOrders() {
		UpdatePaymentOrder updatePaymentOrder = new UpdatePaymentOrderImpl();
		UpdatePaymentOrderParams orderParams = new UpdatePaymentOrderParams();
		orderParams.setPaymentId(Arrays.asList("70010"));
		PaymentStatus paymentStatus = new PaymentStatus();
		paymentStatus.setDebitAccount("70010");
		paymentStatus.setDetails("Test");
		paymentStatus.setPaymentId("12355");
		paymentStatus.setStatus("test");
		UpdatePaymentOrderInput paymentOrderInput = new UpdatePaymentOrderInput(
				orderParams, paymentStatus);
		try {
			PaymentStatus status = updatePaymentOrder.invoke(null, paymentOrderInput);
			Assert.assertNotNull(status);
		} catch (FunctionException e) {
			Assert.fail(e.getMessage());
		}
	}
}
