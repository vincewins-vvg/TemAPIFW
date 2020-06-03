package com.temenos.microservice.payments.core;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.sql.ReferenceDataIdEntity;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.PaymentOrder;
import com.temenos.microservice.payments.function.DeletePaymentOrdersInput;
import com.temenos.microservice.payments.view.AllPaymentStatus;
import com.temenos.microservice.payments.view.ErrorSchema;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.payments.view.PaymentStatus;
import com.temenos.microservice.framework.core.function.Context;
import org.springframework.stereotype.Component;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;

@Component
public class DeletePaymentOrdersProcessor {

	public AllPaymentStatus invoke(Context ctx, DeletePaymentOrdersInput input) throws FunctionException {
				if( input.getParams() == null && input.getParams().get().getPaymentIds().get(0) == null) {
					throw new InvalidInputException(new FailureMessage("The Parameters of Payment Ids are not present"));
				}
				String[] paymentId = input.getParams().get().getPaymentIds().get(0).split(",");
				List<Object> poList = new ArrayList<Object>();
				List<Object> exchangeListList = new ArrayList<Object>();
				for(int i =0;i<paymentId.length;i++) {					
					PaymentOrder paymentOrderOpt = (PaymentOrder) PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao().findById(paymentId[i], com.temenos.microservice.payments.entity.PaymentOrder.class);						
					if(paymentOrderOpt != null) {
					poList.add(paymentOrderOpt);
					for(int j=0;j<paymentOrderOpt.getExchangeRates().size();j++) {
					exchangeListList.add(paymentOrderOpt.getExchangeRates().get(j));
					}
					}
					else {
						throw new InvalidInputException(new FailureMessage("One or more Invalid Payment Order Ids Entered"));
					}
				}					
				if(poList.size() > 1){
				PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.ExchangeRate.class).getSqlDao().deleteByIdList(exchangeListList);	
				PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao().deleteByIdList(poList);	
				} else {
					PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao().deleteById(poList.get(0));
				}
				AllPaymentStatus allPaymentStatus = new AllPaymentStatus();
				PaymentStatus[] paymentStatuses = new PaymentStatus[paymentId.length];
				for(int i=0;i<paymentId.length;i++) {
					PaymentStatus paymentStatus = new PaymentStatus();
					paymentStatus.setStatus("Deleted this PaymentId	: "+paymentId[i]);
					paymentStatuses[i] = paymentStatus;
				}
				allPaymentStatus.addItems(paymentStatuses);
				
		return allPaymentStatus;
	}

}
