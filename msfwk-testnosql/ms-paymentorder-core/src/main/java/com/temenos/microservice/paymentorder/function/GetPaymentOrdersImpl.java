package com.temenos.microservice.paymentorder.function;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.paymentorder.view.ExchangeRate;

import com.temenos.microservice.paymentorder.function.GetPaymentOrders;
import com.temenos.microservice.paymentorder.function.GetPaymentOrdersInput;
import com.temenos.microservice.paymentorder.view.PaymentOrder;
import com.temenos.microservice.paymentorder.view.PaymentOrders;
import com.temenos.microservice.framework.core.FunctionException;

public class GetPaymentOrdersImpl implements GetPaymentOrders {

    @Override
    public PaymentOrders invoke(Context ctx, GetPaymentOrdersInput input) throws FunctionException {
        NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
                .getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
        List<com.temenos.microservice.paymentorder.entity.PaymentOrder> entities = paymentOrderDao.get();
        List<PaymentOrder> views = new ArrayList<PaymentOrder>();
        for (com.temenos.microservice.paymentorder.entity.PaymentOrder entity : entities) {
            PaymentOrder view = new PaymentOrder();
            view.setAmount(entity.getAmount());
            view.setCurrency(entity.getCurrency());
            view.setFromAccount(entity.getDebitAccount());
            view.setToAccount(entity.getCreditAccount());
            view.setFileContent(entity.getFileContent());
            
            com.temenos.microservice.paymentorder.view.Card card = new com.temenos.microservice.paymentorder.view.Card();
            if(entity.getPaymentMethod()!=null) {
            	if(entity.getPaymentMethod().getCard()!=null) {
            	
			card.setCardid(entity.getPaymentMethod().getCard().getCardid());
			card.setCardname(entity.getPaymentMethod().getCard().getCardname());
			card.setCardlimit(entity.getPaymentMethod().getCard().getCardlimit());
            	}
            
            com.temenos.microservice.paymentorder.view.PaymentMethod paymentMethod = new com.temenos.microservice.paymentorder.view.PaymentMethod();
			paymentMethod.setId(entity.getPaymentMethod().getId());
			paymentMethod.setName(entity.getPaymentMethod().getName());
			paymentMethod.setCard(card);
			view.setPaymentMethod(paymentMethod);

			List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
			for (com.temenos.microservice.paymentorder.entity.ExchangeRate erEntity : entity.getExchangeRates()) {
				ExchangeRate exchangeRate = new ExchangeRate();
				exchangeRate.setId(erEntity.getId());
				exchangeRate.setName(erEntity.getName());
				exchangeRate.setValue(erEntity.getValue());
				exchangeRates.add(exchangeRate);
			}
			view.setExchangeRates(exchangeRates);
            }
            views.add(view);
        }
        PaymentOrders orders = new PaymentOrders();
        orders.addItems(views.toArray(new PaymentOrder[0]));
        return orders;
    }
}