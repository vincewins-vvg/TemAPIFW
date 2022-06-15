/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.ingester;

import java.io.IOException;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.inboxoutbox.util.LoggingConstants;
import com.temenos.microservice.framework.core.log.Logger;
import com.temenos.microservice.framework.core.EventProcessor;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.sql.SqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.InvocationFailedException;
import com.temenos.microservice.framework.core.util.JsonUtil;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class EventHandlerImpl implements EventProcessor {

	private static SqlDbDao<PaymentOrder> SqlDao = null;

	@Override
	public void processEvent(Context context, GenericEvent event) throws FunctionException {
		String eventType = event.getEventType();
		if ("CommandProcessed".equals(eventType) || "CommandFailed".equals(eventType) || "PostHookEvent".equals(eventType)) {
			Logger.forDiagnostic().forComp(LoggingConstants.COMPONENT).prepareInfo(new StringBuilder("Received ")
					.append(eventType).append(" ").append(event.getPayload().toString()).toString()).log();
			return;
		}
		errorGenerationBasedOnInput(event, "process");
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
	@Override
	public void preHook(final Context ctx, GenericEvent event) throws FunctionException {
		errorGenerationBasedOnInput(event, "preHook");
	}
	@Override
	public void postHook(final Context ctx, GenericEvent event) throws FunctionException {
		errorGenerationBasedOnInput(event, "postHook");
	}
	private void errorGenerationBasedOnInput(GenericEvent event, String hookName) throws InvocationFailedException {
		try {
			String description = JsonUtil.readField(event.getPayload(), "descriptions");
			if (description==null || description.isEmpty())
				return;
			if (description.equals(hookName+"BusinessFailure"))
				throw new InvocationFailedException("Business Failure error generated");
			if (description.equals(hookName+"InfrastructureFailure"))
				throw new NullPointerException("Infrastructure Failure error generated");
		} catch(IOException e) {
			//suppress exception
			Logger.forDiagnostic().forComp(LoggingConstants.COMPONENT).prepareInfo("Cannot get value of description from input payload, for errorGenerationBasedOnInput()").log();
		} catch(InvocationFailedException e) {
			//suppress exception
			Logger.forDiagnostic().forComp(LoggingConstants.COMPONENT).prepareInfo("Triggering Business failure in "+hookName).log();
			throw e;
		} catch(Exception e) {
			//suppress exception
			Logger.forDiagnostic().forComp(LoggingConstants.COMPONENT).prepareInfo("Triggering Infrastructural failure in "+hookName).log();
			throw e;
		}
		
	}
}
