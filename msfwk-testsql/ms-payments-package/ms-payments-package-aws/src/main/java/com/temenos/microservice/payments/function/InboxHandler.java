package com.temenos.microservice.payments.function;

import static com.temenos.microservice.framework.core.ingester.IngesterLogger.ingesterAlert;
import static com.temenos.microservice.framework.core.ingester.IngesterLogger.ingesterDiagnostic;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.NoSuchElementException;

import org.json.JSONObject;
import org.json.JSONTokener;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.temenos.inbox.outbox.core.GenericCommand;
import com.temenos.inbox.outbox.data.InboxEvent;
import com.temenos.inbox.outbox.factory.InboxDaoFactory;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.MSLogCode;
import com.temenos.microservice.framework.core.function.GenericCommandProcessor;
import com.temenos.microservice.framework.core.util.JsonUtil;

public class InboxHandler implements RequestHandler<Object, String> {

	@Override
	public String handleRequest(Object event, Context context) {
		context.getLogger().log("Input: " + event);

		ingesterDiagnostic.prepareInfo("Get the event id from the payload which we are receiving").log();
		JSONObject jsonObject = new JSONObject(new JSONTokener(event.toString().replaceAll("=", ":")));

		GenericCommandProcessor gcp = new GenericCommandProcessor();
		try {
			InboxEvent inboxEvent = null;
			try {
				ingesterDiagnostic.prepareInfo("Get the InboxEvent corresponding to the eventId").log();
				inboxEvent = InboxDaoFactory.getDao().getByPrimaryKey(jsonObject.optString("eventId"));
			} catch (NoSuchElementException e) {
				ingesterAlert.prepareError(MSLogCode.EVENT_PROCESSING_FAILED)
						.tag("functionName", context.getFunctionName())
						.tag("exception", "no such element exception occurs").log();
				throw new RuntimeException(e);
			}

			gcp.processCommand(JsonUtil.readValue(inboxEvent.getPayload(), GenericCommand.class));
			ingesterDiagnostic.prepareInfo("Processed the inbox event").log();
		} catch (ClassNotFoundException | InstantiationException | IllegalAccessException | NoSuchMethodException
				| InvocationTargetException | IllegalArgumentException | IOException | FunctionException e) {
			e.printStackTrace();
			ingesterAlert.prepareError(MSLogCode.EVENT_PROCESSING_FAILED).tag("functionName", context.getFunctionName())
					.log();
			throw new RuntimeException(e);
		}
		return null;
	}
}