/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.core;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

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
import com.temenos.microservice.payments.dao.AccountingDao;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.Accounting;
import com.temenos.microservice.payments.entity.PaymentMethod;
import com.temenos.microservice.payments.entity.PaymentOrder;
import com.temenos.microservice.payments.event.PaymentDeleted;
import com.temenos.microservice.payments.function.DeletePaymentOrdersInput;
import com.temenos.microservice.payments.view.AllPaymentStatus;
import com.temenos.microservice.payments.view.PaymentStatus;

@Component
public class DeletePaymentOrdersProcessor {

	public AllPaymentStatus invoke(Context ctx, DeletePaymentOrdersInput input) throws FunctionException {
		if (input.getParams() == null && input.getParams().get().getPaymentIds().get(0) == null) {
			throw new InvalidInputException(new FailureMessage("The Parameters of Payment Ids are not present"));
		}
		String[] paymentId = input.getParams().get().getPaymentIds().get(0).split(",");
		// To Remove Duplicates
		Set<String> paymentIdSet = new HashSet<String>(Arrays.asList(paymentId));
		ArrayList<String> paymentIdList = new ArrayList<String>(paymentIdSet);
		List<Object> poList = new ArrayList<Object>();
		for (int i = 0; i < paymentIdList.size(); i++) {
			PaymentOrder paymentOrderOpt = (PaymentOrder) PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao()
					.findByIdForUpdate(paymentIdList.get(i), com.temenos.microservice.payments.entity.PaymentOrder.class);
			if (paymentOrderOpt != null) {
				// Set Method as null as it is the foreign key constraint
				if (paymentOrderOpt.getPaymentMethod() != null) {
					PaymentMethod paymentMethod = new PaymentMethod();
					paymentOrderOpt.setPaymentMethod(null);
					PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
							.saveOrMergeEntity(paymentOrderOpt, false);
				}
				poList.add(paymentOrderOpt);
			} else {
				throw new InvalidInputException(new FailureMessage("One or more Invalid Payment Order Ids Entered"));
			}
		}
		PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.deleteByIdList(poList);
		for(Object po : poList) {
			PaymentOrder paymentOrder = (PaymentOrder) po;
			PaymentDeleted paymentDeleted = new PaymentDeleted();
			paymentDeleted.setPaymentOrderId(paymentOrder.getPaymentOrderId());
			ctx.setBusinessKey(paymentOrder.getPaymentOrderId());
			//paymentDeleted.setChangedEntityValues(paymentOrder.stateChangeForDelete());
			List<com.temenos.microservice.payments.entity.Accounting> accountingEntities = getAccounting(paymentOrder.getPaymentOrderId());
			deleteAccounting(accountingEntities);
			EventManager.raiseBusinessEvent(ctx, new GenericEvent("PaymentDeleted", paymentDeleted), po, accountingEntities.get(0), accountingEntities.get(1));
		}
		AllPaymentStatus allPaymentStatus = new AllPaymentStatus();
		for (int i = 0; i < paymentIdList.size(); i++) {
			PaymentStatus paymentStatus = new PaymentStatus();
			paymentStatus.setStatus("Deleted this PaymentId	: " + paymentIdList.get(i));
			allPaymentStatus.add(paymentStatus);
		}
		return allPaymentStatus;
	}

	private List<Accounting> getAccounting(String paymentOrderId) throws DataAccessException {

		List<com.temenos.microservice.payments.entity.Accounting> entityArrayList = new ArrayList<com.temenos.microservice.payments.entity.Accounting>();

		CriteriaBuilder criteriaBuilder = AccountingDao
				.getInstance(com.temenos.microservice.payments.entity.Accounting.class).getSqlDao().getEntityManager()
				.getCriteriaBuilder();
		CriteriaQuery<com.temenos.microservice.payments.entity.Accounting> criteriaQuery = criteriaBuilder
				.createQuery(com.temenos.microservice.payments.entity.Accounting.class);
		Root<com.temenos.microservice.payments.entity.Accounting> root = criteriaQuery
				.from(com.temenos.microservice.payments.entity.Accounting.class);
		criteriaQuery.select(root);
		if (paymentOrderId != null) {
			List<Predicate> predicates = new ArrayList<Predicate>();
			predicates.add(criteriaBuilder.and(criteriaBuilder.equal(root.get("paymentOrderId"), paymentOrderId)));
			entityArrayList = AccountingDao.getInstance(com.temenos.microservice.payments.entity.Accounting.class)
					.getSqlDao().executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, predicates,
							com.temenos.microservice.payments.entity.Accounting.class, true, true);
		}
		return entityArrayList;
	}

	private void deleteAccounting(List<Accounting> accountingEntities) throws DatabaseOperationException, DataAccessException {
		AccountingDao.getInstance(com.temenos.microservice.payments.entity.Accounting.class).getSqlDao()
		.deleteByIdList(accountingEntities);
	}

}
