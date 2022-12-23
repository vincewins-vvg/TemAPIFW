/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.core;

import java.text.ParseException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Component;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.DatabaseOperationException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.framework.core.util.DataTypeConverter;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.dao.AccountingDao;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.Accounting;
import com.temenos.microservice.payments.entity.Card;
import com.temenos.microservice.payments.entity.ExchangeRate;
import com.temenos.microservice.payments.entity.PayeeDetails;
import com.temenos.microservice.payments.event.PaymentOrderCreated;
import com.temenos.microservice.payments.function.CreateNewPaymentOrdersInput;
import com.temenos.microservice.payments.function.PaymentOrderFunctionHelper;
import com.temenos.microservice.payments.view.AllPaymentStatus;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentOrders;
import com.temenos.microservice.payments.view.PaymentStatus;

@Component
public class CreateNewPaymentOrdersProcessor {
//
	public static final String DATE_FORMAT = "yyyy-MM-dd";

	public AllPaymentStatus invoke(Context ctx, CreateNewPaymentOrdersInput input) throws FunctionException {
		AllPaymentStatus allPaymentStatus = new AllPaymentStatus();
		// PaymentOrderItems

		if (input.getBody().get().getPaymentOrders() != null) {
			PaymentOrders paymentOrders = input.getBody().get().getPaymentOrders();
			if (Objects.nonNull(paymentOrders) && !paymentOrders.isEmpty()) {
				for (int i = 0; i < paymentOrders.size(); i++) {
					PaymentOrderFunctionHelper.validatePaymentOrder(paymentOrders.get(0), ctx);
				}
				PaymentOrder[] paymentOrderArray = new PaymentOrder[paymentOrders.size()];
				for (int i = 0; i < paymentOrders.size(); i++) {
					paymentOrderArray[i] = paymentOrders.get(i);
				}
				allPaymentStatus = executePaymentOrders(ctx, paymentOrderArray);
			} else {
				throw new InvalidInputException(
						new FailureMessage("Input items are empty or invalid", "PAYM-PORD-A-2002"));
			}
		} else {
			throw new InvalidInputException(new FailureMessage("Input body is invalid", "PAYM-PORD-A-2002"));
		}
		return allPaymentStatus;
	}

