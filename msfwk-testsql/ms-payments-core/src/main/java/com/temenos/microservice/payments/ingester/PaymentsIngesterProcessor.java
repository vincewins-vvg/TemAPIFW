package com.temenos.microservice.payments.ingester;

import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.DatabaseOperationException;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.PaymentOrder;

@Component
public class PaymentsIngesterProcessor {

	public void ingestPaymentOrder(PaymentOrder paymentOrder) throws DatabaseOperationException, DataAccessException {
		PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao().save(paymentOrder);
	}
}
