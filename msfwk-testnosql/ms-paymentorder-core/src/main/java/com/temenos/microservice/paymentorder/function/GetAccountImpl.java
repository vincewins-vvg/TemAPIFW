package com.temenos.microservice.paymentorder.function;

import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.paymentorder.view.Account;
import com.temenos.microservice.paymentorder.view.GetAccountParams;

public class GetAccountImpl implements GetAccount {

	@Override
	public Account invoke(Context ctx, GetAccountInput input) throws FunctionException {
		// TODO Auto-generated method stub

		if (!input.getParams().isPresent()) {
			throw new InvalidInputException(new FailureMessage("Input param is empty", "EmptyInput-2001"));
		}

		GetAccountParams userParams = input.getParams().get();
		String accountId = "";
		if (userParams != null)
			accountId = userParams.getAccountId().get(0);

		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.Account> accountDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.Account.class);

		Optional<com.temenos.microservice.paymentorder.entity.Account> accountOpt = accountDao
				.getByPartitionKey(accountId);

		if (accountOpt.isPresent()) {
			com.temenos.microservice.paymentorder.entity.Account account = accountOpt.get();
			Account accountView = new Account();
			accountView.setAccountId(account.getAccountId());
			accountView.setAccountName(account.getAccountHolderName());
			accountView.setAccountType(account.getAccountType());
			accountView.setBranch(account.getBranch());

			return accountView;

		} else {
			return new Account();
		}
	}

}
