package com.temenos.microservice.payments.core;

import java.time.Instant;
import java.util.Date;
import java.util.UUID;

import org.springframework.stereotype.Component;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.PayeeDetails;
import com.temenos.microservice.payments.event.CreatePaymentEvent;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderInput;
import com.temenos.microservice.payments.function.PaymentOrderFunctionHelper;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentStatus;

@Component
public class CreateNewPaymentOrderProcessor {

	public PaymentStatus invoke(Context ctx, CreateNewPaymentOrderInput input) throws FunctionException {

		PaymentOrderFunctionHelper.validateInput(input);

		PaymentOrder paymentOrder = input.getBody().get();
		PaymentOrderFunctionHelper.validatePaymentOrder(paymentOrder, ctx);

		PaymentStatus paymentStatus = executePaymentOrder(ctx, paymentOrder);
		return paymentStatus;
	}

	private PaymentStatus executePaymentOrder(Context ctx, PaymentOrder paymentOrder) throws FunctionException {
		String paymentOrderId = ("PO~" + paymentOrder.getFromAccount() + "~" + paymentOrder.getToAccount() + "~"
				+ paymentOrder.getCurrency() + "~" + paymentOrder.getAmount()).toUpperCase();

		com.temenos.microservice.payments.entity.PaymentOrder entity = createEntity(ctx, paymentOrderId, paymentOrder);
		// return readStatus(paymentOrder.getFromAccount(), paymentOrderId);
		return readStatus(entity);
	}

	private com.temenos.microservice.payments.entity.PaymentOrder createEntity(Context ctx, String paymentOrderId,
			PaymentOrder view) throws FunctionException {
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

		if (view.getPayeeDetails() != null) {
			PayeeDetails payeeDetails = new PayeeDetails();
			payeeDetails.setPayeeName(view.getPayeeDetails().getPayeeName());
			payeeDetails.setPayeeType(view.getPayeeDetails().getPayeeType());
			entity.setPayeeDetails(payeeDetails);
		}

		PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.save(entity);
		CreatePaymentEvent paymentOrderEvent = new CreatePaymentEvent();
		paymentOrderEvent.setPaymentOrderId(entity.getPaymentOrderId());
		paymentOrderEvent.setAmount(entity.getAmount());
		paymentOrderEvent.setCreditAccount(entity.getCreditAccount());
		paymentOrderEvent.setCurrency(entity.getCurrency());
		paymentOrderEvent.setDebitAccount(entity.getDebitAccount());
		
		EventManager.raiseBusinessEvent(ctx, new GenericEvent(Environment.getMSName() + ".PaymentOrderCreated", paymentOrderEvent));
		return entity;
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
}
