package com.temenos.microservice.payments.ingester;

import java.io.IOException;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.inboxoutbox.util.LoggingConstants;
import com.temenos.logger.Logger;
import com.temenos.microservice.framework.core.EventProcessor;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.sql.SqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.util.JsonUtil;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class EventHandlerImpl implements EventProcessor {

	private static SqlDbDao<PaymentOrder> SqlDao = null;

	@Override
	public void processEvent(Context context, GenericEvent event) throws FunctionException {
		String eventType = event.getEventType();
		if ("CommandProcessed".equals(eventType) || "CommandFailed".equals(eventType)) {
			Logger.forDiagnostic().forComp(LoggingConstants.COMPONENT).prepareInfo(new StringBuilder("Received ")
					.append(eventType).append(" ").append(event.getPayload().toString()).toString()).log();
			return;
		}
		PaymentOrder paymentOrder = null;
		String paymentOrderId = "";

		SqlDao = DaoFactory.getSQLDao(PaymentOrder.class);
		try {
			paymentOrderId = JsonUtil.readField(event.getPayload(), "paymentOrderId");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		paymentOrder = SqlDao.findById(paymentOrderId, PaymentOrder.class);
		paymentOrder.setStatus("Completed");
		SqlDao.saveEntity(paymentOrder);
	}
}
