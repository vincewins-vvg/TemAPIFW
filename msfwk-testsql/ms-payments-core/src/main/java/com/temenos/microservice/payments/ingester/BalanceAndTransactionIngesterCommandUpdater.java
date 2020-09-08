package com.temenos.microservice.payments.ingester;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONObject;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.ingester.IngesterEvent;
import com.temenos.microservice.framework.core.ingester.MultiEventBaseIngester;
import com.temenos.microservice.framework.core.util.DataTypeConverter;
import com.temenos.microservice.payments.view.Balance;
import com.temenos.microservice.payments.view.MultiEventDataModels;
import com.temenos.microservice.payments.view.Transaction;
import com.temenos.microservice.payments.function.CreateBalanceAndTransactionInput;

public class BalanceAndTransactionIngesterCommandUpdater extends MultiEventBaseIngester{

	public BalanceAndTransactionIngesterCommandUpdater() {
		
	}

	private MultiEventDataModels multiEventDataModels = new MultiEventDataModels(); 
	
	private void updateTransactionMap(IngesterEvent<JSONObject> ingesterEvent) {
		List<Transaction> transactionRecords = new ArrayList<Transaction>();
		Set<String> eventSchemas = ingesterEvent.getSchemaNames();
		if (eventSchemas.contains("STMT_ENTRYEvent")) {
			for (JSONObject jsonObject : ingesterEvent.getRecords("STMT_ENTRYEvent")) {
				Transaction transaction = new Transaction();
				StmtEntryRecord stmtEntryRec = new StmtEntryRecord(jsonObject);
				
				transaction.setRecId(stmtEntryRec.recId());
				transaction.setCompanyCode(stmtEntryRec.companyCode());
				transaction.setAmountLcy(stmtEntryRec.amountLcy());
				transaction.setProcessingDate(convertDateAsString(stmtEntryRec.processingDate()));
				transaction.setTransactionCode(stmtEntryRec.transactionCode());
				transaction.setValueDate(convertDateAsString(stmtEntryRec.valueDate()));
				transaction.setAccountNumber(stmtEntryRec.accountNumber());
				transaction.setOurReference(stmtEntryRec.ourReference());
				transaction.setTheirReference(stmtEntryRec.theirReference());
				transaction.setAccountOfficer(stmtEntryRec.accountOfficer());
				transaction.setTransReference(stmtEntryRec.transReference());
				transaction.setBookingDate(stmtEntryRec.bookingDate());
				transaction.setCustomerId(stmtEntryRec.customerId());
				transaction.setCurrency(stmtEntryRec.currency());
				transactionRecords.add(transaction);
			}
		}
		multiEventDataModels.setTransactions(transactionRecords);
	}

	private void updateBalanceMap(IngesterEvent<JSONObject> ingesterEvent) {
		List<Balance> balanceRecords = new ArrayList<Balance>();
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
				balance.setProcessingTime(ebContBalRec.getProcessingTime());
				balanceRecords.add(balance);
			}
		}
		multiEventDataModels.setBalances(balanceRecords);
		
	}

	private Date convertDate(String dateText) {
		try {
			return DataTypeConverter.toDate(dateText);
		} catch (ParseException | NullPointerException e) {
			return null;
		}
	}
	private String convertDateAsString(String dateText) {
		Date date = convertDate(dateText);
		if(date!=null)
			return date.toString();
		return "";
	}

	@Override
	public void transform(IngesterEvent<JSONObject> event) throws FunctionException {
		updateBalanceMap(event);
		updateTransactionMap(event);
	}

	@Override
	public Map<String, Object> setInstanceMap() {
		Map<String, Object> instanceMap = new java.util.HashMap<String, Object>();
		CreateBalanceAndTransactionInput createBalanceAndTransactionInput = new CreateBalanceAndTransactionInput(multiEventDataModels);
		
		instanceMap.put("CreateBalanceAndTransaction", createBalanceAndTransactionInput);
		return instanceMap;
	}

}