package com.temenos.microservice.paymentorder.function;

import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.paymentorder.view.AccountStatus;
import com.temenos.microservice.paymentorder.view.DeleteAccountParams;

public class DeleteAccountImpl implements DeleteAccount{

	@Override
	public AccountStatus invoke(Context ctx, DeleteAccountInput input) throws FunctionException {
		// TODO Auto-generated method stub
		Optional<DeleteAccountParams> deleteAccountParams = input.getParams();

		String accountId = deleteAccountParams.get().getAccountId().get(0);
		
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.Account> accountDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.Account.class);

		Optional<com.temenos.microservice.paymentorder.entity.Account> accountOpt = accountDao
				.getByPartitionKey(accountId);
		
		if (accountOpt.isPresent()) {
			
			com.temenos.microservice.paymentorder.entity.Account account = accountOpt.get();
			Long deletedCount = accountDao.deleteEntity(account);
			
			AccountStatus accountStatus = new AccountStatus();
			accountStatus.setAccountId(accountId);
			accountStatus.setModifiedCount(deletedCount.intValue());
			accountStatus.setStatus("Successful");
			return accountStatus;

		}else {
			AccountStatus accountStatus = new AccountStatus();
			accountStatus.setAccountId(accountId);
			accountStatus.setModifiedCount(0);
			accountStatus.setStatus("Unsucessful - Customer ID is not present in DB");
			return accountStatus;
		}
	}
	
	

}
