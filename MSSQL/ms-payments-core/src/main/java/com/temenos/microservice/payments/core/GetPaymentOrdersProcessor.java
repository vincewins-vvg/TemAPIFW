package com.temenos.microservice.payments.core;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.ParameterExpression;
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

		EntityManager em = PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class)
				.getSqlDao().getEntityManager();

		CriteriaBuilder criteriaBuilder = em.getCriteriaBuilder();
		CriteriaQuery<com.temenos.microservice.payments.entity.PaymentOrder> criteriaQuery = criteriaBuilder
				.createQuery(com.temenos.microservice.payments.entity.PaymentOrder.class);
		Root<com.temenos.microservice.payments.entity.PaymentOrder> root = criteriaQuery
				.from(com.temenos.microservice.payments.entity.PaymentOrder.class);
		criteriaQuery.select(root);

		ParameterExpression<String> statusParam = criteriaBuilder.parameter(String.class, "status");

		List<Predicate> predicateList = new ArrayList<Predicate>();
		predicateList.add(criteriaBuilder.and(criteriaBuilder.equal(root.get("status"), statusParam)));

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("status", "INITIATED");

		List<com.temenos.microservice.payments.entity.PaymentOrder> entities = PaymentOrderDao
				.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.executeQuery(criteriaBuilder, criteriaQuery, root, predicateList, parameters,
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
