/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function.dataprotection;

import java.util.Map;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.dataprotection.IResolve;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class PaymentOrderResolveImpl implements IResolve{

	@Override
	public Object[] resolveEntity(String entityType, String customerId, String partyId,
			Map<String, String> customEntityIdentifier) throws FunctionException {
		PaymentOrder paymentOrder = (PaymentOrder) PaymentOrderDao
				.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.findById(customerId, PaymentOrder.class);
		Object[] object = new Object[1];
		object[0] = paymentOrder;
		return object;
	}
}
