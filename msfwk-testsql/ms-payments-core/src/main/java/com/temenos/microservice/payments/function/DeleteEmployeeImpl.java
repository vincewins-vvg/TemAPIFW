package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.dao.EmployeeDao;
import com.temenos.microservice.payments.entity.Employee;
import com.temenos.microservice.payments.view.DeleteEmployeeParams;
import com.temenos.microservice.payments.view.EmployeeStatus;

public class DeleteEmployeeImpl implements DeleteEmployee {

	@Override
	public EmployeeStatus invoke(Context ctx, DeleteEmployeeInput input) throws FunctionException {
		if (!input.getParams().isPresent() || input.getParams().get().getEmployeeId()==null || input.getParams().get().getEmployeeId().isEmpty() || input.getParams().get().getOrgCode()==null || input.getParams().get().getOrgCode().isEmpty()) {
			throw new InvalidInputException(new FailureMessage("Invalid input", Integer.toString(MSFrameworkErrorConstant.INVALID_INPUT)));
		}
		DeleteEmployeeParams deleteParams = input.getParams().get();
		EmployeeStatus status = new EmployeeStatus();
		Employee employee = new Employee();
		int count = 0;
		employee.setEmployeeId(deleteParams.getEmployeeId().get(0));
		employee.setOrgCode(deleteParams.getOrgCode().get(0));
		count = EmployeeDao.getInstance(Employee.class).getSqlDao().deleteById(employee);
		status.setStatus("Success");
		status.setCount(count);
		return status;
	}

}
