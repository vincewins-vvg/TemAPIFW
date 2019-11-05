package com.temenos.microservice.payments.core;

import java.time.Instant;
import java.util.Date;

import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderInput;
import com.temenos.microservice.payments.function.PaymentOrderFunctionHelper;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentStatus;

@Component
public class CreateNewPaymentOrderProcessor {

	public PaymentStatus invoke(Context ctx, CreateNewPaymentOrderInput input) throws FunctionException {

		PaymentOrderFunctionHelper.validateInput(input);

		PaymentOrder paymentOrder = input.getBody().get();
		if (Environment.getEnvironmentVariable("VALIDATE_PAYMENT_ORDER", "").equalsIgnoreCase("true")) {
			PaymentOrderFunctionHelper.validatePaymentOrder(paymentOrder, ctx);
		}

		PaymentStatus paymentStatus = executePaymentOrder(paymentOrder);
		return paymentStatus;
	}

	private PaymentStatus executePaymentOrder(PaymentOrder paymentOrder) throws FunctionException {
		String paymentOrderId = ("PO~" + paymentOrder.getFromAccount() + "~" + paymentOrder.getToAccount() + "~"
				+ paymentOrder.getCurrency() + "~" + paymentOrder.getAmount()).toUpperCase();

		createEntity(paymentOrderId, paymentOrder);
		return readStatus(paymentOrder.getFromAccount(), paymentOrderId);
	}

	private void createEntity(String paymentOrderId, PaymentOrder view) throws FunctionException {
		com.temenos.microservice.payments.entity.PaymentOrder entity = new com.temenos.microservice.payments.entity.PaymentOrder();
		entity.setPaymentOrderId(paymentOrderId);
		entity.setAmount(view.getAmount());
		entity.setCreditAccount(view.getToAccount());
		entity.setDebitAccount(view.getFromAccount());
		entity.setPaymentDate(Date.from(Instant.now()));
		entity.setCurrency(view.getCurrency());
		entity.setPaymentReference(view.getPaymentReference());
		entity.setPaymentDetails(view.getPaymentDetails());
		entity.setStatus("INITIATED");
		PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.save(entity);

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
}
