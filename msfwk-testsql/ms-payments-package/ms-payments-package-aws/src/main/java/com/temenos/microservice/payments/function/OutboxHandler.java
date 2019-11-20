package com.temenos.microservice.payments.function;

import static com.temenos.microservice.framework.core.ingester.IngesterLogger.ingesterAlert;
import static com.temenos.microservice.framework.core.ingester.IngesterLogger.ingesterDiagnostic;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

import org.json.JSONObject;
import org.json.JSONTokener;

import com.amazonaws.services.kinesis.AmazonKinesis;
import com.amazonaws.services.kinesis.AmazonKinesisClientBuilder;
import com.amazonaws.services.kinesis.model.PutRecordsRequest;
import com.amazonaws.services.kinesis.model.PutRecordsRequestEntry;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.temenos.inbox.outbox.core.OutboxStatus;
import com.temenos.inbox.outbox.data.OutboxEvent;
import com.temenos.inbox.outbox.factory.OutboxDaoFactory;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.conf.MSLogCode;

public class OutboxHandler implements RequestHandler<Object, Integer> {

	private AmazonKinesis kinesisProducer;

	@Override
	public Integer handleRequest(Object event, Context context) {
		context.getLogger().log("Received event: " + event);

		ingesterDiagnostic.prepareInfo("Get the event id from the payload which we are receiving").log();
		JSONObject jsonObject = new JSONObject(new JSONTokener(event.toString().replaceAll("=", ":")));

		try {
			OutboxEvent outboxEvent = null;
			try {
				ingesterDiagnostic.prepareInfo("Get the OutboxEvent corresponding to the eventId").log();
				outboxEvent = OutboxDaoFactory.getDao().getById(jsonObject.optString("eventId"));
			} catch (NoSuchElementException e) {
				ingesterAlert.prepareError(MSLogCode.EVENT_PROCESSING_FAILED)
						.tag("functionName", context.getFunctionName())
						.tag("exception", "no such element exception occurs").log();
				throw new RuntimeException(e);
			}

			sendToKinesisStream(outboxEvent.getPayload());
			outboxEvent.setStatus(OutboxStatus.DELIVERED.toString());
			OutboxDaoFactory.getDao().save(outboxEvent);
			ingesterDiagnostic.prepareInfo("Sent the outbox event to the Kinesis stream").log();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
			ingesterAlert.prepareError(MSLogCode.EVENT_PROCESSING_FAILED).tag("functionName", context.getFunctionName())
					.log();
			throw new RuntimeException(e);
		}

		return null;
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