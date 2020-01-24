package com.temenos.microservice.payments.dao;

import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.sql.BaseSqlDao;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class PaymentOrderDao<T>  extends BaseSqlDao<PaymentOrder> {

	private PaymentOrderDao(Class clazz) throws DataAccessException {
		 super(clazz);
	}

	/**
	 * Get Payment order Instance.
	 * 
	 * @param clazz
	 * @return
	 * @throws DataAccessException 
	 */
	public static PaymentOrderDao<PaymentOrder> getInstance(Class clazz) throws DataAccessException {
		
		return new PaymentOrderDao<PaymentOrder>(clazz);
	}

}
