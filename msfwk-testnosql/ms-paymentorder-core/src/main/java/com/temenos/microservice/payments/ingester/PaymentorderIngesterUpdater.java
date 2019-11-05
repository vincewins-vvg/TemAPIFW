package com.temenos.microservice.payments.ingester;

import org.json.JSONObject;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.ingester.IngesterUpdater;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class PaymentorderIngesterUpdater implements IngesterUpdater {
	private JSONObject sourceRecord;
	private PaymentOrder order;

	public PaymentorderIngesterUpdater(JSONObject jsonObject) {
		this.sourceRecord = jsonObject;
	}

	@Override
	public void update() throws FunctionException {
		transform();
		saveOrUpdate();
	}

/**
	 * Insert/update the Payment order Event.
	 * 
	 * @throws DataAccessException
	 */
	private void saveOrUpdate() throws DataAccessException {
		NoSqlDbDao<com.temenos.microservice.payments.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.payments.entity.PaymentOrder.class);
		paymentOrderDao.saveEntity(order);
	}
	
	/**
	 * Transform the JSON event to Payment order Entity.
	 */
	private void transform() {
		PaymentOrderRecord orderRecord = new PaymentOrderRecord(sourceRecord);
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
	}
}
