package com.temenos.microservice.payments.dao;

import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.sql.BaseSqlDao;
import com.temenos.microservice.payments.entity.FileUpload;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class FileUploadDao<T> extends BaseSqlDao<FileUpload> {

	public FileUploadDao(Class clazz) throws DataAccessException {
		super(clazz);
	}

	public static FileUploadDao<FileUpload> getInstance(Class clazz) throws DataAccessException {

		return new FileUploadDao<FileUpload>(clazz);
	}

}
