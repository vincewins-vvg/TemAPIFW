package com.temenos.microservice.paymentorder.function;

import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.NoSqlResponse;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.paymentorder.view.Account;
import com.temenos.microservice.paymentorder.view.AccountStatus;

public class UpdateAccountImpl implements UpdateAccount{

	@Override
	public AccountStatus invoke(Context ctx, UpdateAccountInput input) throws FunctionException {
		Account updateAccount = input.getBody().get();

		String accountId = input.getParams().get().getAccountId().get(0);
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.Account> accountDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.Account.class);

		Optional<com.temenos.microservice.paymentorder.entity.Account> accountOpt = accountDao
				.getByPartitionKey(accountId);

		if (accountOpt.isPresent()) {
			com.temenos.microservice.paymentorder.entity.Account account = accountOpt.get();
			account.setAccountId(updateAccount.getAccountId());
			account.setAccountHolderName(updateAccount.getAccountName());
			account.setAccountType(updateAccount.getAccountType());
			account.setBranch(updateAccount.getBranch());
			
			NoSqlResponse accountResponse = accountDao.saveOrMergeEntity(account, false);

			AccountStatus accountStatus = new AccountStatus();
			accountStatus.setAccountId(accountResponse.getPartitionId());
			accountStatus.setStatus("Successful");
			return accountStatus;

		}else {
			AccountStatus accountStatus = new AccountStatus();
			accountStatus.setAccountId(accountId);
			accountStatus.setStatus("Unsucessful - account ID is not present in DB");
			return accountStatus;
		}
	}

}
