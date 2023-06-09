/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.core;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Component;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.DatabaseOperationException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.dao.AccountingDao;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.Accounting;
import com.temenos.microservice.payments.entity.Card;
import com.temenos.microservice.payments.entity.ExchangeRate;
import com.temenos.microservice.payments.entity.PaymentMethod;
import com.temenos.microservice.payments.entity.PaymentOrder;
import com.temenos.microservice.payments.event.PaymentUpdated;
import com.temenos.microservice.payments.function.UpdatePaymentOrderInput;
import com.temenos.microservice.payments.view.PaymentStatus;

@Component
public class UpdatePaymentOrderProcessor {

	public PaymentStatus invoke(Context ctx, UpdatePaymentOrderInput input) throws FunctionException {
		PaymentStatus paymentStatus = input.getBody().get();
		String paymentOrderId = input.getParams().get().getPaymentId().get(0);
		String debitAccount = input.getBody().get().getDebitAccount();
		PaymentOrder paymentOrderOpt = (PaymentOrder) PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao()
				.findByIdForUpdate(paymentOrderId, com.temenos.microservice.payments.entity.PaymentOrder.class);
		if (paymentOrderOpt != null) {
			if (paymentOrderOpt.getPaymentOrderId() != null && paymentStatus.getPaymentId() != null
					&& !paymentOrderOpt.getPaymentOrderId().equalsIgnoreCase(paymentStatus.getPaymentId())) {
				throw new InvalidInputException(new FailureMessage("Invalid Payment order Id Entered in Json Body",
						MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
			}
			if (paymentOrderOpt.getDebitAccount() != null && debitAccount != null
					&& !paymentOrderOpt.getDebitAccount().equalsIgnoreCase(debitAccount)) {
				throw new InvalidInputException(new FailureMessage("Invalid Debit Account Entered",
						MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
			}
			if (paymentStatus.getStatus() != null) {
				paymentOrderOpt.setStatus(paymentStatus.getStatus());
				paymentOrderOpt.setExtensionData((Map<String, String>) paymentStatus.getExtensionData());
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
			paymentOrderOpt=PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao().save(paymentOrderOpt);
			if (paymentOrderOpt.getPaymentOrderId().equals("PO~2568~2578~USD~45")
					&& paymentOrderOpt.getPaymentDetails().equals("refDet")) {
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
		PaymentUpdated paymentUpdated = new PaymentUpdated();
		paymentUpdated.setPaymentOrderId(paymentOrderId);
		//paymentUpdated.setChangedEntityValues(paymentOrderOpt.stateChange());
		List<com.temenos.microservice.payments.entity.Accounting> accountingEntities = updateAccounting(paymentOrderOpt);
		EventManager.raiseBusinessEvent(ctx, new GenericEvent("PaymentUpdated", paymentUpdated), paymentOrderOpt, accountingEntities.get(0), accountingEntities.get(1));
		return readStatus(debitAccount, paymentOrderId, paymentStatus.getStatus());
	}

	private List<Accounting> updateAccounting(PaymentOrder paymentOrderOpt)
			throws DataAccessException {

		List<com.temenos.microservice.payments.entity.Accounting> accountList = new ArrayList<com.temenos.microservice.payments.entity.Accounting>();
		List<com.temenos.microservice.payments.entity.Accounting> updatedaccountList = new ArrayList<com.temenos.microservice.payments.entity.Accounting>();

		CriteriaBuilder criteriaBuilder = AccountingDao
				.getInstance(com.temenos.microservice.payments.entity.Accounting.class).getSqlDao().getEntityManager()
				.getCriteriaBuilder();
		CriteriaQuery<com.temenos.microservice.payments.entity.Accounting> criteriaQuery = criteriaBuilder
				.createQuery(com.temenos.microservice.payments.entity.Accounting.class);
		Root<com.temenos.microservice.payments.entity.Accounting> root = criteriaQuery
				.from(com.temenos.microservice.payments.entity.Accounting.class);
		criteriaQuery.select(root);
		if (paymentOrderOpt.getPaymentOrderId() != null) {
			List<Predicate> predicates = new ArrayList<Predicate>();
			predicates.add(criteriaBuilder
					.and(criteriaBuilder.equal(root.get("paymentOrderId"), paymentOrderOpt.getPaymentOrderId())));
			accountList = AccountingDao.getInstance(com.temenos.microservice.payments.entity.Accounting.class)
					.getSqlDao().executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, predicates,
							com.temenos.microservice.payments.entity.Accounting.class, true, true);
		}

		for (Accounting accountentity : accountList) {
			accountentity.setProcessedDate(Date.from(Instant.now()));
			AccountingDao.getInstance(com.temenos.microservice.payments.entity.Accounting.class).getSqlDao()
					.saveOrMergeEntity(accountentity, false);
			updatedaccountList.add(accountentity);
		}

		return updatedaccountList;
	}

	private PaymentStatus readStatus(String debitAccount, String paymentOrderId, String status)
			throws FunctionException {
		PaymentOrder paymentOrderOpt = (PaymentOrder) PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao()
				.findById(paymentOrderId, com.temenos.microservice.payments.entity.PaymentOrder.class);
		PaymentStatus paymentStatus = new PaymentStatus();
		if (paymentOrderOpt != null) {
			paymentStatus.setPaymentId(paymentOrderId);
			paymentStatus.setStatus(status);
		}
		return paymentStatus;
	}
}
