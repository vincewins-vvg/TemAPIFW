package com.temenos.microservice.paymentorder.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.NoSqlResponse;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.paymentorder.view.Account;
import com.temenos.microservice.paymentorder.view.AccountStatus;

public class CreateAccountImpl implements CreateAccount{

	@Override
	public AccountStatus invoke(Context ctx, CreateAccountInput input) throws FunctionException {
		// TODO Auto-generated method stub
		Account createAccount = input.getBody().get();
		com.temenos.microservice.paymentorder.entity.Account account = 
				new com.temenos.microservice.paymentorder.entity.Account();
		account.setAccountId(createAccount.getAccountId());
		account.setAccountHolderName(createAccount.getAccountName());
		account.setAccountType(createAccount.getAccountType());
		account.setBranch(createAccount.getBranch());
		
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.Account> accountDao = 
				DaoFactory.getNoSQLDao(com.temenos.microservice.paymentorder.entity.Account.class);
		NoSqlResponse accountResult = accountDao.saveOrMergeEntity(account, true);
		
        AccountStatus accountStatus = new AccountStatus();
        accountStatus.setAccountId(accountResult.getPartitionId());
        if(accountResult.getModifiedCount() != null)
        	accountStatus.setModifiedCount(accountResult.getModifiedCount().intValue());
        accountStatus.setStatus("Successful");
       
		return accountStatus;
	}

}
