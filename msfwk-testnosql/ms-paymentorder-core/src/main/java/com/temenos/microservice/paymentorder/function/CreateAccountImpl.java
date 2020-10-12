package com.temenos.microservice.paymentorder.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.DatabaseOperationException;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.NoSqlResponse;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.view.Account;
import com.temenos.microservice.paymentorder.view.AccountStatus;

public class CreateAccountImpl implements CreateAccount {

	@Override
	public AccountStatus invoke(Context ctx, CreateAccountInput input) throws FunctionException {
		Account createAccount = input.getBody().get();
		if (input.getBody() == null || input.getBody().get().getAccountId() == null
				|| input.getBody().get().getAccountId().length() == 0
				|| !input.getBody().get().getAccountId().matches("[A-Za-z0-9]*")
				|| input.getBody().get().getAccountName() == null
				|| input.getBody().get().getAccountName().length() == 0
				|| !input.getBody().get().getAccountName().matches("[A-Za-z]*")
				|| input.getBody().get().getAccountType() == null
				|| input.getBody().get().getAccountType().length() == 0
				|| !input.getBody().get().getAccountType().matches("[A-Za-z]*")
				|| input.getBody().get().getBranch() == null || input.getBody().get().getBranch().length() == 0
				|| !input.getBody().get().getBranch().matches("[A-Za-z]*")) {
			throw new InvalidInputException(
					new FailureMessage("Invalid Request Body", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}

		AccountStatus accountStatus = new AccountStatus();
		try {
			com.temenos.microservice.paymentorder.entity.Account account = new com.temenos.microservice.paymentorder.entity.Account();
			account.setAccountId(createAccount.getAccountId());
			account.setAccountHolderName(createAccount.getAccountName());
			account.setAccountType(createAccount.getAccountType());
			account.setBranch(createAccount.getBranch());

			NoSqlDbDao<com.temenos.microservice.paymentorder.entity.Account> accountDao = DaoFactory
					.getNoSQLDao(com.temenos.microservice.paymentorder.entity.Account.class);
			NoSqlResponse accountResult = accountDao.saveOrMergeEntity(account, true);

			accountStatus.setAccountId(accountResult.getPartitionId());
			if (accountResult.getModifiedCount() >= 0l)
				accountStatus.setModifiedCount((int) accountResult.getModifiedCount());
			accountStatus.setStatus("Successful");
		} catch (Exception e) {
			throw new DatabaseOperationException("Could not be saved in Database");
		}
		return accountStatus;
	}
}
