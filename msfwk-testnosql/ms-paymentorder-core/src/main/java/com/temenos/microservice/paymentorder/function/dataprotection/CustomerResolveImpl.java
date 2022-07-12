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
import com.temenos.microservice.framework.dataprotection.IResolve;

public class CustomerResolveImpl implements IResolve {

	@Override
	public Object[] resolveEntity(String entityType, String customerId, String partyId) throws FunctionException {
		
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.Customer> customerDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.Customer.class);
		Optional<com.temenos.microservice.paymentorder.entity.Customer> customerOptional = customerDao.getByPartitionKey(customerId);
		Object[] object = new Object[1];
		if (customerOptional.isPresent()) {
			object[0] = customerOptional.get();
		}
		return object;
	}

}
