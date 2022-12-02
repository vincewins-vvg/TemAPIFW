/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;

import java.util.HashSet;
import java.util.Set;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.sql.SqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.view.PaymentTransaction;
import com.temenos.microservice.payments.view.TransactionReference;

public class CreatePaymentOrderTxnImpl implements CreatePaymentOrderTxn {

	@Override
	public TransactionReference invoke(Context ctx, CreatePaymentOrderTxnInput input) throws FunctionException {
		validateInput(input);
		return executeStatus(ctx, input.getBody().get());
	}

	private TransactionReference executeStatus(Context ctx, PaymentTransaction paymentTransaction)
			throws FunctionException {
		validateParameter(paymentTransaction);
		String paymentTxnId = ("PoTxn~" + paymentTransaction.getAccountNumber().toString() + "~"
				+ paymentTransaction.getCurrency() + "~" + paymentTransaction.getAmount()).toUpperCase();
		if (paymentTxnId != null) {
			SqlDbDao<com.temenos.microservice.payments.entity.PaymentTransaction> txnDao = DaoFactory
					.getSQLDao(com.temenos.microservice.payments.entity.PaymentTransaction.class);
			com.temenos.microservice.payments.entity.PaymentTransaction paymentTxn = txnDao.findById(paymentTxnId,
					com.temenos.microservice.payments.entity.PaymentTransaction.class);
			if (paymentTxn != null && paymentTxn.getRecId() != null) {
				throw new InvalidInputException(
						new FailureMessage("Record already exists", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
			}
		}
		return paymentTxnPersist(paymentTransaction, paymentTxnId);
	}

	public TransactionReference paymentTxnPersist(PaymentTransaction txn, String txnId) throws DataAccessException {
		SqlDbDao<com.temenos.microservice.payments.entity.PaymentTransaction> txnDao = DaoFactory
				.getSQLDao(com.temenos.microservice.payments.entity.PaymentTransaction.class);
		com.temenos.microservice.payments.entity.PaymentTransaction paymentTxn = new com.temenos.microservice.payments.entity.PaymentTransaction();
		if (txn != null) {
			paymentTxn.setAccountNumber(Long.valueOf(txn.getAccountNumber()));
			paymentTxn.setRecId(txnId);
			paymentTxn.setAccountOfficer(txn.getAccountOfficer());
			paymentTxn.setCompanyCode(txn.getCompanyCode());
			paymentTxn.setCurrency(txn.getCurrency());
			Set<com.temenos.microservice.payments.entity.PaymentOrderDetails> paymentTxnDetailsEntities = new HashSet<>();
			com.temenos.microservice.payments.entity.PaymentOrderDetails details = new com.temenos.microservice.payments.entity.PaymentOrderDetails(
					txnId, txn.getAmount());
			paymentTxnDetailsEntities.add(details);
			if (!paymentTxnDetailsEntities.isEmpty()) {
				paymentTxn.setpaymentOrderDetails(paymentTxnDetailsEntities);
			}
			txnDao.save(paymentTxn);
		}
		return getStatus(txnId);
	}

	private TransactionReference getStatus(String recId) {
		TransactionReference txnRef = new TransactionReference();
		txnRef.setTxnReference(recId);
		txnRef.setStatus("Saved Successfully");
		return txnRef;
	}

	public void validateInput(CreatePaymentOrderTxnInput input) throws InvalidInputException {
		if (!input.getBody().isPresent()) {
			throw new InvalidInputException(new FailureMessage("Input body is empty", "PAYM-PORD-A-2001"));
		}
	}

	public void validateParameter(PaymentTransaction input) throws InvalidInputException {
		if (input.getAccountNumber() == null) {
			throw new InvalidInputException(new FailureMessage("Account Number cannot be empty", "PAYM-PORD-A-2001"));
		}
		if (input.getCurrency() == null) {
			throw new InvalidInputException(new FailureMessage("Input Currency cannot be empty", "PAYM-PORD-A-2002"));
		}
		if (input.getAmount() == null) {
			throw new InvalidInputException(new FailureMessage("Amount cannot be empty", "PAYM-PORD-A-2003"));
		}
	}

}
