/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function;

import java.util.Objects;
import java.util.Optional;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.paymentorder.entity.PaymentOrder;
import com.temenos.microservice.paymentorder.view.DeletePaymentOrderParams;
import com.temenos.microservice.paymentorder.view.PaymentStatus;
import com.temenos.microservice.payments.event.PaymentDeleted;

public class DeletePaymentOrderImpl implements DeletePaymentOrder {

	@Override
	public PaymentStatus invoke(Context ctx, DeletePaymentOrderInput input) throws FunctionException {
		DeletePaymentOrderParams paymentOrderInput = input.getParams().get();
		if (Objects.isNull(paymentOrderInput.getPaymentId())) {
			throw new InvalidInputException(new FailureMessage("PaymentId is null or empty", "400"));
		}
		String paymentId = paymentOrderInput.getPaymentId().get(0);
		if (paymentId.isEmpty()) {
			throw new InvalidInputException(new FailureMessage("PaymentId is empty", "400"));
		}
		String debitAccount = paymentOrderInput.getDebitAccount().get(0);
		if (debitAccount.isEmpty()) {
			throw new InvalidInputException(new FailureMessage("debitAccount is empty", "400"));
		}
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		Optional<PaymentOrder> paymentOrderOpt = paymentOrderDao.getByPartitionKeyAndSortKey(paymentId,
				debitAccount);
		if (paymentOrderOpt.isPresent()) {
			PaymentOrder paymentOrder = paymentOrderOpt.get();
			PaymentOrder order = new PaymentOrder();
			order.setPaymentOrderId(paymentId);
			order.setDebitAccount(debitAccount);
			try {
				DaoFactory.getNoSQLDao(PaymentOrder.class).deleteEntity(order);
				PaymentDeleted paymentDeleted = new PaymentDeleted();
				paymentDeleted.setPaymentOrderId(paymentId);
				com.temenos.microservice.paymentorder.entity.PaymentOrder entity =  new com.temenos.microservice.paymentorder.entity.PaymentOrder();
				entity.setPaymentOrderId(paymentId);
				paymentOrder.captureOldVersion(entity);
				paymentOrder.setClassName(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
				paymentDeleted.setDiff(paymentOrder.deleteDiff());
				EventManager.raiseBusinessEvent(ctx, new GenericEvent("PaymentDeleted", paymentDeleted));
			} catch (Exception e) {
				throw new InvalidInputException(new FailureMessage("Payment Delete option failed ", "400"));
			}
		} else {
			throw new InvalidInputException(new FailureMessage("Payment order does not exist", "400"));
		}
		
		PaymentStatus paymentStatus = new PaymentStatus();
		paymentStatus.setPaymentId(paymentId);
		paymentStatus.setStatus("DELETED");
		ctx.setBusinessKey(paymentStatus.getPaymentId());
		return paymentStatus;
	}

}
