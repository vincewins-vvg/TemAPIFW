package com.temenos.microservice.paymentorder.function;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.Operator;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.security.MsLogicalOperator;
import com.temenos.microservice.paymentorder.entity.Customer;
import com.temenos.microservice.paymentorder.view.Customers;
import com.temenos.microservice.paymentorder.view.GetCustomersParams;

public class GetCustomerImpl implements GetCustomers {

	@Override
	public Customers invoke(Context ctx, GetCustomersInput input) throws FunctionException {
		GetCustomersParams params = input.getParams().get();
		List<String> accountId = params.getAccount();
		List<String> loanTypes = params.getLoanTypes();
		Criteria criteria = new Criteria();
		criteria.condition(MsLogicalOperator.AND);
		if (Objects.nonNull(accountId) && !accountId.isEmpty()) {
			List<Object> objectList = new ArrayList<>(accountId);
			criteria.add(new CriterionImpl("account", Operator.in, objectList));
		}
		if (Objects.nonNull(loanTypes) && !loanTypes.isEmpty()) {
			List<Object> objectList = new ArrayList<>(loanTypes);
			criteria.add(new CriterionImpl("loanTypes", Operator.contains, objectList));
		}
		List<Entity> entityList = DaoFactory.getNoSQLDao(Customer.class).getByIndexes(criteria);
		Customers customers = new Customers();
		if (!entityList.isEmpty()) {
			entityList.stream().forEach(entity -> {
				Customer customerEntity = (Customer) entity;
				com.temenos.microservice.paymentorder.view.Customer customerView = new com.temenos.microservice.paymentorder.view.Customer();
				customerView.setAccount(customerEntity.getAccount());
				customerView.setCustomerId(customerEntity.getCustomerId());
				customerView.setCustomerName(customerEntity.getCustomerName());
				customerView.setLoanTypes(customerEntity.getLoanTypes());
				customers.add(customerView);
			});
		} else {
			throw new InvalidInputException(new FailureMessage("No Record found", "400"));
		}

		return customers;
	}

}