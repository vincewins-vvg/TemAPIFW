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
	}

	@Override
	public void transform(JSONObject jsonObject) throws FunctionException {

		checkAndBuild(jsonObject);
	}
	
	public Map<String, Entity> setEntityMap() {
		// TODO Auto-generated method stub
		return null;
	}
	public Map<String, Object> setInstanceMap() {
		Map<String, Object> instanceMap = new java.util.HashMap<String, Object>();
		instanceMap.put("CreateNewPaymentOrder", order);
		return instanceMap;
	}
}
