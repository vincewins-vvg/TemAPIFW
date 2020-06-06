package com.temenos.microservice.payments.core;

import java.text.ParseException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.data.sql.ReferenceDataEntity;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.framework.core.util.DataTypeConverter;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.Card;
import com.temenos.microservice.payments.entity.ExchangeRate;
import com.temenos.microservice.payments.entity.PayeeDetails;
import com.temenos.microservice.payments.event.CreatePaymentEvent;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderInput;
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
		//PaymentOrderItems 
	
			if(input.getBody().get().getPaymentOrders() != null) {
					PaymentOrders PaymentOrders = input.getBody().get().getPaymentOrders();
					if(PaymentOrders.getItems() != null && PaymentOrders.getItems().length > 0) {
					for(int i=0;i<PaymentOrders.getItems().length;i++){
					PaymentOrderFunctionHelper.validatePaymentOrder(PaymentOrders.getItems()[i], ctx);
					}
					allPaymentStatus = executePaymentOrders(ctx, PaymentOrders.getItems());	
					} else {
						throw new InvalidInputException(new FailureMessage("Input items are empty or invalid", "PAYM-PORD-A-2002"));
					}
			} else {
				throw new InvalidInputException(new FailureMessage("Input body is invalid", "PAYM-PORD-A-2002"));
			}	
		return allPaymentStatus;
	}

	private AllPaymentStatus executePaymentOrders(Context ctx, PaymentOrder[] paymentOrder) throws FunctionException {
		String[] paymentOrderId = new String[paymentOrder.length];		
		com.temenos.microservice.payments.entity.PaymentOrder[] entity = new com.temenos.microservice.payments.entity.PaymentOrder[paymentOrder.length];
		for(int i=0;i<paymentOrder.length;i++) {
			paymentOrderId[i] = ("PO~" + paymentOrder[i].getFromAccount() + "~" + paymentOrder[i].getToAccount() + "~"
				+ paymentOrder[i].getCurrency() + "~" + paymentOrder[i].getAmount()).toUpperCase();	
		if (paymentOrderId != null) {
			com.temenos.microservice.payments.entity.PaymentOrder paymentsOrder = (com.temenos.microservice.payments.entity.PaymentOrder) PaymentOrderDao
					.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao().findById(paymentOrderId[i], com.temenos.microservice.payments.entity.PaymentOrder.class);
			if (paymentsOrder != null && paymentsOrder.getPaymentOrderId() != null) {
				throw new InvalidInputException(new FailureMessage("One or More Of the Records already exists", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
			}
		}			
		}	
		entity = createEntity(ctx, paymentOrderId, paymentOrder);
		return readStatus(entity);
	}

	private com.temenos.microservice.payments.entity.PaymentOrder[] createEntity(Context ctx, String[] paymentOrderId,
			PaymentOrder[] view) throws FunctionException {
		List<com.temenos.microservice.payments.entity.PaymentOrder> entityarrayList = new ArrayList<com.temenos.microservice.payments.entity.PaymentOrder>();
		com.temenos.microservice.payments.entity.PaymentOrder[] entityarray = new com.temenos.microservice.payments.entity.PaymentOrder[view.length];
		for(int i =0;i<view.length;i++) {
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
			entity.getPaymentMethod().setExtensionData((Map<String, String>) view[i].getPaymentMethod().getExtensionData());
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
		CreatePaymentEvent paymentOrderEvent = new CreatePaymentEvent();
		paymentOrderEvent.setPaymentOrderId(entity.getPaymentOrderId());
		paymentOrderEvent.setAmount(entity.getAmount());
		paymentOrderEvent.setCreditAccount(entity.getCreditAccount());
		paymentOrderEvent.setCurrency(entity.getCurrency());
		paymentOrderEvent.setDebitAccount(entity.getDebitAccount());
		EventManager.raiseBusinessEvent(ctx,new GenericEvent(Environment.getMSName() + ".PaymentOrderCreated", paymentOrderEvent));
		entityarrayList.add(entity);
		entityarray[i] = entity;
		}
	    PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao().saveOrMergeEntityList(entityarrayList, false);    
		return entityarray;
	}

	private AllPaymentStatus readStatus(com.temenos.microservice.payments.entity.PaymentOrder[] paymentOrder) {
		AllPaymentStatus allPaymentStatus = new AllPaymentStatus();
		PaymentStatus[] paymentStatuses = new PaymentStatus[paymentOrder.length];
		for(int i=0;i<paymentOrder.length;i++) {
			PaymentStatus paymentStatus = new PaymentStatus();
			paymentStatus.setPaymentId(paymentOrder[i].getPaymentOrderId());
			paymentStatus.setStatus(paymentOrder[i].getStatus());
			paymentStatus.setDetails(paymentOrder[i].getPaymentDetails());
			paymentStatuses[i] = paymentStatus;
		}
		allPaymentStatus.addItems(paymentStatuses);
		return allPaymentStatus;
	}
}
