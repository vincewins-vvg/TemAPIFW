package com.temenos.microservice.payments.core;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.function.GetPaymentOrdersInput;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentOrders;

@Component
public class GetPaymentOrdersProcessor {

	public PaymentOrders invoke(Context ctx, GetPaymentOrdersInput input) throws FunctionException {

		CriteriaBuilder criteriaBuilder = PaymentOrderDao
				.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao().getEntityManager()
				.getCriteriaBuilder();
		CriteriaQuery<com.temenos.microservice.payments.entity.PaymentOrder> criteriaQuery = criteriaBuilder
				.createQuery(com.temenos.microservice.payments.entity.PaymentOrder.class);
		Root<com.temenos.microservice.payments.entity.PaymentOrder> root = criteriaQuery
				.from(com.temenos.microservice.payments.entity.PaymentOrder.class);
		criteriaQuery.select(root);
		criteriaQuery.distinct(true);

		List<Predicate> predicates = new ArrayList<Predicate>();
		predicates.add(criteriaBuilder.and(criteriaBuilder.equal(root.get("status"), "INITIATED")));

		List<com.temenos.microservice.payments.entity.PaymentOrder> entities = PaymentOrderDao
				.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, predicates,
						com.temenos.microservice.payments.entity.PaymentOrder.class);

		List<PaymentOrder> views = new ArrayList<PaymentOrder>();
		for (com.temenos.microservice.payments.entity.PaymentOrder entity : entities) {
			PaymentOrder view = new PaymentOrder();
			view.setAmount(entity.getAmount());
			view.setCurrency(entity.getCurrency());
			view.setFromAccount(entity.getDebitAccount());
			view.setToAccount(entity.getCreditAccount());
			views.add(view);
		}
		PaymentOrders orders = new PaymentOrders();
		orders.addItems(views.toArray(new PaymentOrder[0]));
		return orders;
	}
}
