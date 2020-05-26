package com.temenos.microservice.paymentorder.function;

import static com.temenos.microservice.framework.core.util.OpenAPIUtil.formatDate;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.paymentorderschema.view.EnumCurrency;
import com.temenos.microservice.paymentorderschema.view.ExchangeRate;

import com.temenos.microservice.paymentorderschema.function.GetPaymentOrders;
import com.temenos.microservice.paymentorderschema.function.GetPaymentOrdersInput;
import com.temenos.microservice.paymentorderschema.view.PaymentOrder;
import com.temenos.microservice.paymentorderschema.view.PaymentOrders;
import com.temenos.microservice.framework.core.FunctionException;

public class GetPaymentOrdersImpl implements GetPaymentOrders {

	@Override
	public PaymentOrders invoke(Context ctx, GetPaymentOrdersInput input) throws FunctionException {
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		
		List<com.temenos.microservice.paymentorder.entity.PaymentOrder> entities = null;
        
        if(input.getParams().get().getPageNumber() != null || input.getParams().get().getPageSize() != null){ 
        	int[] pageDetails = new int[2];
        	if(input.getParams().get().getPageNumber() != null) {
        		if(input.getParams().get().getPageNumber().get(0) != null && input.getParams().get().getPageNumber().get(0) > 0) 
    	    	pageDetails[0] = input.getParams().get().getPageNumber().get(0);
        	}
        	if(input.getParams().get().getPageSize() != null) {
        		if(input.getParams().get().getPageSize().get(0) != null && input.getParams().get().getPageSize().get(0) > 0) 
    	    	pageDetails[1] = input.getParams().get().getPageSize().get(0);
        	}
            entities = paymentOrderDao.get(pageDetails);
        }
        else{
      	    entities = paymentOrderDao.get();
        }
		
		List<PaymentOrder> views = new ArrayList<PaymentOrder>();
		for (com.temenos.microservice.paymentorder.entity.PaymentOrder entity : entities) {
			PaymentOrder view = new PaymentOrder();
			view.setAmount(entity.getAmount());
			view.setCurrency(Enum.valueOf(EnumCurrency.class, entity.getCurrency()));
			view.setFromAccount(entity.getDebitAccount());
			view.setToAccount(entity.getCreditAccount());
			view.setFileContent(entity.getFileContent());
			view.setPaymentDate(formatDate(entity.getPaymentDate()));
			view.setPaymentDetails(entity.getPaymentDetails());
			view.setExtensionData(entity.getExtensionData());

			com.temenos.microservice.paymentorderschema.view.Card card = new com.temenos.microservice.paymentorderschema.view.Card();
			if (entity.getPaymentMethod() != null) {
				if (entity.getPaymentMethod().getCard() != null) {
					card.setCardid(entity.getPaymentMethod().getCard().getCardid());
					card.setCardname(entity.getPaymentMethod().getCard().getCardname());
					card.setCardlimit(entity.getPaymentMethod().getCard().getCardlimit());
				}

				com.temenos.microservice.paymentorderschema.view.PaymentMethod paymentMethod = new com.temenos.microservice.paymentorderschema.view.PaymentMethod();
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
				
				com.temenos.microservice.paymentorderschema.view.PayeeDetails payeeDtls = new com.temenos.microservice.paymentorderschema.view.PayeeDetails();
				if (entity.getPayeeDetails() != null) {
					payeeDtls.setPayeeName(entity.getPayeeDetails().getPayeeName());
					payeeDtls.setPayeeType(entity.getPayeeDetails().getPayeeType());
					view.setPayeeDetails(payeeDtls);
				}
			}
			views.add(view);
		}
		PaymentOrders orders = new PaymentOrders();
		orders.addItems(views.toArray(new PaymentOrder[0]));
		return orders;
	}
}
