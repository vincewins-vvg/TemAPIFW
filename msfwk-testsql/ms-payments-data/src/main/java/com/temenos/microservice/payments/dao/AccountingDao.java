/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.dao;

import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.sql.BaseSqlDao;
import com.temenos.microservice.payments.entity.Accounting;

public class AccountingDao<T>  extends BaseSqlDao<Accounting>  {

	public AccountingDao(Class clazz) throws DataAccessException {
		super(clazz);
	}
	
	public static AccountingDao getInstance(Class clazz) throws DataAccessException {
		return new AccountingDao(clazz);
	}
}
