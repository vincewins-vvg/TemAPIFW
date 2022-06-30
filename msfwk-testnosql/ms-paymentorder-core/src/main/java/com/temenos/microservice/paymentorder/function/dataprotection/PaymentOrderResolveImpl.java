/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function.dataprotection;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.Operator;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.security.MsLogicalOperator;
import com.temenos.microservice.framework.dataprotection.IResolve;
import com.temenos.microservice.paymentorder.entity.Customer;
import com.temenos.microservice.paymentorder.entity.PaymentOrder;

public class PaymentOrderResolveImpl implements IResolve {

	@Override
	public Object[] resolveEntity(String entityType, String customerId, String partyId) throws FunctionException {
		
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.Customer> customerDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.Customer.class);
		Optional<com.temenos.microservice.paymentorder.entity.Customer> customerOptional = customerDao.getByPartitionKey(customerId);
		if(customerOptional.isPresent()) {
			String accountId = customerOptional.get().getAccount();
			NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
					.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
			
			Criteria criteria = new Criteria();
			criteria.condition(MsLogicalOperator.AND);
			if (Objects.nonNull(accountId) && !accountId.isEmpty()) {
				List<Object> objectList = new ArrayList<Object>();
				objectList.add(accountId);
				criteria.add(new CriterionImpl(PaymentOrder.SORT_KEY_COLUMN, Operator.equal, objectList));
				List<PaymentOrder> entityList = paymentOrderDao.getByIndexes(criteria);
				if (entityList != null && !entityList.isEmpty()) {
					return entityList.toArray();
				}
			}
		}
		return null;
	}
}
