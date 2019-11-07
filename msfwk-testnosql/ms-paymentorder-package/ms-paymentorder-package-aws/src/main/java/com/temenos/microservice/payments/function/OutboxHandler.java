package com.temenos.microservice.payments.function;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.model.AttributeAction;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.AttributeValueUpdate;
import com.amazonaws.services.dynamodbv2.model.ResourceNotFoundException;
import com.amazonaws.services.kinesis.AmazonKinesis;
import com.amazonaws.services.kinesis.AmazonKinesisClientBuilder;
import com.amazonaws.services.kinesis.model.PutRecordsRequest;
import com.amazonaws.services.kinesis.model.PutRecordsRequestEntry;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent.DynamodbStreamRecord;
import com.temenos.inbox.outbox.core.OutboxStatus;
import com.temenos.microservice.framework.core.conf.Environment;

public class OutboxHandler implements RequestHandler<DynamodbEvent, Integer> {

	private AmazonKinesis kinesisProducer;

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
			context.getLogger().log("Sample Payload");

			// Deliver the event to kinesis stream.
//			MSStreamProducer producer = getProducer();
//			producer.sendToStream(Environment.getEnvironmentVariable("temn.msf.stream.outbox.topic", ""),
//					record.getDynamodb().getNewImage().get("payload").getS());
			sendToKinesisStream(record.getDynamodb().getNewImage().get("payload").getS());

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
				new AttributeValueUpdate(new AttributeValue(OutboxStatus.DELIVERED.toString()), AttributeAction.PUT));

		try {
			ddb.updateItem("ms_outbox_events", item_key, updated_values);
		} catch (ResourceNotFoundException e) {
			System.err.println(e.getMessage());
			System.exit(1);
		} catch (AmazonServiceException e) {
			System.err.println(e.getMessage());
			System.exit(1);
		}
	}

	private void sendToKinesisStream(String event) {
		AmazonKinesisClientBuilder clientBuilder = AmazonKinesisClientBuilder.standard();
		kinesisProducer = clientBuilder.build();
		PutRecordsRequest putRecordsRequest = new PutRecordsRequest();
		List<PutRecordsRequestEntry> putRecordsRequestEntryList = new ArrayList<>();
		String streamName = Environment.getEnvironmentVariable("OUTBOX_STREAM", "outbox-stream");
		putRecordsRequest.setStreamName(streamName);
		PutRecordsRequestEntry putRecordsRequestEntry = new PutRecordsRequestEntry();
		putRecordsRequestEntry.setData(ByteBuffer.wrap(event.getBytes()));
		putRecordsRequestEntry.setPartitionKey(String.format("MessageId"));
		putRecordsRequestEntryList.add(putRecordsRequestEntry);
		putRecordsRequest.setRecords(putRecordsRequestEntryList);
		this.kinesisProducer.putRecords(putRecordsRequest);
	}

}