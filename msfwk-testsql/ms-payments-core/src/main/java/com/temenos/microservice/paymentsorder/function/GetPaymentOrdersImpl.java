/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
//***AUTO GENERATED CODE***

/*
 * Environment variable should be provided as follows
 * className_GetPaymentOrders: com.temenos.microservice.paymentsorder.function.GetPaymentOrdersImpl
*/

package com.temenos.microservice.paymentsorder.function;

import com.temenos.microservice.paymentsorder.view.*;
import com.temenos.microservice.framework.core.function.*;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.function.GetPaymentOrderInput;
import com.temenos.microservice.payments.view.PaymentOrderStatus;

import static com.temenos.microservice.framework.core.util.OpenAPIUtil.formatDate;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import com.temenos.microservice.framework.core.FunctionException;

public class GetPaymentOrdersImpl implements GetPaymentOrders {

	

	@Override
	public PaymentOrders invoke(Context context, GetPaymentOrdersInput input) throws FunctionException {
		return processorInvoke(context, input);
	}
	
	public static Charset charset = Charset.forName("UTF-8");
	public static CharsetEncoder encoder = charset.newEncoder();

	public PaymentOrders processorInvoke(Context ctx, GetPaymentOrdersInput input) throws FunctionException {
    
		CriteriaBuilder criteriaBuilder = PaymentOrderDao
				.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao().getEntityManager()
				.getCriteriaBuilder();
		CriteriaQuery<com.temenos.microservice.payments.entity.PaymentOrder> criteriaQuery = criteriaBuilder
				.createQuery(com.temenos.microservice.payments.entity.PaymentOrder.class);
		Root<com.temenos.microservice.payments.entity.PaymentOrder> root = criteriaQuery
				.from(com.temenos.microservice.payments.entity.PaymentOrder.class);
		criteriaQuery.select(root);

		List<com.temenos.microservice.payments.entity.PaymentOrder> entities = null;

		if (input.getParams().get().getPageNumber() != null || input.getParams().get().getPageSize() != null) {
			int[] pageDetails = new int[2];
			if (input.getParams().get().getPageNumber() != null) {
				if (input.getParams().get().getPageNumber().get(0) != null
						&& input.getParams().get().getPageNumber().get(0) > 0)
					pageDetails[0] = input.getParams().get().getPageNumber().get(0);
			}
			if (input.getParams().get().getPageSize() != null) {
				if (input.getParams().get().getPageSize().get(0) != null
						&& input.getParams().get().getPageSize().get(0) > 0)
					pageDetails[1] = input.getParams().get().getPageSize().get(0);
			}
			entities = PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class)
					.getSqlDao().executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, null,
							com.temenos.microservice.payments.entity.PaymentOrder.class, pageDetails);
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
			view.setExtensionData(entity.getExtensionData());

			com.temenos.microservice.paymentsorder.view.Card card = new com.temenos.microservice.paymentsorder.view.Card();
			if (entity.getPaymentMethod() != null) {
				if (entity.getPaymentMethod().getCard() != null) {
					card.setCardid(entity.getPaymentMethod().getCard().getCardid());
					card.setCardname(entity.getPaymentMethod().getCard().getCardname());
					card.setCardlimit(entity.getPaymentMethod().getCard().getCardlimit());
				}
				com.temenos.microservice.paymentsorder.view.PaymentMethod paymentMethod = new com.temenos.microservice.paymentsorder.view.PaymentMethod();
				paymentMethod.setId(entity.getPaymentMethod().getId());
				paymentMethod.setName(entity.getPaymentMethod().getName());
				paymentMethod.setCard(card);
				view.setPaymentMethod(paymentMethod);
			}
			if (entity.getExchangeRates() != null && !entity.getExchangeRates().isEmpty()) {
				List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
				for (com.temenos.microservice.payments.entity.ExchangeRate exchangeEntity : entity.getExchangeRates()) {
					ExchangeRate exchangeRate = new ExchangeRate();
					exchangeRate.setId(exchangeEntity.getId());
					exchangeRate.setName(exchangeEntity.getName());
					exchangeRate.setValue(exchangeEntity.getValue());
					exchangeRates.add(exchangeRate);
				}
				view.setExchangeRates(exchangeRates);
			}
			com.temenos.microservice.paymentsorder.view.PayeeDetails payeeDtls = new com.temenos.microservice.paymentsorder.view.PayeeDetails();
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