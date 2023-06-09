/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;

import static com.temenos.microservice.framework.core.util.OpenAPIUtil.formatDate;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.view.EnumCurrency;
import com.temenos.microservice.payments.view.ExchangeRate;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentOrders;

public class GetPaymentOrderCurrencyMultiImpl implements GetPaymentOrderCurrencyMulti {

	/*
	 * @Override public PaymentOrders invoke(Context context,
	 * GetPaymentOrderCurrencyMultiInput input) throws FunctionException {
	 * GetPaymentOrderCurrencyMultiProcessor getPaymentOrderCurrencyMultiProcessor =
	 * (GetPaymentOrderCurrencyMultiProcessor)
	 * com.temenos.microservice.framework.core.SpringContextInitializer
	 * .instance().getBean(GetPaymentOrderCurrencyMultiProcessor.class); return
	 * getPaymentOrderCurrencyMultiProcessor.invoke(context, input); }
	 */
	public static Charset charset = Charset.forName("UTF-8");
	public static CharsetEncoder encoder = charset.newEncoder();

	public PaymentOrders invoke(Context ctx, GetPaymentOrderCurrencyMultiInput input) throws FunctionException {
		List<com.temenos.microservice.payments.entity.PaymentOrder> entities = null;
		CriteriaBuilder criteriaBuilder = PaymentOrderDao
				.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao().getEntityManager()
				.getCriteriaBuilder();
		CriteriaQuery<com.temenos.microservice.payments.entity.PaymentOrder> criteriaQuery = criteriaBuilder
				.createQuery(com.temenos.microservice.payments.entity.PaymentOrder.class);
		Root<com.temenos.microservice.payments.entity.PaymentOrder> root = criteriaQuery
				.from(com.temenos.microservice.payments.entity.PaymentOrder.class);
		criteriaQuery.select(root);
		if (input.getParams().get().getCurrency().get(0) != null) {
			List<Predicate> predicates = new ArrayList<Predicate>();
			predicates.add(criteriaBuilder.and(criteriaBuilder.in(root.get("currency"))
					.value(Arrays.asList(input.getParams().get().getCurrency().get(0).toString().split(",")))));
			entities = PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class)
					.getSqlDao().executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, predicates,
							com.temenos.microservice.payments.entity.PaymentOrder.class);
		} else {
			entities = PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class)
					.getSqlDao().executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, null,
							com.temenos.microservice.payments.entity.PaymentOrder.class);
		}
		PaymentOrders orders = new PaymentOrders();
		for (com.temenos.microservice.payments.entity.PaymentOrder entity : entities) {
			PaymentOrder view = new PaymentOrder();
			view.setAmount(entity.getAmount());
			view.setCurrency(Enum.valueOf(EnumCurrency.class, entity.getCurrency()));
			view.setFromAccount(entity.getDebitAccount());
			view.setToAccount(entity.getCreditAccount());
			if (entity.getFileContent() != null) {
				ByteBuffer byteBuffer;
				try {
					byteBuffer = encoder.encode(CharBuffer.wrap((entity.getFileContent())));
					view.setFileContent(byteBuffer);
				} catch (Exception e) {
					throw new RuntimeException(e.getMessage());
				}
			}
			view.setPaymentDate(formatDate(entity.getPaymentDate()));

			com.temenos.microservice.payments.view.Card card = new com.temenos.microservice.payments.view.Card();
			if (entity.getPaymentMethod() != null) {
				if (entity.getPaymentMethod().getCard() != null) {
					card.setCardid(entity.getPaymentMethod().getCard().getCardid());
					card.setCardname(entity.getPaymentMethod().getCard().getCardname());
					card.setCardlimit(entity.getPaymentMethod().getCard().getCardlimit());
				}
				com.temenos.microservice.payments.view.PaymentMethod paymentMethod = new com.temenos.microservice.payments.view.PaymentMethod();
				paymentMethod.setId(entity.getPaymentMethod().getId());
				paymentMethod.setName(entity.getPaymentMethod().getName());
				paymentMethod.setCard(card);
				view.setPaymentMethod(paymentMethod);
				view.setExtensionData(entity.getExtensionData());

				List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
				for (com.temenos.microservice.payments.entity.ExchangeRate erEntity : entity.getExchangeRates()) {
					ExchangeRate exchangeRate = new ExchangeRate();
					exchangeRate.setId(erEntity.getId());
					exchangeRate.setName(erEntity.getName());
					exchangeRate.setValue(erEntity.getValue());
					exchangeRates.add(exchangeRate);
				}
				view.setExchangeRates(exchangeRates);
			}
			com.temenos.microservice.payments.view.PayeeDetails payeeDtls = new com.temenos.microservice.payments.view.PayeeDetails();
			if (entity.getPayeeDetails() != null) {
				payeeDtls.setPayeeName(entity.getPayeeDetails().getPayeeName());
				payeeDtls.setPayeeType(entity.getPayeeDetails().getPayeeType());
				view.setPayeeDetails(payeeDtls);
			}
			orders.add(view);
		}

		return orders;
	}

}
