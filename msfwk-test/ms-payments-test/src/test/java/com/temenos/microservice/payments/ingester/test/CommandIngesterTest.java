package com.temenos.microservice.payments.ingester.test;

import static com.temenos.microservice.framework.core.ingester.IngesterLogger.ingesterAlert;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.json.simple.parser.ParseException;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import com.temenos.des.streamprocessor.exception.StreamProducerException;
import com.temenos.des.streamvendorio.core.stream.produce.StreamProducer;
import com.temenos.microservice.payments.util.StreamUtils;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.conf.MSLogCode;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.util.IngesterUtil;


public class CommandIngesterTest extends ITTest {

	private static final int maxDBReadRetryCount = 8; // 2 minutes
	private static StreamProducer producer;

	@BeforeClass
	public static void setUp() throws Exception {
		daoFacade.openConnection();
		producer = StreamUtils.createStreamProducer("itest",
				Environment.getEnvironmentVariable("temn.msf.stream.vendor", ""));
	}

	@AfterClass
	public static void tearDown() {
		String inboxTableName = "";
		inboxTableName = "ms_inbox_events";

		deleteInboxRecord(inboxTableName, "eventId", "eq", "string", "5213a00f-1ab3-478e-a4d7-53b0f4326d00",
				"eventType", "eq", "string", "ms-paymentorder.CreateNewPaymentOrder");
		daoFacade.closeConnection();
		producer.close();
	}

	@Test
	public void testAingestEvent() throws IOException, InterruptedException {
		String content = new String(
				Files.readAllBytes(Paths.get("src/test/resources/binary/CommandEvent.json")));
		if (IngesterUtil.isCloudEvent()) {
			producer.batch().add("paymentorder-inbox-topic", "1", IngesterUtil.packageCloudEvent(content.getBytes()));
		} else {
			producer.batch().add("paymentorder-inbox-topic", "1", content.getBytes());
		}
		try {
			producer.batch().send();
		} catch (StreamProducerException e) {
			ingesterAlert.prepareError(MSLogCode.EVENT_PROCESSING_FAILED)
					.tag("functionName", e.getStackTrace()[0].getMethodName()).log();
		}

		// Read the item, retry if fails the first time
		Map<Integer, List<Attribute>> inboxResultMap = null;
		int retryCount = 0;
		do {
			System.out.println("Sleeping for 15 sec before reading data from database...");
			Thread.sleep(60000);
			System.out.println("Reading record back from db, try=" + (retryCount + 1));
			inboxResultMap = readInboxRecord("5213a00f-1ab3-478e-a4d7-53b0f4326d00", "ms-paymentorder.CreateNewPaymentOrder");
			retryCount = retryCount + 1;
		} while (inboxResultMap.get(1) == null && retryCount < maxDBReadRetryCount);

		Map<String, String> inboxAttributesMap = new HashMap<String, String>();
		for (Attribute attribute : inboxResultMap.get(1)) {
			if (attribute.getValue() != null) {
				inboxAttributesMap.put(attribute.getName().toLowerCase(), attribute.getValue().toString());
			}
		}

		/*
		 * Assertion for the Inbox record eventId & inbox record correlationId
		 */
		assertEquals(inboxAttributesMap.get("eventid"), "5213a00f-1ab3-478e-a4d7-53b0f4326d00");
	}
}
