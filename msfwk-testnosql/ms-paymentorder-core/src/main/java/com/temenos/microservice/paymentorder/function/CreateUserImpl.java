package com.temenos.microservice.paymentorder.function;

import com.temenos.microservice.paymentorder.function.CreateUserInput;
import com.temenos.microservice.paymentorder.view.User;
import com.temenos.microservice.paymentorder.view.UserStatus;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;

public class CreateUserImpl implements CreateUser{
	
	@Override 
	public UserStatus invoke(Context ctx, CreateUserInput input) throws FunctionException {

		User createUser = input.getBody().get();
		com.temenos.microservice.paymentorder.entity.User user = 
				new com.temenos.microservice.paymentorder.entity.User();
		user.setName(createUser.getName());
		user.setEmail(createUser.getEmail());
		
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.User> userDao = 
				DaoFactory.getNoSQLDao(com.temenos.microservice.paymentorder.entity.User.class);
		Entity userEntity = userDao.saveEntity(user);
		com.temenos.microservice.paymentorder.entity.User savedUser = (com.temenos.microservice.paymentorder.entity.User) userEntity; 
		
        UserStatus userStatus = new UserStatus();
        userStatus.setUserId(savedUser.getUserId());
        userStatus.setStatus("Successful");
       
		return userStatus;
	}


}
