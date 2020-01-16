package com.temenos.microservice.payments.ingester;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.EventProcessor;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.util.JsonUtil;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class EventHandlerImpl implements EventProcessor {

	private static NoSqlDbDao<PaymentOrder> noSqlDao = null;

	@Override
	public void processEvent(Context context, GenericEvent event) throws Exception {
		String eventType = event.getEventType();
		PaymentOrder paymentOrder = null;
		String paymentOrderId = "";

		noSqlDao = DaoFactory.getNoSQLDao(PaymentOrder.class);
		paymentOrderId = JsonUtil.readField(event.getPayload(), "paymentOrderId");
		paymentOrder = noSqlDao.getByPartitionKey(paymentOrderId).get();
		paymentOrder.setStatus("Completed");
		noSqlDao.saveEntity(paymentOrder);
	}
}
