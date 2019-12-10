package com.temenos.microservice.payments.function;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.model.AttributeAction;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.AttributeValueUpdate;
import com.amazonaws.services.dynamodbv2.model.ResourceNotFoundException;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent.DynamodbStreamRecord;
import com.temenos.inboxoutbox.core.InboxStatus;
import com.temenos.inboxoutbox.data.InboxEvent;
import com.temenos.inboxoutbox.factory.InboxDaoFactory;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.data.DataAccessException;

public class InboxHandler implements RequestHandler<DynamodbEvent, Integer> {

	@Override
	public Integer handleRequest(DynamodbEvent event, Context context) {
		context.getLogger().log("Received event: " + event);

		for (DynamodbStreamRecord record : event.getRecords()) {
			// Filter only new record.
			if (!"INSERT".equals(record.getEventName()))
				continue;
			context.getLogger().log(record.getEventID());
			context.getLogger().log(record.getEventName());
			context.getLogger().log(record.getDynamodb().toString());
			context.getLogger().log(record.getDynamodb().getNewImage().get("eventId").getS());
			context.getLogger().log(record.getDynamodb().getNewImage().get("eventname").getS());
			context.getLogger().log(record.getDynamodb().getNewImage().get("eventdate").getS());

			InboxEvent inboxEvent = null;
			inboxEvent = (InboxEvent) InboxDaoFactory.getDao().getByIdAndName(
					record.getDynamodb().getNewImage().get("eventId").getS(),
					record.getDynamodb().getNewImage().get("eventname").getS());
			Class<?> commandClass;
			try {
				commandClass = Class.forName(Environment.getEnvironmentVariable("classname.command.processor", ""));
				Object o = commandClass.newInstance();
				Method m = commandClass.getMethod("processCommand", InboxEvent.class);
				m.invoke(o, inboxEvent);
			} catch (ClassNotFoundException | InstantiationException | IllegalAccessException | NoSuchMethodException
					| SecurityException | IllegalArgumentException | InvocationTargetException e) {
				e.printStackTrace();
			}

			// Update the status as "Delivered"
			// updateStatus(record.getDynamodb().getNewImage().get("eventId").getS(), record.getDynamodb().getNewImage().get("eventname").getS());
		}

		return event.getRecords().size();
	}

	private void updateStatus(String hash, String range) {
		final AmazonDynamoDB ddb = AmazonDynamoDBClientBuilder.defaultClient();

		HashMap<String, AttributeValue> item_key = new HashMap<String, AttributeValue>();
		item_key.put("eventId", new AttributeValue(hash));
		item_key.put("eventName", new AttributeValue(range));

		HashMap<String, AttributeValueUpdate> updated_values = new HashMap<String, AttributeValueUpdate>();
		updated_values.put("status",
				new AttributeValueUpdate(new AttributeValue(InboxStatus.PROCESSED.toString()), AttributeAction.PUT));

		try {
			ddb.updateItem("ms_inbox_events", item_key, updated_values);
		} catch (ResourceNotFoundException e) {
			System.err.println(e.getMessage());
			System.exit(1);
		} catch (AmazonServiceException e) {
			System.err.println(e.getMessage());
			System.exit(1);
		}
	}

}