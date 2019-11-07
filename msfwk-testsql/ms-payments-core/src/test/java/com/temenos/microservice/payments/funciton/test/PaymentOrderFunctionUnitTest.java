package com.temenos.microservice.payments.funciton.test;

import java.math.BigDecimal;
import java.util.Arrays;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import com.temenos.microservice.framework.core.FunctionException;
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
import com.temenos.microservice.payments.view.GetPaymentOrderParams;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentOrderStatus;
import com.temenos.microservice.payments.view.PaymentOrders;
import com.temenos.microservice.payments.view.PaymentStatus;
import com.temenos.microservice.payments.view.UpdatePaymentOrderParams;

public class PaymentOrderFunctionUnitTest {

	@Before
	public void setup() {
		System.getProperties().setProperty("DATABASE_KEY", "sql");
		System.getProperties().setProperty("temn.msf.security.authz.enabled", "false");
		System.getProperties().setProperty("VALIDATE_PAYMENT_ORDER", "false");
		System.getProperties().setProperty("DATABASE_NAME", "payments");
		System.getProperties().setProperty("DB_USERNAME", "root");
		System.getProperties().setProperty("DB_PASSWORD", "root");
	}

	@Test
	public void testCreateNewPaymentOrder() {
		CreateNewPaymentOrder createNewPaymentOrder = new CreateNewPaymentOrderImpl();
		PaymentOrder paymentOrder = new PaymentOrder();
		paymentOrder.setAmount(new BigDecimal("100"));
		paymentOrder.setCurrency("USD");
		paymentOrder.setExpires(Long.valueOf("1"));
		paymentOrder.setFromAccount("70010");
		paymentOrder.setToAccount("70012");
		CreateNewPaymentOrderInput createNewPaymentOrderInput = new CreateNewPaymentOrderInput(paymentOrder);
		try {
			PaymentStatus paymentStatus = createNewPaymentOrder.invoke(null, createNewPaymentOrderInput);
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

	@Test
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
		UpdatePaymentOrderInput paymentOrderInput = new UpdatePaymentOrderInput(orderParams, paymentStatus);
		try {
			PaymentStatus status = updatePaymentOrder.invoke(null, paymentOrderInput);
			Assert.assertNotNull(status);
		} catch (FunctionException e) {
			Assert.fail(e.getMessage());
		}
	}
}
