package com.temenos.microservice.payments.core;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.function.GetPaymentOrderInput;
import com.temenos.microservice.payments.view.GetPaymentOrderParams;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentOrderStatus;
import com.temenos.microservice.payments.view.PaymentStatus;

@Component
public class GetPaymentOrderProcessor {
 
	
	public PaymentOrderStatus invoke(Context ctx, GetPaymentOrderInput input) throws FunctionException {
		validateInput(input);
		GetPaymentOrderParams params = input.getParams().get();
		validateParam(params);
		return executeGetPaymentOrder(params);
	}

	private PaymentOrderStatus executeGetPaymentOrder(GetPaymentOrderParams params) throws FunctionException {

		com.temenos.microservice.payments.entity.PaymentOrder paymentOrder = (com.temenos.microservice.payments.entity.PaymentOrder) PaymentOrderDao
				.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.findById(params.getPaymentIds().get(0), com.temenos.microservice.payments.entity.PaymentOrder.class);
		
		if (paymentOrder != null) {

			PaymentStatus paymentStatus = new PaymentStatus();
			paymentStatus.setPaymentId(paymentOrder.getPaymentOrderId());
			paymentStatus.setStatus(paymentOrder.getStatus());
			paymentStatus.setDetails(paymentOrder.getPaymentDetails());

			PaymentOrderStatus paymentOrderStatus = new PaymentOrderStatus();
			PaymentOrder order = new PaymentOrder();
			order.setAmount(paymentOrder.getAmount());
			order.setCurrency(paymentOrder.getCurrency());
			order.setFromAccount(paymentOrder.getDebitAccount());
			order.setToAccount(paymentOrder.getCreditAccount());
			order.setPaymentDetails(paymentOrder.getPaymentDetails());
			order.setPaymentReference(paymentOrder.getPaymentReference());
			paymentOrderStatus.setPaymentOrder(order);
			paymentOrderStatus.setPaymentStatus(paymentStatus);
			return paymentOrderStatus;
		}
		return new PaymentOrderStatus();
	}

	private void validateParam(GetPaymentOrderParams params) throws InvalidInputException {
		List<String> paymentIds = params.getPaymentIds();
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