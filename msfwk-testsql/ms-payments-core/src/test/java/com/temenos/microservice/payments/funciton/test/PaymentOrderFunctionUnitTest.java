package com.temenos.microservice.payments.funciton.test;

import java.io.File;
import java.math.BigDecimal;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.MSTransaction;
import com.temenos.microservice.framework.core.data.sql.ReferenceDataEntity;
import com.temenos.microservice.framework.core.data.sql.ReferenceDataIdEntity;
import com.temenos.microservice.framework.core.function.BinaryData;
import com.temenos.microservice.framework.core.function.RequestContext;
import com.temenos.microservice.framework.core.function.RequestImpl;
import com.temenos.microservice.payments.function.CreateNewPaymentOrder;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderInput;
import com.temenos.microservice.payments.function.GetPaymentOrder;
import com.temenos.microservice.payments.function.GetPaymentOrderImpl;
import com.temenos.microservice.payments.function.GetPaymentOrderInput;
import com.temenos.microservice.payments.function.GetPaymentOrdersImpl;
import com.temenos.microservice.payments.function.UpdatePaymentOrder;
import com.temenos.microservice.payments.function.UpdatePaymentOrderImpl;
import com.temenos.microservice.payments.function.UpdatePaymentOrderInput;
import com.temenos.microservice.payments.view.EnumCurrency;
import com.temenos.microservice.payments.view.GetPaymentOrderParams;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentOrderStatus;
import com.temenos.microservice.payments.view.PaymentStatus;
import com.temenos.microservice.payments.view.UpdatePaymentOrderParams;
<<<<<<< HEAD
import com.temenos.microservice.paymentsorder.function.GetPaymentOrders;
import com.temenos.microservice.paymentsorder.function.GetPaymentOrdersInput;
import com.temenos.microservice.payments.view.Card;
import com.temenos.microservice.paymentsorder.view.GetPaymentOrdersParams;
import com.temenos.microservice.paymentsorder.view.PaymentOrders;
import com.temenos.microservice.payments.view.PaymentMethod;
=======
import com.temenos.microservice.payments.function.GetPaymentOrders;
import com.temenos.microservice.payments.function.GetPaymentOrdersInput;
import com.temenos.microservice.payments.view.GetPaymentOrdersParams;
import com.temenos.microservice.payments.view.PaymentOrders;
>>>>>>> MSF-1923: Knative sql changes

public class PaymentOrderFunctionUnitTest {
	public static Charset charset = Charset.forName("UTF-8");
	public static CharsetEncoder encoder = charset.newEncoder();

	@Before
	public void setup() {
		System.getProperties().setProperty("DATABASE_KEY", "sql");
		System.getProperties().setProperty("temn.msf.security.authz.enabled", "false");
		System.getProperties().setProperty("VALIDATE_PAYMENT_ORDER", "false");
		System.getProperties().setProperty("DATABASE_NAME", "payments");
		System.getProperties().setProperty("DB_USERNAME", "root");
		System.getProperties().setProperty("DB_PASSWORD", "root");
		System.getProperties().setProperty("class.outbox.dao",
				"com.temenos.microservice.framework.core.outbox.OutboxDaoImpl");
	}

