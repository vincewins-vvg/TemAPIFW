package com.temenos.microservice.payments.ingester;

import java.io.IOException;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.EventProcessor;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.util.JsonUtil;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class EventHandlerImpl implements EventProcessor {

	private static NoSqlDbDao<PaymentOrder> noSqlDao = null;

	@Override
	public void processEvent(Context context, GenericEvent event) throws FunctionException {
		String eventType = event.getEventType();
		PaymentOrder paymentOrder = null;
		String paymentOrderId = "";

		noSqlDao = DaoFactory.getNoSQLDao(PaymentOrder.class);
		try {
			paymentOrderId = JsonUtil.readField(event.getPayload(), "paymentOrderId");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		paymentOrder = noSqlDao.getByPartitionKey(paymentOrderId).get();
		paymentOrder.setStatus("Completed");
		noSqlDao.saveEntity(paymentOrder);
	}
}
