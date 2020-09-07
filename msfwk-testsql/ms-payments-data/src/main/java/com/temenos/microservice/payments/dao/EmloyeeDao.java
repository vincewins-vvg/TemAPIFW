package com.temenos.microservice.payments.dao;

import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.sql.BaseSqlDao;
import com.temenos.microservice.payments.entity.Employee;

public class EmployeeDao<T>  extends BaseSqlDao<Employee>  {

	private EmployeeDao(Class clazz) throws DataAccessException {
		 super(clazz);
	}

	/**
	 * Get Employee Instance.
	 * 
	 * @param clazz
	 * @return
	 * @throws DataAccessException 
	 */
	public static EmployeeDao<Employee> getInstance(Class clazz) throws DataAccessException {
		
		return new EmployeeDao<Employee>(clazz);
	}

}