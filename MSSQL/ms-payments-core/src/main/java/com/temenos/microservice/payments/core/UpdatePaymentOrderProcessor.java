package com.temenos.microservice.payments.core;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.PaymentOrder;
import com.temenos.microservice.payments.function.UpdatePaymentOrderInput;
import com.temenos.microservice.payments.view.PaymentStatus;

@Component
public class UpdatePaymentOrderProcessor {

	 
	  
	public PaymentStatus invoke(Context ctx, UpdatePaymentOrderInput input) throws FunctionException {
		PaymentStatus paymentStatus = input.getBody().get();
		String paymentOrderId = input.getParams().get().getPaymentIds().get(0);
		String debitAccount = input.getBody().get().getDebitAccount();
		 PaymentOrder paymentOrderOpt = (PaymentOrder)
				PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao().findById(paymentOrderId,
						com.temenos.microservice.payments.entity.PaymentOrder.class);
		if (paymentOrderOpt !=null) {
			paymentOrderOpt.setStatus(paymentStatus.getStatus());
			PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao().save(paymentOrderOpt);
		}
		return readStatus(debitAccount, paymentOrderId);
	}
    
    private PaymentStatus readStatus(String debitAccount, String paymentOrderId) throws FunctionException {
         
    	 PaymentOrder paymentOrderOpt = (PaymentOrder)
 				PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao().findById(paymentOrderId,
 						com.temenos.microservice.payments.entity.PaymentOrder.class);
        PaymentStatus paymentStatus = new PaymentStatus();
		if (paymentOrderOpt != null) {
			paymentStatus.setPaymentId(paymentOrderId);
			paymentStatus.setStatus(paymentOrderOpt.getStatus());
		}
        return paymentStatus;
    }
}
