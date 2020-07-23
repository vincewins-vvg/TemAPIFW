package com.temenos.microservice.payments.dao;

import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.sql.BaseSqlDao;
import com.temenos.microservice.payments.entity.FileDetails;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class FileUploadDao<T> extends BaseSqlDao<FileDetails> {

	public FileUploadDao(Class clazz) throws DataAccessException {
		super(clazz);
	}

	public static FileUploadDao<FileDetails> getInstance(Class clazz) throws DataAccessException {

		return new FileUploadDao<FileDetails>(clazz);
	}

}