	private AllPaymentStatus executePaymentOrders(Context ctx, PaymentOrder[] paymentOrderArray)
			throws FunctionException {
		String[] paymentOrderId = new String[paymentOrderArray.length];
		com.temenos.microservice.payments.entity.PaymentOrder[] entity = new com.temenos.microservice.payments.entity.PaymentOrder[paymentOrderArray.length];
		for (int i = 0; i < paymentOrderArray.length; i++) {
			paymentOrderId[i] = ("PO~" + paymentOrderArray[i].getFromAccount() + "~"
					+ paymentOrderArray[i].getToAccount() + "~" + paymentOrderArray[i].getCurrency() + "~"
					+ paymentOrderArray[i].getAmount()).toUpperCase();
			if (paymentOrderId != null) {
				com.temenos.microservice.payments.entity.PaymentOrder paymentsOrder = (com.temenos.microservice.payments.entity.PaymentOrder) PaymentOrderDao
						.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
						.findById(paymentOrderId[i], com.temenos.microservice.payments.entity.PaymentOrder.class);
				if (paymentsOrder != null && paymentsOrder.getPaymentOrderId() != null) {
					throw new InvalidInputException(new FailureMessage("One or More Of the Records already exists",
							MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
				}
			}
		}
		entity = createEntity(ctx, paymentOrderId, paymentOrderArray);
		return readStatus(entity);
	}

	private com.temenos.microservice.payments.entity.PaymentOrder[] createEntity(Context ctx, String[] paymentOrderId,
			PaymentOrder[] view) throws FunctionException {
		List<com.temenos.microservice.payments.entity.PaymentOrder> entityarrayList = new ArrayList<com.temenos.microservice.payments.entity.PaymentOrder>();
		com.temenos.microservice.payments.entity.PaymentOrder[] entityarray = new com.temenos.microservice.payments.entity.PaymentOrder[view.length];
		for (int i = 0; i < view.length; i++) {
			com.temenos.microservice.payments.entity.PaymentOrder entity = new com.temenos.microservice.payments.entity.PaymentOrder();
			com.temenos.microservice.payments.entity.PaymentMethod method = new com.temenos.microservice.payments.entity.PaymentMethod();

			entity.setPaymentOrderId(paymentOrderId[i]);
			entity.setAmount(view[i].getAmount());
			entity.setCreditAccount(view[i].getToAccount());
			entity.setDebitAccount(view[i].getFromAccount());
			try {
				if (view[i].getPaymentDate() != null) {
					entity.setPaymentDate(DataTypeConverter.toDate(view[i].getPaymentDate(), DATE_FORMAT));
				} else {
					entity.setPaymentDate(Date.from(Instant.now()));
				}
			} catch (ParseException e) {
				throw new InvalidInputException(
						new FailureMessage("Error while parsing date. Check the inputted date format",
								MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
			}
			entity.setCurrency(view[i].getCurrency().toString());
			entity.setPaymentReference(view[i].getPaymentReference());
			entity.setPaymentDetails(view[i].getPaymentDetails());
			entity.setExtensionData((Map<String, String>) view[i].getExtensionData());
			entity.setStatus("INITIATED");
			entity.setPaymentMethod(method);

			if (view[i].getFileContent() != null) {
				try {
					entity.setFileContent(new String(view[i].getFileContent().array(), "UTF-8"));
				} catch (Exception e) {
					throw new RuntimeException(e.getMessage());
				}
			}

			if (view[i].getPaymentMethod() != null) {
				entity.getPaymentMethod().setId(view[i].getPaymentMethod().getId());
				entity.getPaymentMethod().setName(view[i].getPaymentMethod().getName());
				entity.getPaymentMethod()
						.setExtensionData((Map<String, String>) view[i].getPaymentMethod().getExtensionData());
				if (view[i].getPaymentMethod().getCard() != null) {
					Card card = new Card();
					card.setCardid(view[i].getPaymentMethod().getCard().getCardid());
					card.setCardname(view[i].getPaymentMethod().getCard().getCardname());
					card.setCardlimit(view[i].getPaymentMethod().getCard().getCardlimit());
					entity.getPaymentMethod().setCard(card);
				}
			}

			if (view[i].getPayeeDetails() != null) {
				PayeeDetails payeeDetails = new PayeeDetails();
				payeeDetails.setPayeeName(view[i].getPayeeDetails().getPayeeName());
				payeeDetails.setPayeeType(view[i].getPayeeDetails().getPayeeType());
				entity.setPayeeDetails(payeeDetails);
			}

			if (view[i].getExchangeRates() != null) {
				List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
				for (com.temenos.microservice.payments.view.ExchangeRate exchangeRt : view[i].getExchangeRates()) {
					ExchangeRate exchangeRate = new ExchangeRate();
					exchangeRate.setName(exchangeRt.getName());
					exchangeRate.setValue(exchangeRt.getValue());
					exchangeRates.add(exchangeRate);
				}
				entity.setExchangeRates(exchangeRates);
			}
			entityarrayList.add(entity);
			entityarray[i] = entity;
		}
		PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.saveOrMergeEntityList(entityarrayList, false);
		for (int j = 0; j < entityarrayList.size(); j++) {
			PaymentOrderCreated paymentOrderEvent = new PaymentOrderCreated();
			paymentOrderEvent.setPaymentOrderId(entityarrayList.get(j).getPaymentOrderId());
			paymentOrderEvent.setAmount(entityarrayList.get(j).getAmount());
			paymentOrderEvent.setCreditAccount(entityarrayList.get(j).getCreditAccount());
			paymentOrderEvent.setCurrency(entityarrayList.get(j).getCurrency());
			paymentOrderEvent.setDebitAccount(entityarrayList.get(j).getDebitAccount());
			//Entry in ms_payment_accounting table
			List<com.temenos.microservice.payments.entity.Accounting> accountingEntities = createAccounting(entityarrayList.get(j));
			EventManager.raiseBusinessEvent(ctx, new GenericEvent("PaymentOrderCreated", paymentOrderEvent), entityarrayList.get(j), accountingEntities.get(0), accountingEntities.get(1));
		}

		return entityarray;
	}

	private List<Accounting> createAccounting(com.temenos.microservice.payments.entity.PaymentOrder paymentOrder) throws DatabaseOperationException, DataAccessException {

		
		List<com.temenos.microservice.payments.entity.Accounting> entityArrayList = new ArrayList<com.temenos.microservice.payments.entity.Accounting>();
		com.temenos.microservice.payments.entity.Accounting debitAcct = new com.temenos.microservice.payments.entity.Accounting();
		com.temenos.microservice.payments.entity.Accounting creditAcct = new com.temenos.microservice.payments.entity.Accounting();
		
		//Entry for debit account
		debitAcct.setPaymentOrderId(paymentOrder.getPaymentOrderId());
		debitAcct.setAccountNumber(paymentOrder.getDebitAccount());
		debitAcct.setAmount(paymentOrder.getAmount());
		debitAcct.setCurrency(paymentOrder.getCurrency().toString());
		debitAcct.setPaymentType("DEBIT");
		debitAcct.setProcessedDate(Date.from(Instant.now()));
		
		//Entry for credit account
		creditAcct.setPaymentOrderId(paymentOrder.getPaymentOrderId());
		creditAcct.setAccountNumber(paymentOrder.getCreditAccount());
		creditAcct.setAmount(paymentOrder.getAmount());
		creditAcct.setCurrency(paymentOrder.getCurrency().toString());
		creditAcct.setProcessedDate(Date.from(Instant.now()));
		creditAcct.setPaymentType("CREDIT");
		
		entityArrayList.add(debitAcct);
		entityArrayList.add(creditAcct);
		
		AccountingDao.getInstance(com.temenos.microservice.payments.entity.Accounting.class).getSqlDao()
		.saveOrMergeEntityList(entityArrayList, true);
		
		return entityArrayList;
		
	
	}

	private AllPaymentStatus readStatus(com.temenos.microservice.payments.entity.PaymentOrder[] paymentOrder) {
		AllPaymentStatus allPaymentStatus = new AllPaymentStatus();
		for (int i = 0; i < paymentOrder.length; i++) {
			PaymentStatus paymentStatus = new PaymentStatus();
			paymentStatus.setPaymentId(paymentOrder[i].getPaymentOrderId());
			paymentStatus.setStatus(paymentOrder[i].getStatus());
			paymentStatus.setDetails(paymentOrder[i].getPaymentDetails());
			allPaymentStatus.add(paymentStatus);
		}
		return allPaymentStatus;
	}
}