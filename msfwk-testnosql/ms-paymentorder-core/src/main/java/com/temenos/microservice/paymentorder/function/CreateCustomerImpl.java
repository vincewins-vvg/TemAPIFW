package com.temenos.microservice.paymentorder.function;

import java.util.Objects;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.paymentorder.view.Customer;
import com.temenos.microservice.paymentorder.view.CustomerStatus;

public class CreateCustomerImpl implements CreateCustomer {

	@Override
	public CustomerStatus invoke(Context ctx, CreateCustomerInput input) throws FunctionException {
		Customer param = input.getBody().get();
		String customerId = param.getCustomerId();
		String name = param.getCustomerName();
		if (Objects.isNull(customerId) || customerId.isEmpty() || Objects.isNull(name) || name.isEmpty()) {
			throw new InvalidInputException(new FailureMessage("CustomerId or name is empty", "400"));
		}
		com.temenos.microservice.paymentorder.entity.Customer customerEntity = new com.temenos.microservice.paymentorder.entity.Customer();
		customerEntity.setAccount(param.getAccount());
		customerEntity.setCustomerId(customerId);
		customerEntity.setCustomerName(name);
		customerEntity.setLoanTypes(param.getLoanTypes());
		DaoFactory.getNoSQLDao(com.temenos.microservice.paymentorder.entity.Customer.class).saveEntity(customerEntity);
		CustomerStatus status = new CustomerStatus();
		status.setCustomerId(customerId);
		status.setStatus("Created");
		return status;
	}
}