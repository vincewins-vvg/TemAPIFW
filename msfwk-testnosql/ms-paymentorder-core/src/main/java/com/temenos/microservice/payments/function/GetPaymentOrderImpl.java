package com.temenos.microservice.payments.function;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.payments.view.ExchangeRate;

import com.temenos.microservice.payments.view.GetPaymentOrderParams;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentOrderStatus;
import com.temenos.microservice.payments.view.PaymentStatus;

/**
 * GetPaymentOrderImpl.
 * 
 * @author kdhanraj
 *
 */
public class GetPaymentOrderImpl implements GetPaymentOrder {

	@Override
	public PaymentOrderStatus invoke(Context ctx, GetPaymentOrderInput input) throws FunctionException {
		validateInput(input);
		GetPaymentOrderParams params = input.getParams().get();

		validateParam(params);
		return executeGetPaymentOrder(params);
	}

	private PaymentOrderStatus executeGetPaymentOrder(GetPaymentOrderParams params) throws FunctionException {
		NoSqlDbDao<com.temenos.microservice.payments.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.payments.entity.PaymentOrder.class);
		Optional<com.temenos.microservice.payments.entity.PaymentOrder> paymentOrderOpt = paymentOrderDao
				.getByPartitionKey(params.getPaymentIds().get(0));
		if (paymentOrderOpt.isPresent()) {
			com.temenos.microservice.payments.entity.PaymentOrder paymentOrder = paymentOrderOpt.get();
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
			
			com.temenos.microservice.payments.view.Card card = new com.temenos.microservice.payments.view.Card();
			card.setCardid(paymentOrder.getPaymentMethod().getCard().getCardid());
			card.setCardname(paymentOrder.getPaymentMethod().getCard().getCardname());
			card.setCardlimit(paymentOrder.getPaymentMethod().getCard().getCardlimit());
			
			com.temenos.microservice.payments.view.PaymentMethod paymentMethod = new com.temenos.microservice.payments.view.PaymentMethod();
			paymentMethod.setId(paymentOrder.getPaymentMethod().getId());
			paymentMethod.setName(paymentOrder.getPaymentMethod().getName());
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
