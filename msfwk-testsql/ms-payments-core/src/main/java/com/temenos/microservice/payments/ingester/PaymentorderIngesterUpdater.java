package com.temenos.microservice.payments.ingester;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONObject;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.SpringContextInitializer;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.ingester.BaseIngester;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class PaymentorderIngesterUpdater extends BaseIngester {
	private PaymentOrder order;
	Map<String, Entity> entityMap;

	public PaymentorderIngesterUpdater() {
	}

	@Override
	public void update() throws FunctionException {
		PaymentsIngesterProcessor paymentsIngesterProcessor = (PaymentsIngesterProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(PaymentsIngesterProcessor.class);
		Iterator<Entity> iterator = entityMap.values().iterator();
		while (iterator.hasNext()) {
			PaymentOrder paymentOrder = (PaymentOrder) iterator.next();
			paymentsIngesterProcessor.ingestPaymentOrder(paymentOrder);
		}
	}

	/**
	 * Check And Build.
	 */
	private void checkAndBuild(JSONObject jsonObject) {
		PaymentOrderRecord orderRecord = new PaymentOrderRecord(jsonObject);

		try {
			order = PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao()
					.findById(orderRecord.getPaymentOrderId(), PaymentOrder.class);
		} catch (DataAccessException e) {
			throw new RuntimeException(e);
		}

		if (order == null) {
			order = new PaymentOrder();
			order.setPaymentOrderId(orderRecord.getPaymentOrderId());
		}

		order.setAmount(orderRecord.getAmount());
		order.setCreditAccount(orderRecord.getCreditAccount());
		order.setCurrency(orderRecord.getCurrency());
		order.setDebitAccount(orderRecord.getDebitAccount());
		order.setPaymentDate(orderRecord.getPaymentDate());
		order.setPaymentDetails(orderRecord.getPaymentDetails());
		order.setPaymentReference(orderRecord.getPaymentReference());
		order.setStatus(orderRecord.getStatus());
		com.temenos.microservice.payments.entity.PaymentMethod paymentMethod = new com.temenos.microservice.payments.entity.PaymentMethod();
		paymentMethod.setId(new java.util.Random().nextLong());
		paymentMethod.setName("CARD");
		com.temenos.microservice.payments.entity.Card card = new com.temenos.microservice.payments.entity.Card();
		card.setCardid(new java.util.Random().nextLong());
		card.setCardlimit(new java.math.BigDecimal("44"));
		card.setCardname("test");
		card.setExtensionData(new java.util.HashMap<String,String>());
		paymentMethod.setCard(card);
		order.setPaymentMethod(paymentMethod);
		java.util.List<com.temenos.microservice.payments.entity.ExchangeRate> exchangeList = new java.util.ArrayList<com.temenos.microservice.payments.entity.ExchangeRate>();
		order.setExchangeRates(exchangeList);
	}

	@Override
	public void transform(JSONObject jsonObject) throws FunctionException {

		checkAndBuild(jsonObject);
	}

	@Override
	public Map<String, Entity> setEntityMap() {
		entityMap = new HashMap<String, Entity>();
		entityMap.put("com.temenos.microservice.payments.entity.PaymentOrder", order);
		return entityMap;
	}
}