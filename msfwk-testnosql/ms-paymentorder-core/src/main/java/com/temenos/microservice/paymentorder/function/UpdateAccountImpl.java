
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

public class UpdateAccountImpl implements UpdateAccount {

	@Override
	public Account invoke(Context ctx, UpdateAccountInput input) throws FunctionException {
		Account updateAccount = null;
		if (input.getParams() == null || input.getParams().get().getAccountId() == null)
			throw new InvalidInputException(
					new FailureMessage("AccountId cannot be null", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		String accountId = input.getParams().get().getAccountId().get(0);
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
			throw new InvalidInputException(new FailureMessage("Invalid Request Body -- Check email or name",
					MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}
		if (!input.getBody().get().getAccountId().equals(accountId))
			throw new InvalidInputException(new FailureMessage("AccountId does not match with path param",
					MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));

		updateAccount = input.getBody().get();
		AccountStatus accountStatus = new AccountStatus();
		Account accountView = new Account();
		try {
			com.temenos.microservice.paymentorder.entity.Account account = new com.temenos.microservice.paymentorder.entity.Account();
			account.setAccountId(updateAccount.getAccountId());
			account.setAccountHolderName(updateAccount.getAccountName());
			account.setAccountType(updateAccount.getAccountType());
			account.setBranch(updateAccount.getBranch());

			NoSqlDbDao<com.temenos.microservice.paymentorder.entity.Account> accountDao = DaoFactory
					.getNoSQLDao(com.temenos.microservice.paymentorder.entity.Account.class);
			NoSqlResponse accountResult = accountDao.saveOrMergeEntity(account, false);

			accountView.setAccountId(account.getAccountId());
			accountView.setAccountName(account.getAccountHolderName());
			accountView.setAccountType(account.getAccountType());
			accountView.setBranch(account.getBranch());
		} catch (Exception e) {
			throw new DatabaseOperationException("Could not be saved in Database");
		}
		return accountView;
	}
}