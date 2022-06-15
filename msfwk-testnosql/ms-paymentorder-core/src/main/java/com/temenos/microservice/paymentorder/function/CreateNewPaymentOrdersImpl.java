/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function;

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
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.Criterion;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.util.DataTypeConverter;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.entity.Card;
import com.temenos.microservice.paymentorder.entity.ExchangeRate;
import com.temenos.microservice.paymentorder.entity.PayeeDetails;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.Operator;
import com.temenos.microservice.paymentorder.function.CreateNewPaymentOrdersInput;
import com.temenos.microservice.paymentorder.function.PaymentOrderFunctionHelper;
import com.temenos.microservice.paymentorder.view.AllPaymentStatus;
import com.temenos.microservice.paymentorder.view.PaymentOrder;
import com.temenos.microservice.paymentorder.view.PaymentOrders;
import com.temenos.microservice.paymentorder.view.PaymentStatus;
import com.temenos.microservice.paymentorder.event.CreatePaymentEvent;

@Component
public class CreateNewPaymentOrdersImpl implements CreateNewPaymentOrders {

	public static final String DATE_FORMAT = "yyyy-MM-dd";

	public AllPaymentStatus invoke(Context ctx, CreateNewPaymentOrdersInput input) throws FunctionException {
		AllPaymentStatus allPaymentStatus = new AllPaymentStatus();
		// PaymentOrderItems

		if (input.getBody().get().getPaymentOrders() != null) {
			PaymentOrders paymentOrders = input.getBody().get().getPaymentOrders();
			if (Objects.nonNull(paymentOrders) && !paymentOrders.isEmpty()) {
				for (int i = 0; i < paymentOrders.size(); i++) {
					PaymentOrderFunctionHelper.validatePaymentOrder(paymentOrders.get(0));
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
		com.temenos.microservice.paymentorder.entity.PaymentOrder[] entity = new com.temenos.microservice.paymentorder.entity.PaymentOrder[paymentOrderArray.length];
		for (int i = 0; i < paymentOrderArray.length; i++) {
			paymentOrderId[i] = ("PO~" + paymentOrderArray[i].getFromAccount() + "~"
					+ paymentOrderArray[i].getToAccount() + "~" + paymentOrderArray[i].getCurrency() + "~"
					+ paymentOrderArray[i].getAmount()).toUpperCase();
			if (paymentOrderId != null) {
				NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
						.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
				
				List<com.temenos.microservice.paymentorder.entity.PaymentOrder> entities = null;
				Criteria criteria = new Criteria();
				Criterion<Object> criterion = new CriterionImpl("paymentOrderId", paymentOrderId[i],
						Operator.equal);
				criteria.add(criterion);
				entities =paymentOrderDao.getByIndexes(criteria);
				if(entities!=null&&entities.size()>0) {
					com.temenos.microservice.paymentorder.entity.PaymentOrder paymentsOrder = entities.get(0);
					
					if (paymentsOrder != null && paymentsOrder.getPaymentOrderId() != null) {
						throw new InvalidInputException(new FailureMessage("One or More Of the Records already exists",
								MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
					}
				}
			}	
		}
		entity = createEntity(ctx, paymentOrderId, paymentOrderArray);
		return readStatus(entity);
	}

	private com.temenos.microservice.paymentorder.entity.PaymentOrder[] createEntity(Context ctx, String[] paymentOrderId,
			PaymentOrder[] view) throws FunctionException {
		List<com.temenos.microservice.paymentorder.entity.PaymentOrder> entityarrayList = new ArrayList<com.temenos.microservice.paymentorder.entity.PaymentOrder>();
		com.temenos.microservice.paymentorder.entity.PaymentOrder[] entityarray = new com.temenos.microservice.paymentorder.entity.PaymentOrder[view.length];
		for (int i = 0; i < view.length; i++) {
			com.temenos.microservice.paymentorder.entity.PaymentOrder entity = new com.temenos.microservice.paymentorder.entity.PaymentOrder();
			com.temenos.microservice.paymentorder.entity.PaymentMethod method = new com.temenos.microservice.paymentorder.entity.PaymentMethod();

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
					entity.setFileContent(view[i].getFileContent());
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
				for (com.temenos.microservice.paymentorder.view.ExchangeRate exchangeRt : view[i].getExchangeRates()) {
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
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		
		
		paymentOrderDao.saveOrMergeEntityList(entityarrayList, false);
		
		
		for (int j = 0; j < entityarrayList.size(); j++) {
			CreatePaymentEvent paymentOrderEvent = new CreatePaymentEvent();
			paymentOrderEvent.setPaymentOrderId(entityarrayList.get(j).getPaymentOrderId());
			paymentOrderEvent.setAmount(entityarrayList.get(j).getAmount());
			paymentOrderEvent.setCreditAccount(entityarrayList.get(j).getCreditAccount());
			paymentOrderEvent.setCurrency(entityarrayList.get(j).getCurrency());
			paymentOrderEvent.setDebitAccount(entityarrayList.get(j).getDebitAccount());
			EventManager.raiseBusinessEvent(ctx, new GenericEvent("PaymentOrderCreated", paymentOrderEvent));
		}

		return entityarray;
	}

	private AllPaymentStatus readStatus(com.temenos.microservice.paymentorder.entity.PaymentOrder[] paymentOrder) {
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
