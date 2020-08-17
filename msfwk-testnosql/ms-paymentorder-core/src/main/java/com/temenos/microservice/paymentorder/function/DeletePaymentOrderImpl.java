package com.temenos.microservice.paymentorder.function;

import java.util.Objects;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.paymentorder.entity.PaymentOrder;
import com.temenos.microservice.paymentorder.view.DeletePaymentOrderParams;
import com.temenos.microservice.paymentorder.view.PaymentStatus;

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
		PaymentOrder order = new PaymentOrder();
		order.setPaymentOrderId(paymentId);
		order.setDebitAccount(debitAccount);
		try {
			DaoFactory.getNoSQLDao(PaymentOrder.class).deleteEntity(order);
		} catch (Exception e) {
			throw new InvalidInputException(new FailureMessage("Payment Delete option failed ", "400"));
		}
		PaymentStatus paymentStatus = new PaymentStatus();
		paymentStatus.setPaymentId(paymentId);
		paymentStatus.setStatus("DELETED");
		return paymentStatus;
	}

}
