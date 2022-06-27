/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function;

import java.util.Optional;

import com.temenos.microservice.paymentorder.view.User;
import com.temenos.microservice.paymentorder.view.UserStatus;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.exception.NoDataFoundException;
import com.temenos.microservice.paymentorder.view.GetUserParams;
import com.temenos.microservice.paymentorder.view.PaymentOrderStatus;
import com.temenos.microservice.paymentorder.view.User;

public class GetUserImpl implements GetUser {

	@Override
	public User invoke(Context ctx, GetUserInput input) throws FunctionException {
		if (!input.getParams().isPresent()) {
			throw new InvalidInputException(new FailureMessage("Input param is empty", "EmptyInput-2001"));
		}

		GetUserParams userParams = input.getParams().get();
		String userId = "";
		if (userParams != null)
			userId = userParams.getUserId().get(0);

		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.User> userDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.User.class);

		Optional<com.temenos.microservice.paymentorder.entity.User> userOpt = userDao.getByPartitionKey(userId);

		if (userOpt.isPresent()) {
			com.temenos.microservice.paymentorder.entity.User user = userOpt.get();
			User userView = new User();
			userView.setUserId(user.getUserId());
			userView.setName(user.getName());
			userView.setEmail(user.getEmail());

			return userView;

		} else {
			throw new NoDataFoundException(new FailureMessage("ID is not present in DB"));
		}

	}

}
