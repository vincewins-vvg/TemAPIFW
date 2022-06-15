/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function;

import com.temenos.microservice.paymentorder.exception.StorageException;
import com.temenos.microservice.paymentorder.function.CreateUserInput;
import com.temenos.microservice.paymentorder.view.User;
import com.temenos.microservice.paymentorder.view.UserStatus;

import java.util.List;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;

public class CreateUserImpl implements CreateUser {

	@Override
	public UserStatus invoke(Context ctx, CreateUserInput input) throws FunctionException {
		User createUser = null;

		if (input.getBody() == null || input.getBody().get().getName() == null
				|| input.getBody().get().getName().length() == 0
				|| !input.getBody().get().getName().matches("[A-Za-z]*") || input.getBody().get().getEmail() == null
				|| input.getBody().get().getEmail().length() == 0
				|| !input.getBody().get().getEmail().matches(".*[@].*[.].*")) {
			throw new InvalidInputException(new FailureMessage("Invalid Request Body -- Check email or name",
					MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}
		createUser = input.getBody().get();

		
		UserStatus userStatus = new UserStatus();
		try {
			com.temenos.microservice.paymentorder.entity.User user = new com.temenos.microservice.paymentorder.entity.User();

			user.setName(createUser.getName());
			user.setEmail(createUser.getEmail());

			NoSqlDbDao<com.temenos.microservice.paymentorder.entity.User> userDao = DaoFactory
					.getNoSQLDao(com.temenos.microservice.paymentorder.entity.User.class);
			Entity userEntity = userDao.saveEntity(user);
			com.temenos.microservice.paymentorder.entity.User savedUser = (com.temenos.microservice.paymentorder.entity.User) userEntity;

			userStatus.setUserId(savedUser.getUserId());
			userStatus.setStatus("Successful");
		}catch(Exception e) {
			throw new InvalidInputException(new FailureMessage("Cannot save in db",
					MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}

		return userStatus;
	}

}
