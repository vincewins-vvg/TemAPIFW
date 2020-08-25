package com.temenos.microservice.paymentorder.function;

import java.util.ArrayList;
import java.util.List;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.Operator;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.security.MsLogicalOperator;
import com.temenos.microservice.paymentorder.entity.User;
import com.temenos.microservice.paymentorder.view.SearchUsersParams;
import com.temenos.microservice.paymentorder.view.Users;

public class SearchUsersImpl implements SearchUsers{

	@Override
	public Users invoke(Context ctx, SearchUsersInput input) throws FunctionException {
		SearchUsersParams params = input.getParams().get();
		List<String> nameList = params.getName();
		if(nameList == null) {
			throw new InvalidInputException(new FailureMessage("Name Parameter is mandatory", "400"));
		}  if(nameList.size() > 0 && nameList.get(0) == null) {
			throw new InvalidInputException(new FailureMessage("Name Value is mandatory", "400"));
		}
		List<String> emailList = params.getEmail();
		Criteria criteria = new Criteria();
		criteria.condition(MsLogicalOperator.AND);
		if(nameList != null ) {
		criteria.add(new CriterionImpl(com.temenos.microservice.paymentorder.entity.User.COLUMN_NAME,".*(?i)"+nameList.get(0)+".*",Operator.regex));
		}
		if (emailList != null) {
		criteria.add(new CriterionImpl(com.temenos.microservice.paymentorder.entity.User.COLUMN_EMAIL,".*(?i)"+emailList.get(0)+".*",Operator.regex));
		}
		List<Entity> entityList = DaoFactory.getNoSQLDao(User.class).search(criteria);		
		com.temenos.microservice.paymentorder.view.Users users = new com.temenos.microservice.paymentorder.view.Users();
		
		if (!entityList.isEmpty()) {
			entityList.stream().forEach(entity -> {
				User userEntity = (User) entity;
				com.temenos.microservice.paymentorder.view.User userView = new com.temenos.microservice.paymentorder.view.User();
				userView.setName(userEntity.getName());
				userView.setEmail(userEntity.getEmail());
				users.add(userView);
			});
		} else {
			throw new InvalidInputException(new FailureMessage("No User found", "400"));
		}
		return users;
	} 
//
}
