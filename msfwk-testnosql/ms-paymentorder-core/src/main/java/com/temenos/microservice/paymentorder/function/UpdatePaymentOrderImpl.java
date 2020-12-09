package com.temenos.microservice.paymentorder.function;

import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.function.OutOfSequenceException;
import com.temenos.microservice.framework.core.function.Request;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.framework.core.util.SequenceUtil;
import com.temenos.microservice.paymentorder.entity.Card;
import com.temenos.microservice.paymentorder.entity.ExchangeRate;
import com.temenos.microservice.paymentorder.entity.PaymentMethod;

import com.temenos.microservice.paymentorder.entity.PaymentOrder;
import com.temenos.microservice.paymentorder.function.UpdatePaymentOrder;
import com.temenos.microservice.paymentorder.function.UpdatePaymentOrderInput;
import com.temenos.microservice.paymentorder.view.PaymentStatus;
import com.temenos.microservice.framework.core.function.FailureMessage;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.temenos.connect.InboxOutbox.logger.InboxOutboxConstants;
import com.temenos.microservice.framework.core.FunctionException;

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
			if(paymentStatus.getStatus() != null) {
				paymentOrder.setStatus(paymentStatus.getStatus());
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
		} else {
			throw new InvalidInputException(new FailureMessage("Invalid Payment Order Id Entered",
					MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}
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
		Map<String,List<String>> headers = request.getHeaders();
		List<String> businessKeys = headers.get(InboxOutboxConstants.BUSINESS_KEY);
		List<String> sequenceNos = headers.get(InboxOutboxConstants.SEQUENCE_NO);
		List<String> sourceIds = headers.get(InboxOutboxConstants.EVENT_SOURCE);
		String businessKey = (businessKeys != null && !businessKeys.isEmpty()) ? businessKeys.get(0) : null;
		if (businessKey != null) {
			Long sequenceNo = (sequenceNos != null && !sequenceNos.isEmpty()) ? Long.valueOf(sequenceNos.get(0)) : null;
			String sourceId = (sourceIds != null && !sourceIds.isEmpty()) ? sourceIds.get(0) : null;
			Long expectedSequenceNo = SequenceUtil.generateSequenceNumber(businessKey, sourceId);
			if (sequenceNo == null || !expectedSequenceNo.equals(sequenceNo)) {
				throw new OutOfSequenceException("Invalid sequence number: " + sequenceNo);
			} 
		}
	}
}
