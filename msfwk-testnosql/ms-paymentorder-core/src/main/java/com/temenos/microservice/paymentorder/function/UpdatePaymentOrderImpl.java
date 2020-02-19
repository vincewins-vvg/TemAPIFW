package com.temenos.microservice.paymentorder.function;

import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.paymentorder.entity.Card;
import com.temenos.microservice.paymentorder.entity.ExchangeRate;
import com.temenos.microservice.paymentorder.entity.PaymentMethod;

import com.temenos.microservice.paymentorder.entity.PaymentOrder;
import com.temenos.microservice.paymentorder.function.UpdatePaymentOrder;
import com.temenos.microservice.paymentorder.function.UpdatePaymentOrderInput;
import com.temenos.microservice.paymentorder.view.PaymentStatus;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;

public class UpdatePaymentOrderImpl implements UpdatePaymentOrder {

    @Override
	public PaymentStatus invoke(Context ctx, UpdatePaymentOrderInput input) throws FunctionException {
		PaymentStatus paymentStatus = input.getBody().get();
		String paymentOrderId = input.getParams().get().getPaymentIds().get(0);
		String debitAccount = input.getBody().get().getDebitAccount();
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		Optional<PaymentOrder> paymentOrderOpt = paymentOrderDao.getByPartitionKeyAndSortKey(
				paymentOrderId, debitAccount);
		if (paymentOrderOpt.isPresent()) {
			PaymentOrder paymentOrder = paymentOrderOpt.get();
			paymentOrder.setStatus(paymentStatus.getStatus());
			
			Card card = new Card();
			card.setCardid(paymentStatus.getPaymentMethod().getCard().getCardid());
			card.setCardname(paymentStatus.getPaymentMethod().getCard().getCardname());
			card.setCardlimit(paymentStatus.getPaymentMethod().getCard().getCardlimit());
			
			PaymentMethod paymentMethod = new PaymentMethod();
			paymentMethod.setId(paymentStatus.getPaymentMethod().getId());
			paymentMethod.setName(paymentStatus.getPaymentMethod().getName());
			paymentMethod.setCard(card);
			paymentOrder.setPaymentMethod(paymentMethod);

			List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
			for (com.temenos.microservice.paymentorder.view.ExchangeRate erView : paymentStatus.getExchangeRatess()) {
				ExchangeRate exchangeRate = new ExchangeRate();
				exchangeRate.setId(erView.getId());
				exchangeRate.setName(erView.getName());
				exchangeRate.setValue(erView.getValue());
				exchangeRates.add(exchangeRate);
			}
			paymentOrder.setExchangeRates(exchangeRates);
			
			paymentOrderDao.saveEntity(paymentOrder);
		}
		return readStatus(debitAccount, paymentOrderId);
	}
    
    private PaymentStatus readStatus(String debitAccount, String paymentOrderId) throws FunctionException {
        NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
                .getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
        Optional<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderOpt = paymentOrderDao
                .getByPartitionKeyAndSortKey(paymentOrderId, debitAccount);
        PaymentStatus paymentStatus = new PaymentStatus();
		if (paymentOrderOpt.isPresent()) {
			PaymentOrder paymentOrder = paymentOrderOpt.get();
			paymentStatus.setPaymentId(paymentOrderId);
			paymentStatus.setStatus(paymentOrder.getStatus());
		}
        return paymentStatus;
    }
}