	@Test
	public void testCreateNewPaymentOrder() throws Exception {
		try {
			ReferenceDataIdEntity idEntity = new ReferenceDataIdEntity("paymentref", "test");
			ReferenceDataEntity refEntity = new ReferenceDataEntity();
			refEntity.setReferenceDataIdEntity(idEntity);
			refEntity.setDescription("description");
			DaoFactory.getDao(ReferenceDataEntity.class).saveEntity(refEntity);

			CreateNewPaymentOrder createNewPaymentOrder = new CreateNewPaymentOrderImpl();
			PaymentOrder paymentOrder = new PaymentOrder();
			paymentOrder.setAmount(new BigDecimal("100"));
			paymentOrder.setCurrency(EnumCurrency.USD);
			paymentOrder.setExpires(Long.valueOf("1"));
			paymentOrder.setFromAccount("70010");
			paymentOrder.setToAccount("70012");
			paymentOrder.setPaymentReference("test");

			PaymentMethod method = new PaymentMethod();
			method.setId(101L);
			method.setName("cashPayment");
			Card card=new Card();
			card.setCardid(434L);
			card.setCardname("casePayment");
			card.setCardlimit(new BigDecimal(42344));
			method.setCard(card);
			paymentOrder.setPaymentMethod(method);
			String fileContent = "R2FuZXNhbW9vcnRoaQ==";
			ByteBuffer byteBuffer = encoder.encode(CharBuffer.wrap(fileContent));
			paymentOrder.setFileContent(byteBuffer);

			CreateNewPaymentOrderInput createNewPaymentOrderInput = new CreateNewPaymentOrderInput(paymentOrder);
			PaymentStatus paymentStatus = createNewPaymentOrder.invoke(new RequestContext(new RequestImpl()),
					createNewPaymentOrderInput);
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
		MSTransaction transaction = null;
		GetPaymentOrders getPaymentOrders = new GetPaymentOrdersImpl();
		GetPaymentOrdersParams params = new GetPaymentOrdersParams();
		GetPaymentOrdersInput getPaymentOrdersInput = new GetPaymentOrdersInput(params);
		try {
			transaction = beginTransaction();
			PaymentOrders paymentOrders = getPaymentOrders.invoke(null, getPaymentOrdersInput);
			if (transaction != null) {
				transaction.commit();
			}
			Assert.assertNotNull(paymentOrders);
		} catch (FunctionException e) {
			Assert.fail(e.getMessage());
		}
	}

	public MSTransaction beginTransaction() {
		MSTransaction txn = new MSTransaction();
		txn.beginTransaction();
		return txn;
	}

	@Test
	public void testUpdatePaymentOrders() throws Exception {
		try {
			ReferenceDataIdEntity idEntity = new ReferenceDataIdEntity("paymentref", "test");
			ReferenceDataEntity refEntity = new ReferenceDataEntity();
			refEntity.setReferenceDataIdEntity(idEntity);
			refEntity.setDescription("description");
			DaoFactory.getDao(ReferenceDataEntity.class).saveEntity(refEntity);

			CreateNewPaymentOrder createNewPaymentOrder = new CreateNewPaymentOrderImpl();
			PaymentOrder paymentOrder = new PaymentOrder();
			paymentOrder.setAmount(new BigDecimal("100"));
			paymentOrder.setCurrency(EnumCurrency.USD);
			paymentOrder.setExpires(Long.valueOf("1"));
			paymentOrder.setFromAccount("70011");
			paymentOrder.setToAccount("70012");
			paymentOrder.setPaymentReference("test");
			PaymentMethod method = new PaymentMethod();
			method.setId(101L);
			method.setName("cashPayment");
			Card card = new Card();
			card.setCardid(434L);
			card.setCardname("casePayment");
			card.setCardlimit(new BigDecimal(42344));
			method.setCard(card);
			paymentOrder.setPaymentMethod(method);
			String fileContent = "R2FuZXNhbW9vcnRoaQ==";
			ByteBuffer byteBuffer = encoder.encode(CharBuffer.wrap(fileContent));
			paymentOrder.setFileContent(byteBuffer);

			CreateNewPaymentOrderInput createNewPaymentOrderInput = new CreateNewPaymentOrderInput(paymentOrder);
			PaymentStatus PymtStatus = createNewPaymentOrder.invoke(new RequestContext(new RequestImpl()),
					createNewPaymentOrderInput);

			UpdatePaymentOrder updatePaymentOrder = new UpdatePaymentOrderImpl();
			UpdatePaymentOrderParams orderParams = new UpdatePaymentOrderParams();
//			orderParams.setPaymentId(Arrays.asList("70010"));
			orderParams.setPaymentId(Arrays.asList(PymtStatus.getPaymentId()));
			PaymentStatus paymentStatus = new PaymentStatus();
			paymentStatus.setDebitAccount("70011");
			paymentStatus.setDetails("Test");
//			paymentStatus.setPaymentId("12355");
			paymentStatus.setStatus("test");
			UpdatePaymentOrderInput paymentOrderInput = new UpdatePaymentOrderInput(orderParams, paymentStatus);
			PaymentStatus status = updatePaymentOrder.invoke(null, paymentOrderInput);
			Assert.assertNotNull(status);
		} catch (FunctionException e) {
			Assert.fail(e.getMessage());
		}
	}
}