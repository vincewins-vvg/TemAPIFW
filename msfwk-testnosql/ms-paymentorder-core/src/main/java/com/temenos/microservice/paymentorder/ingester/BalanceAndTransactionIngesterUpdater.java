package com.temenos.microservice.paymentorder.ingester;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONObject;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.ingester.IngesterEvent;
import com.temenos.microservice.framework.core.ingester.MultiEventBaseIngester;
import com.temenos.microservice.paymentorder.entity.Balance;
import com.temenos.microservice.paymentorder.entity.Transaction;

public class BalanceAndTransactionIngesterUpdater extends MultiEventBaseIngester{

	private List<Transaction> transactionRecords = new ArrayList<Transaction>();
	private List<Balance> balanceRecords = new ArrayList<Balance>();
	
	private void updateTransactionMap(IngesterEvent<JSONObject> ingesterEvent) {
		Set<String> eventSchemas = ingesterEvent.getSchemaNames();
		if (eventSchemas.contains("STMT_ENTRYEvent")) {
			for (JSONObject jsonObject : ingesterEvent.getRecords("STMT_ENTRYEvent")) {
				Transaction transaction = new Transaction();
				StmtEntryRecord stmtEntryRec = new StmtEntryRecord(jsonObject);
				
				transaction.setRecId(stmtEntryRec.recId());
				transaction.setCompanyCode(stmtEntryRec.companyCode());
				transaction.setAmountLcy(stmtEntryRec.amountLcy());
				transaction.setTransactionCode(stmtEntryRec.transactionCode());
				transaction.setAccountNumber(Long.parseLong(stmtEntryRec.accountNumber()));
				transaction.setOurReference(stmtEntryRec.ourReference());
				transaction.setTheirReference(stmtEntryRec.theirReference());
				transaction.setAccountOfficer(stmtEntryRec.accountOfficer());
				transaction.setTransReference(stmtEntryRec.transReference());
				transaction.setCustomerId(stmtEntryRec.customerId());
				transaction.setCurrency(stmtEntryRec.currency());
				transactionRecords.add(transaction);
			}
		}
	}

	private void updateBalanceMap(IngesterEvent<JSONObject> ingesterEvent) {
		Set<String> eventSchemas = ingesterEvent.getSchemaNames();
		if (eventSchemas.contains("EB_CONTRACT_BALANCESEvent")) {
			for (JSONObject jsonObject : ingesterEvent.getRecords("EB_CONTRACT_BALANCESEvent")) {
				Balance balance = new Balance();
				EbContractBalancesRecord ebContBalRec = new EbContractBalancesRecord(jsonObject);
				balance.setRecId(ebContBalRec.recId());
				balance.setStmtProcDate(ebContBalRec.stmtProcDate());
				balance.setCoCode(ebContBalRec.coCode());
				balance.setOnlineClearedBal(new BigDecimal(ebContBalRec.onlineClearedBal()));
				balance.setWorkingBalance(new BigDecimal(ebContBalRec.workingBalance()));
				balance.setOnlineActualBal(new BigDecimal(ebContBalRec.onlineActualBal()));
				balance.setCurrency(ebContBalRec.currency());
				balance.setCustomer(ebContBalRec.customer());
				balance.setProduct(ebContBalRec.product());
				balanceRecords.add(balance);
			}
		}		
	}

	@Override
	public void transform(IngesterEvent<JSONObject> event) throws FunctionException {
		updateBalanceMap(event);
		updateTransactionMap(event);
	}

	@Override
	public Map<String, Object> setInstanceMap() {
		Map<String, Object> instanceMap = new java.util.HashMap<String, Object>();
		instanceMap.put("com.temenos.microservice.paymentorder.entity.transaction", transactionRecords);
		instanceMap.put("com.temenos.microservice.paymentorder.entity.balance", balanceRecords);
		return instanceMap;
	}

}