package com.temenos.microservice.payments.core;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.Card;
import com.temenos.microservice.payments.entity.PaymentMethod;
import com.temenos.microservice.payments.entity.PaymentOrder;
import com.temenos.microservice.payments.function.UpdatePaymentOrderInput;
import com.temenos.microservice.payments.view.PaymentStatus;
import com.temenos.microservice.payments.entity.ExchangeRate;

@Component
public class UpdatePaymentOrderProcessor {

	public PaymentStatus invoke(Context ctx, UpdatePaymentOrderInput input) throws FunctionException {
		PaymentStatus paymentStatus = input.getBody().get();
		String paymentOrderId = input.getParams().get().getPaymentId().get(0);
		String debitAccount = input.getBody().get().getDebitAccount();
		PaymentOrder paymentOrderOpt = (PaymentOrder) PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao()
				.findById(paymentOrderId, com.temenos.microservice.payments.entity.PaymentOrder.class);
		if (paymentOrderOpt != null) {
			paymentOrderOpt.setStatus(paymentStatus.getStatus());
			if (paymentStatus.getPaymentMethod() != null) {
				Card card = new Card();
				card.setCardid(paymentStatus.getPaymentMethod().getCard().getCardid());
				card.setCardname(paymentStatus.getPaymentMethod().getCard().getCardname());
				card.setCardlimit(paymentStatus.getPaymentMethod().getCard().getCardlimit());

				PaymentMethod paymentMethod = new PaymentMethod();
				paymentMethod.setId(paymentStatus.getPaymentMethod().getId());
				paymentMethod.setName(paymentStatus.getPaymentMethod().getName());
				paymentMethod.setCard(card);
				paymentOrderOpt.setPaymentMethod(paymentMethod);
			}
			if (paymentStatus.getExchangeRates() != null) {
				List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
				for (com.temenos.microservice.payments.view.ExchangeRate exchangeView : paymentStatus
						.getExchangeRates()) {
					ExchangeRate exchangeRate = new ExchangeRate();
					exchangeRate.setId(exchangeView.getId());
					exchangeRate.setName(exchangeView.getName());
					exchangeRate.setValue(exchangeView.getValue());
					exchangeRates.add(exchangeRate);
				}
				paymentOrderOpt.setExchangeRates(exchangeRates);
			}
			PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao().save(paymentOrderOpt);
		}
		return readStatus(debitAccount, paymentOrderId, paymentStatus.getStatus());
	}

	private PaymentStatus readStatus(String debitAccount, String paymentOrderId, String status)
			throws FunctionException {
		PaymentOrder paymentOrderOpt = (PaymentOrder) PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao()
				.findById(paymentOrderId, com.temenos.microservice.payments.entity.PaymentOrder.class);
		PaymentStatus paymentStatus = new PaymentStatus();
		if (paymentOrderOpt != null) {
			paymentStatus.setPaymentId(paymentOrderId);
			paymentStatus.setStatus(status);
		}
		return paymentStatus;
	}
}
