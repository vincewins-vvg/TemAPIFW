package com.temenos.microservice.payments.dao;

import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.SqlDbDao;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class PaymentOrderDao {

	private static volatile PaymentOrderDao paymentOrderDao = null;
	private static SqlDbDao<PaymentOrder> sqlDao = null;

	private PaymentOrderDao(Class clazz) throws DataAccessException {
		sqlDao = DaoFactory.getSQLDao(clazz);
	}

	/**
	 * Get Payment order Instance.
	 * 
	 * @param clazz
	 * @return
	 * @throws DataAccessException 
	 */
	public static PaymentOrderDao getInstance(Class clazz) throws DataAccessException {
		if (paymentOrderDao == null) {
			synchronized (PaymentOrderDao.class) {
				if (paymentOrderDao == null) {
					paymentOrderDao = new PaymentOrderDao(clazz);
				}
			}
		}
		return paymentOrderDao;
	}

	/**
	 * @return the sqlDao
	 */
	public SqlDbDao<PaymentOrder> getSqlDao() {
		return sqlDao;
	}
}
