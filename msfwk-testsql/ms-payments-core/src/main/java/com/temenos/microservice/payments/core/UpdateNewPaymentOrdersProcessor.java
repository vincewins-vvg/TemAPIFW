package com.temenos.microservice.payments.core;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.Card;
import com.temenos.microservice.payments.entity.ExchangeRate;
import com.temenos.microservice.payments.entity.PaymentMethod;
import com.temenos.microservice.payments.entity.PaymentOrder;
import com.temenos.microservice.payments.function.UpdateNewPaymentOrdersInput;
import com.temenos.microservice.payments.function.UpdatePaymentOrderInput;
import com.temenos.microservice.payments.view.AllPaymentStatus;
import com.temenos.microservice.payments.view.PaymentOrders;
import com.temenos.microservice.payments.view.PaymentStatus;
import com.temenos.microservice.payments.view.PaymentStatusList;

@Component
public class UpdateNewPaymentOrdersProcessor {

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
		List<com.temenos.microservice.payments.entity.PaymentOrder> paymentOrderOoutputList = new ArrayList<com.temenos.microservice.payments.entity.PaymentOrder>();
		for (int i = 0; i < paymentStatusArray.length; i++) {
			if (paymentStatusArray[i].getPaymentId() == null || paymentStatusArray[i].getDebitAccount() == null) {
				throw new InvalidInputException(
						new FailureMessage("The one or more items are not having PaymentId or DebitAccount "));
			}
			String paymentOrderId = paymentStatusArray[i].getPaymentId();
			paymentOrderArray[i] = paymentOrderId;
			String debitAccount = paymentStatusArray[i].getDebitAccount();
			PaymentStatus paymentStatus = paymentStatusArray[i];
			PaymentOrder paymentOrderOpt = (PaymentOrder) PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao()
					.findById(paymentOrderId, com.temenos.microservice.payments.entity.PaymentOrder.class);
			if (paymentOrderOpt != null) {
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
					for (com.temenos.microservice.payments.view.ExchangeRate exchangeView : paymentStatus
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
		PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.saveOrMergeEntityList(paymentOrderOoutputList, false);
		return readStatus(paymentStatusArray, paymentOrderArray, paymentOrderOoutputList);
	}

	private AllPaymentStatus readStatus(PaymentStatus[] paymentStatusArray, String[] paymentOrderId,
			List<PaymentOrder> paymentOrderOoutputList) throws FunctionException {

		AllPaymentStatus allPaymentStatus = new AllPaymentStatus();
		for (int i = 0; i < paymentStatusArray.length; i++) {
			PaymentOrder paymentOrderOpt = (PaymentOrder) PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao()
					.findById(paymentOrderId[i], com.temenos.microservice.payments.entity.PaymentOrder.class);
			PaymentStatus paymentStatus = new PaymentStatus();
			if (paymentOrderOpt != null) {
				paymentStatus.setPaymentId(paymentOrderId[i]);
				paymentStatus.setStatus(paymentOrderOoutputList.get(i).getStatus());
			}
			allPaymentStatus.add(paymentStatus);
		}
		return allPaymentStatus;
	}

}
