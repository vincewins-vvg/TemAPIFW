package com.temenos.microservice.paymentorder.ingester;

import java.util.Map;

import org.json.JSONObject;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.ingester.BaseIngester;
import com.temenos.microservice.paymentorder.entity.PaymentOrder;

public class PaymentorderIngesterUpdater extends BaseIngester {
	private JSONObject sourceRecord;
	private PaymentOrder order;

	public PaymentorderIngesterUpdater() {
	}

	@Override
	public void update() throws FunctionException {
		saveOrUpdate();
	}

	/**
	 * Insert/update the Payment order Event.
	 * 
	 * @throws DataAccessException
	 */
	private void saveOrUpdate() throws DataAccessException {
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		paymentOrderDao.saveEntity(order);
	}

	@Override
	public void transform(JSONObject jsonObject) throws FunctionException {
		// TODO Auto-generated method stub
		PaymentOrderRecord orderRecord = new PaymentOrderRecord(jsonObject);
		order = new PaymentOrder();
		order.setAmount(orderRecord.getAmount());
		order.setCreditAccount(orderRecord.getCreditAccount());
		order.setCurrency(orderRecord.getCurrency());
		order.setDebitAccount(orderRecord.getDebitAccount());
		order.setPaymentDate(orderRecord.getPaymentDate());
		order.setPaymentDetails(orderRecord.getPaymentDetails());
		order.setPaymentOrderId(orderRecord.getPaymentOrderId());
		order.setPaymentReference(orderRecord.getPaymentReference());
		order.setStatus(orderRecord.getStatus());
		com.temenos.microservice.paymentorder.entity.PaymentMethod paymentMethod = new com.temenos.microservice.paymentorder.entity.PaymentMethod();
		paymentMethod.setId(new java.util.Random().nextLong());
		paymentMethod.setName("CARD");
		com.temenos.microservice.paymentorder.entity.Card card = new com.temenos.microservice.paymentorder.entity.Card();
		card.setCardid(new java.util.Random().nextLong());
		card.setCardlimit(new java.math.BigDecimal("44"));
		card.setCardname("test");
		card.setExtensionData(new java.util.HashMap<String,String>());
		paymentMethod.setCard(card);
		order.setPaymentMethod(paymentMethod);
		java.util.List<com.temenos.microservice.paymentorder.entity.ExchangeRate> exchangeList = new java.util.ArrayList<com.temenos.microservice.paymentorder.entity.ExchangeRate>();
		order.setExchangeRates(exchangeList);
	}

	@Override
	public Map<String, Entity> setEntityMap() {
		Map<String, Entity> instanceMap = new java.util.HashMap<String, Entity>();
		instanceMap.put("com.temenos.microservice.paymentorder.entity.PaymentOrder", order);
		return instanceMap;
	}
}