/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.temenos.connect.InboxOutbox.logger.InboxOutboxConstants;
import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.function.OutOfSequenceException;
import com.temenos.microservice.framework.core.function.Request;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.framework.core.tracer.Tracer;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.framework.core.util.SequenceUtil;
import com.temenos.microservice.paymentorder.entity.Card;
import com.temenos.microservice.paymentorder.entity.ExchangeRate;
import com.temenos.microservice.paymentorder.entity.PaymentMethod;
import com.temenos.microservice.paymentorder.entity.PaymentOrder;
import com.temenos.microservice.paymentorder.view.PaymentStatus;
import com.temenos.microservice.payments.event.PaymentUpdated;

public class UpdatePaymentOrderImpl implements UpdatePaymentOrder {

	@Override
	public PaymentStatus invoke(Context ctx, UpdatePaymentOrderInput input) throws FunctionException {
		PaymentStatus paymentStatus = input.getBody().get();
		String paymentOrderId = input.getParams().get().getPaymentId().get(0);
		String debitAccount = input.getBody().get().getDebitAccount();
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		Optional<PaymentOrder> paymentOrderOpt = paymentOrderDao.getByPartitionKeyAndSortKey(paymentOrderId,
				debitAccount);
		if (paymentOrderOpt.isPresent()) {
			if (paymentOrderOpt.get().getPaymentOrderId() != null && paymentStatus.getPaymentId() != null
					&& !paymentOrderOpt.get().getPaymentOrderId().equalsIgnoreCase(paymentStatus.getPaymentId())) {
				throw new InvalidInputException(new FailureMessage("Invalid Payment order Id Entered in Json Body",
						MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
			}
			if (paymentOrderOpt.get().getDebitAccount() != null && debitAccount != null
					&& !paymentOrderOpt.get().getDebitAccount().equalsIgnoreCase(debitAccount)) {
				throw new InvalidInputException(new FailureMessage("Invalid Debit Account Entered",
						MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
			}
			PaymentOrder paymentOrder = paymentOrderOpt.get();
			if (paymentStatus.getStatus() != null) {
				paymentOrder.setStatus(paymentStatus.getStatus());
				paymentOrder.setExtensionData((Map<String, String>) paymentStatus.getExtensionData());
			}

			if (paymentStatus.getPaymentMethod() != null) {
				Card card = new Card();
				card.setCardid(paymentStatus.getPaymentMethod().getCard().getCardid());
				card.setCardname(paymentStatus.getPaymentMethod().getCard().getCardname());
				card.setCardlimit(paymentStatus.getPaymentMethod().getCard().getCardlimit());

				PaymentMethod paymentMethod = new PaymentMethod();
				paymentMethod.setId(paymentStatus.getPaymentMethod().getId());
				paymentMethod.setName(paymentStatus.getPaymentMethod().getName());
				paymentMethod.setCard(card);
				paymentOrder.setPaymentMethod(paymentMethod);
			}
			if (paymentStatus.getExchangeRates() != null) {
				List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
				for (com.temenos.microservice.paymentorder.view.ExchangeRate erView : paymentStatus
						.getExchangeRates()) {
					ExchangeRate exchangeRate = new ExchangeRate();
					if (erView.getId() != null) {
						exchangeRate.setId(erView.getId());
					}
					exchangeRate.setName(erView.getName());
					exchangeRate.setValue(erView.getValue());
					exchangeRates.add(exchangeRate);
				}
				paymentOrder.setExchangeRates(exchangeRates);
			}
			paymentOrderDao.saveEntity(paymentOrder);
			PaymentUpdated paymentUpdated = new PaymentUpdated();
			paymentUpdated.setPaymentOrderId(paymentOrderId);
			EventManager.raiseBusinessEvent(ctx, new GenericEvent("PaymentUpdated", paymentUpdated), paymentOrder);
			
			if (paymentOrderId.equals("PO~2568~2578~USD~45") && paymentStatus.getStatus().equals("holdUpdate")) {
				try {
					System.out.println("Timed wait started");
					Thread.sleep(50000);
					System.out.println("Timed wait Ended");
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		} else {
			throw new InvalidInputException(new FailureMessage("Invalid Payment Order Id Entered",
					MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}
		ctx.setBusinessKey(paymentOrderId);
		return readStatus(debitAccount, paymentOrderId, paymentStatus.getStatus());
	}

	private PaymentStatus readStatus(String debitAccount, String paymentOrderId, String pymtStatus)
			throws FunctionException {
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		Optional<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderOpt = paymentOrderDao
				.getByPartitionKeyAndSortKey(paymentOrderId, debitAccount);
		PaymentStatus paymentStatus = new PaymentStatus();
		if (paymentOrderOpt.isPresent()) {
			PaymentOrder paymentOrder = paymentOrderOpt.get();
			paymentStatus.setPaymentId(paymentOrderId);
			paymentStatus.setStatus(pymtStatus);
		}
		return paymentStatus;
	}

	@Override
	public void isSequenceValid(final Context ctx) throws FunctionException {
		Request<String> request = (Request<String>) ctx.getRequest();
		Map<String, List<String>> headers = request.getHeaders();
		String businessKey = headers.get(InboxOutboxConstants.BUSINESS_KEY).get(0);
		Long sequenceNo = Long.valueOf(headers.get(InboxOutboxConstants.SEQUENCE_NO).get(0));
		String sourceId = headers.get(InboxOutboxConstants.EVENT_SOURCE).get(0);
		Long expectedSequenceNo = null;

		switch (Environment.getDatabase()) {
		case Environment.DATABASE_MONGODB:
			expectedSequenceNo = SequenceUtil.generateSequenceNumber(businessKey, sourceId);
			break;
		case Environment.DATABASE_POSTGRESQL:
			expectedSequenceNo = SequenceUtil.generateSequenceNumber(businessKey, sourceId);
			break;					
		case Environment.DATABASE_DYNAMODB:
			expectedSequenceNo = PaymentOrderFunctionHelper.validateAndUpdateSequenceNumber(businessKey, sourceId,
					sequenceNo);
			break;		
		default:
			throw new InvalidInputException(
					new FailureMessage("Invalid database name", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}

		if (!expectedSequenceNo.equals(sequenceNo)) {
			throw new OutOfSequenceException("Invalid sequence number: " + sequenceNo);
		}
	}
}
