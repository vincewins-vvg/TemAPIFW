package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.sql.SqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.view.EmployeeRequest;
import com.temenos.microservice.payments.view.EmployeeStatus;

public class CreateEmployeeImpl implements CreateEmployee {

	@Override
	public EmployeeStatus invoke(Context ctx, CreateEmployeeInput input) throws FunctionException {

		EmployeeRequest employeeRequest = null;

		if (input.getBody() == null || input.getBody().get().getName() == null
				|| input.getBody().get().getName().length() == 0
				|| !input.getBody().get().getName().matches("[A-Za-z]*")) {

			throw new InvalidInputException(
					new FailureMessage("Invalid Request Body", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));

		}

		employeeRequest = input.getBody().get();
		EmployeeStatus employeeStatus = new EmployeeStatus();
		try {
			com.temenos.microservice.payments.entity.Employee employee = new com.temenos.microservice.payments.entity.Employee();

			employee.setName(employeeRequest.getName());
			String orgCode = employeeRequest.getOrgCode()!=null ? employeeRequest.getOrgCode() : "ABC";
			employee.setOrgCode(orgCode);

			SqlDbDao<Entity> employeeDao = DaoFactory
					.getSQLDao(com.temenos.microservice.payments.entity.Employee.class);
			Entity employeeEntity = employeeDao.save(employee);
			com.temenos.microservice.payments.entity.Employee savedEmployee = (com.temenos.microservice.payments.entity.Employee) employeeEntity;

			employeeStatus.setEmployeeId(savedEmployee.getEmployeeId());
			employeeStatus.setStatus("Successful");
		} catch (Exception e) {
			throw new InvalidInputException(
					new FailureMessage("Cannot save in db", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}

		return employeeStatus;

	}

}