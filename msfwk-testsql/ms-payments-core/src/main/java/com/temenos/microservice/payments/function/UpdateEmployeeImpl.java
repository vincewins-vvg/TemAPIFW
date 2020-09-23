package com.temenos.microservice.payments.function;

import java.util.Arrays;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaUpdate;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.sql.SqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.entity.Employee;
import com.temenos.microservice.payments.function.UpdateEmployee;
import com.temenos.microservice.payments.function.UpdateEmployeeInput;
import com.temenos.microservice.payments.view.EmployeeRequest;
import com.temenos.microservice.payments.view.EmployeeStatus;

public class UpdateEmployeeImpl implements UpdateEmployee {

	@Override
	public EmployeeStatus invoke(Context ctx, UpdateEmployeeInput input) throws FunctionException {
		EmployeeRequest employeeRequest = null;
		if (!input.getParams().isPresent() || input.getParams().get().getEmployeeId().isEmpty() || !input.getBody().isPresent() || input.getBody().get().getName() == null
				|| input.getBody().get().getName().length() == 0
				|| !input.getBody().get().getName().matches("[A-Za-z]*")) {
			throw new InvalidInputException(
					new FailureMessage("Invalid Request Body", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}
		employeeRequest = input.getBody().get();
		EmployeeStatus employeeStatus = new EmployeeStatus();
		Employee employee = new Employee();
		int count = 0;
		employee.setName(employeeRequest.getName());
		CriteriaBuilder criteriaBuilder = DaoFactory.getSQLDao(Employee.class).getEntityManager().getCriteriaBuilder();
		CriteriaUpdate<Employee> criteriaUpdate = criteriaBuilder.createCriteriaUpdate(Employee.class);
		Root<Employee> root = criteriaUpdate.from(Employee.class);
		criteriaUpdate.set("name", input.getBody().get().getName());
		Predicate[] predicates = new Predicate[1];
		predicates[0] = criteriaBuilder.equal(root.get("employeeId"), input.getParams().get().getEmployeeId().get(0));
		SqlDbDao<Employee> employeeDao = DaoFactory.getSQLDao(Employee.class);
		count = employeeDao.executeCriteriaUpdateQuery(criteriaBuilder, criteriaUpdate, root,
				Arrays.asList(predicates), Employee.class);
		employeeStatus.setCount(count);
		employeeStatus.setStatus("Success");
		return employeeStatus;
	}

}
