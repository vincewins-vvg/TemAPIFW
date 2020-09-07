package com.temenos.microservice.paymentorder.function;

import static com.temenos.microservice.framework.core.ingester.IngesterLogger.ingesterDiagnostic;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.DataTypeConverter;
import com.temenos.microservice.paymentorder.entity.Balance;
import com.temenos.microservice.paymentorder.entity.Transaction;
import com.temenos.microservice.paymentorder.view.MultiEventDataModels;
import com.temenos.microservice.paymentorder.view.PaymentStatus;

public class CreateBalanceAndTransactionImpl implements CreateBalanceAndTransaction {

	@Override
	public PaymentStatus invoke(Context ctx, CreateBalanceAndTransactionInput input) throws FunctionException {
		MultiEventDataModels multiEventDataModels;
		if (input == null || !input.getBody().isPresent()) {
			throw new InvalidInputException(new FailureMessage("Error occurs in Request Body"));
		}

		multiEventDataModels = input.getBody().get();
		if (Objects.nonNull(multiEventDataModels.getBalances())) {
			List<com.temenos.microservice.paymentorder.view.Balance> balanceModelList = multiEventDataModels
					.getBalances();
			if (Objects.nonNull(balanceModelList) && !balanceModelList.isEmpty()) {
				saveBalance(balanceModelList);
			}
		}
		if (Objects.nonNull(multiEventDataModels.getTransactions())) {
			List<com.temenos.microservice.paymentorder.view.Transaction> transactionModelList = multiEventDataModels
					.getTransactions();
			if (Objects.nonNull(transactionModelList) && !transactionModelList.isEmpty()) {
				saveTransaction(transactionModelList);
			}
		}
		PaymentStatus paymentStatus = new PaymentStatus();
		paymentStatus.setStatus("Success");
		paymentStatus.setDetails("Transaction and Balance event Created successfully");
		return paymentStatus;

	}

	private void saveTransaction(List<com.temenos.microservice.paymentorder.view.Transaction> transactionModelList)
			throws FunctionException {
		List<Transaction> transactionRecords = new ArrayList<>();
		for (com.temenos.microservice.paymentorder.view.Transaction stmtEntryRec : transactionModelList) {
			Transaction transaction = new Transaction();

			transaction.setRecId(stmtEntryRec.getRecId());
			transaction.setCompanyCode(stmtEntryRec.getCompanyCode());
			transaction.setAmountLcy(stmtEntryRec.getAmountLcy());
			transaction.setProcessingDate(convertDate(stmtEntryRec.getProcessingDate()));
			transaction.setTransactionCode(stmtEntryRec.getTransactionCode());
			transaction.setValueDate(convertDate(stmtEntryRec.getValueDate()));
			transaction.setAccountNumber(Long.parseLong(stmtEntryRec.getAccountNumber()));
			transaction.setOurReference(stmtEntryRec.getOurReference());
			transaction.setTheirReference(stmtEntryRec.getTheirReference());
			transaction.setAccountOfficer(stmtEntryRec.getAccountOfficer());
			transaction.setTransReference(stmtEntryRec.getTransReference());
			transaction.setBookingDate(convertDate(stmtEntryRec.getBookingDate()));
			transaction.setCustomerId(stmtEntryRec.getCustomerId());
			transaction.setCurrency(stmtEntryRec.getCurrency());
			transaction.setExtensionData((java.util.Map<String, String>)stmtEntryRec.getExtensionData());

			transactionRecords.add(transaction);
		}
		if (!transactionRecords.isEmpty()) {
			NoSqlDbDao<Transaction> dbDao = DaoFactory.getNoSQLDao(Transaction.class);
			for (Transaction trans : transactionRecords) {
				dbDao.saveEntity(trans);
			}
		}
	}

	private Date convertDate(String dateText) {
		try {
			return DataTypeConverter.toDate(dateText);
		} catch (ParseException e) {
			return null;
		}
	}

	private void saveBalance(List<com.temenos.microservice.paymentorder.view.Balance> balanceModelList)
			throws FunctionException {
		List<Balance> balanceRecords = new ArrayList<>();
		for (com.temenos.microservice.paymentorder.view.Balance ebContBalRec : balanceModelList) {
			Balance balance = new Balance();
			balance.setRecId(ebContBalRec.getRecId());
			balance.setStmtProcDate(ebContBalRec.getStmtProcDate());
			balance.setCoCode(ebContBalRec.getCoCode());
			balance.setOnlineClearedBal(ebContBalRec.getOnlineClearedBal());
			balance.setWorkingBalance(ebContBalRec.getWorkingBalance());
			balance.setOnlineActualBal(ebContBalRec.getOnlineActualBal());
			balance.setCurrency(ebContBalRec.getCurrency());
			balance.setCustomer(ebContBalRec.getCustomer());
			balance.setProduct(ebContBalRec.getProduct());
			balance.setProcessingTime(convertDate(ebContBalRec.getProcessingTime()));
			balance.setExtensionData((java.util.Map<String, String>)ebContBalRec.getExtensionData());
			balanceRecords.add(balance);
		}

		if (!(balanceRecords.isEmpty())) {
			NoSqlDbDao<Balance> dbDao = DaoFactory.getNoSQLDao(Balance.class);

			for (Balance bal : balanceRecords) {
				if (bal.getRecId() != null)
					dbDao.saveEntity(bal);
				else {
					ingesterDiagnostic.info("Account ID/ Balance Date NULL , unable to save");
				}
			}
		}
	}

}