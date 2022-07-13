/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function.dataprotection;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.Operator;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.security.MsLogicalOperator;
import com.temenos.microservice.framework.dataprotection.IResolve;
import com.temenos.microservice.paymentorder.entity.Customer;

public class CustomerResolveImpl implements IResolve {

	@Override
	public Object[] resolveEntity(String entityType, String customerId, String partyId) throws FunctionException {
		
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.Customer> customerDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.Customer.class);
		Criteria customercriteria = new Criteria();
		customercriteria.condition(MsLogicalOperator.AND);
		List<Object> customerIdList = new ArrayList<Object>();
		customerIdList.add(customerId);
		customercriteria.add(new CriterionImpl(Customer.PARTITION_KEY_COLUMN, Operator.equal, customerIdList));
		List<com.temenos.microservice.paymentorder.entity.Customer> customerList = customerDao.getByIndexes(customercriteria);
		Object[] object = new Object[1];
		if(customerList != null && !customerList.isEmpty()) {
			object[0] = customerList.get(0);
		}
		return object;
	}

}
