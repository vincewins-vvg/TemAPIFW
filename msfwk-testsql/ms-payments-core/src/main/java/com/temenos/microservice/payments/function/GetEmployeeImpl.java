package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.payments.dao.EmployeeDao;
import com.temenos.microservice.payments.exception.NoDataFoundException;
import com.temenos.microservice.payments.view.Employee;
import com.temenos.microservice.payments.view.GetEmployeeParams;

public class GetEmployeeImpl implements GetEmployee {

	@Override
	public Employee invoke(Context ctx, GetEmployeeInput input) throws FunctionException {
		// TODO Auto-generated method stub

		if (!input.getParams().isPresent()) {
			throw new InvalidInputException(new FailureMessage("Input param is empty", "EmptyInput-2001"));
		}
		GetEmployeeParams employeeParams = input.getParams().get();
		String employeeId = "";
		if (employeeParams != null)
			employeeId = employeeParams.getEmployeeId().get(0);

		Entity employeeEntity = EmployeeDao.getInstance(com.temenos.microservice.payments.entity.Employee.class)
				.getSqlDao().findById(employeeId, com.temenos.microservice.payments.entity.Employee.class);

		com.temenos.microservice.payments.entity.Employee fetchedEmployee = null;

		if (employeeEntity != null) {
			fetchedEmployee = (com.temenos.microservice.payments.entity.Employee) employeeEntity;
			Employee employeeResponse = new Employee();
			employeeResponse.setEmployeeId(fetchedEmployee.getEmployeeId());
			employeeResponse.setName(fetchedEmployee.getName());
			return employeeResponse;

		} else {
			throw new NoDataFoundException(new FailureMessage("ID is not present in DB"));
		}
	}

}