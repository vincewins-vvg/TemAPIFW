package com.temenos.microservice.paymentorder.function;

import java.util.List;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.NoSqlResponse;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.exception.StorageException;
import com.temenos.microservice.paymentorder.view.Account;
import com.temenos.microservice.paymentorder.view.AccountStatus;

public class CreateAccountImpl implements CreateAccount {

	@Override
	public AccountStatus invoke(Context ctx, CreateAccountInput input) throws FunctionException {
		// TODO Auto-generated method stub
		Account createAccount = input.getBody().get();

		if (input.getBody() == null || input.getBody().get().getAccountId() == null
				|| input.getBody().get().getAccountId().length() == 0 || input.getBody().get().getAccountName() == null
				|| input.getBody().get().getAccountName().length() == 0
				|| input.getBody().get().getAccountType() == null
				|| input.getBody().get().getAccountType().length() == 0 || input.getBody().get().getBranch() == null
				|| input.getBody().get().getBranch().length() == 0) {
			throw new InvalidInputException(
					new FailureMessage("Invalid Request Body", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}

		List<String> errorList = createAccount.doValidate();
		if (errorList.size() > 0)
			throw new InvalidInputException(new FailureMessage(errorList.toString()));

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
			if (accountResult.getModifiedCount() != null)
				accountStatus.setModifiedCount(accountResult.getModifiedCount().intValue());
			accountStatus.setStatus("Successful");
		} catch (Exception e) {
			throw new InvalidInputException("Cannot be saved in DB");
		}

		return accountStatus;
	}

}
