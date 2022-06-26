/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function.dataprotection;

import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.dataprotection.IResolve;

public class PaymentOrderResolveImpl implements IResolve{

	@Override
	public Object[] resolveEntity(String entityType, String customerId, String partyId) throws FunctionException {
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		String paymentorderId = customerId;
		Optional<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderOpt = paymentOrderDao.getByPartitionKey(paymentorderId);
		Object[] object = new Object[1];
		if(paymentOrderOpt.isPresent()) {
			object[0] = paymentOrderOpt.get();
		}
		return object;
	}
}
