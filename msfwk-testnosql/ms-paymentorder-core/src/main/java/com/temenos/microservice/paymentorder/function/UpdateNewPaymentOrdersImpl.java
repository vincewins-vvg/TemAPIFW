/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.Criterion;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.view.AllPaymentStatus;
import com.temenos.microservice.paymentorder.entity.Card;
import com.temenos.microservice.paymentorder.entity.ExchangeRate;
import com.temenos.microservice.paymentorder.entity.PaymentMethod;
import com.temenos.microservice.paymentorder.entity.PaymentOrder;
import com.temenos.microservice.paymentorder.view.PaymentStatus;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.Operator;

public class UpdateNewPaymentOrdersImpl implements UpdateNewPaymentOrders {

	@Override
	public AllPaymentStatus invoke(Context ctx, UpdateNewPaymentOrdersInput input) throws FunctionException {
		if (input.getBody() == null) {
			throw new InvalidInputException(new FailureMessage("Body is Null"));
		}
		if (input.getBody().get().getPaymentStatus() == null) {
			throw new InvalidInputException(new FailureMessage("Payment Status are Null"));
		}
		AllPaymentStatus listOfPaymentStatus = input.getBody().get().getPaymentStatus();
		if (listOfPaymentStatus == null) {
			throw new InvalidInputException(new FailureMessage("Payment Status items are Null"));
		}
		if (listOfPaymentStatus.isEmpty()) {
			throw new InvalidInputException(new FailureMessage("The items are empty"));
		}
		PaymentStatus[] paymentStatusArray = new PaymentStatus[listOfPaymentStatus.size()];
		for (int i = 0; i < listOfPaymentStatus.size(); i++) {
			paymentStatusArray[i] = listOfPaymentStatus.get(i);
		}
		String[] paymentOrderArray = new String[paymentStatusArray.length];
		List<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderOoutputList = new ArrayList<com.temenos.microservice.paymentorder.entity.PaymentOrder>();
		for (int i = 0; i < paymentStatusArray.length; i++) {
			if (paymentStatusArray[i].getPaymentId() == null || paymentStatusArray[i].getDebitAccount() == null) {
				throw new InvalidInputException(
						new FailureMessage("The one or more items are not having PaymentId or DebitAccount "));
			}
			String paymentOrderId = paymentStatusArray[i].getPaymentId();
			paymentOrderArray[i] = paymentOrderId;
			String debitAccount = paymentStatusArray[i].getDebitAccount();
			PaymentStatus paymentStatus = paymentStatusArray[i];
			NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
					.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
			
			Optional<PaymentOrder> paymentOrderOptResult = paymentOrderDao.getByPartitionKeyAndSortKey(paymentOrderId,
					debitAccount);
			
			if (paymentOrderOptResult.isPresent()) {
				PaymentOrder paymentOrderOpt =paymentOrderOptResult.get();
				if (paymentOrderOpt.getPaymentOrderId() != null && paymentStatus.getPaymentId() != null
						&& !paymentOrderOpt.getPaymentOrderId().equalsIgnoreCase(paymentStatus.getPaymentId())) {
					throw new InvalidInputException(
							new FailureMessage("One or more Invalid Payment order Ids Entered in Json Body",
									MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
				}
				if (paymentOrderOpt.getDebitAccount() != null && debitAccount != null
						&& !paymentOrderOpt.getDebitAccount().equalsIgnoreCase(debitAccount)) {
					throw new InvalidInputException(new FailureMessage("One  or more Invalid Debit Accounts Entered",
							MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
				}
				paymentOrderOpt.setStatus(paymentStatus.getStatus());
				if (paymentStatus.getPaymentMethod() != null) {
					Card card = new Card();
					card.setCardid(paymentStatus.getPaymentMethod().getCard().getCardid());
					card.setCardname(paymentStatus.getPaymentMethod().getCard().getCardname());
					card.setCardlimit(paymentStatus.getPaymentMethod().getCard().getCardlimit());

					PaymentMethod paymentMethod = new PaymentMethod();
					paymentMethod.setId(paymentStatus.getPaymentMethod().getId());
					paymentMethod.setName(paymentStatus.getPaymentMethod().getName());
					paymentMethod.setCard(card);
					paymentOrderOpt.setPaymentMethod(paymentMethod);
				}
				if (paymentStatus.getExchangeRates() != null) {
					List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
					for (com.temenos.microservice.paymentorder.view.ExchangeRate exchangeView : paymentStatus
							.getExchangeRates()) {
						ExchangeRate exchangeRate = new ExchangeRate();
						if (exchangeView.getId() != null) {
							exchangeRate.setId(exchangeView.getId());
						}
						exchangeRate.setName(exchangeView.getName());
						exchangeRate.setValue(exchangeView.getValue());
						exchangeRates.add(exchangeRate);
					}
					paymentOrderOpt.setExchangeRates(exchangeRates);
				}
				paymentOrderOoutputList.add(paymentOrderOpt);

			} else {
				throw new InvalidInputException(new FailureMessage("One or more Invalid Payment Order Id Entered",
						MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
			}
		}
		
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		
		
		paymentOrderDao.saveOrMergeEntityList(paymentOrderOoutputList, false);
		return readStatus(paymentStatusArray, paymentOrderArray, paymentOrderOoutputList);
	}
	
	private AllPaymentStatus readStatus(PaymentStatus[] paymentStatusArray, String[] paymentOrderId,
			List<PaymentOrder> paymentOrderOoutputList) throws FunctionException {

		AllPaymentStatus allPaymentStatus = new AllPaymentStatus();
		for (int i = 0; i < paymentStatusArray.length; i++) {
			NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
					.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
			
			List<com.temenos.microservice.paymentorder.entity.PaymentOrder> entities = null;
			Criteria criteria = new Criteria();
			Criterion<Object> criterion = new CriterionImpl("paymentOrderId", paymentOrderId[i],
					Operator.equal);
			criteria.add(criterion);
			entities =paymentOrderDao.getByIndexes(criteria);
			if(entities!=null&&entities.size()>0) {
				PaymentOrder paymentOrderOpt = entities.get(0);
						
				PaymentStatus paymentStatus = new PaymentStatus();
				if (paymentOrderOpt != null) {
					paymentStatus.setPaymentId(paymentOrderId[i]);
					paymentStatus.setStatus(paymentOrderOoutputList.get(i).getStatus());
				}
				allPaymentStatus.add(paymentStatus);
		
			}
		}	
		return allPaymentStatus;
	}


}
