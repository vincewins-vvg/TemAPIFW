package com.temenos.microservice.payments.ingester.test;

import static org.junit.Assert.assertNotNull;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.streams.AvroProducer;
import com.temenos.microservice.kafka.util.KafkaStreamProducer;
import com.temenos.microservice.payments.api.test.ITTest;

public class ConfigBasedMappingITTest extends ITTest {

	@BeforeClass
	public static void initializeData() {
		daoFacade.openConnection();
	}

	@AfterClass
	public static void clearData() {
		deletePaymentOrderRecord("ms_payment_order", "paymentOrderId", "eq", "string", "PI19107122J61FC8",
				"debitAccount", "eq", "string", "10995");
		deletePaymentOrderRecord("ms_payment_order", "paymentOrderId", "eq", "string", "PI19107122J61FC9",
				"debitAccount", "eq", "string", "10995");
		daoFacade.closeConnection();
	}

	@Test
	public void testBinaryIngesterConfigBasedMapping() {
		try {
			List<byte[]> messageList = new ArrayList<>();
			JSONObject object = new JSONObject();
			object.put("schemaName", "PAYMENT_ORDEREvent");
			object.put("payload", new JSONObject(readFromFile("src/test/resources/PaymentInputBinaryData.json")));
			messageList.add(object.toString().getBytes());
			KafkaStreamProducer.postMessageToTopic("table-update-binary", messageList);
			Map<Integer, List<Attribute>> records = null;
			int maxDBReadRetryCount = 3;
			int retryCount = 0;
			do {
				System.out.println("Sleeping for 15 sec before reading data from database...");
				Thread.sleep(15000);
				System.out.println("Reading record back from db, try=" + (retryCount + 1));
				records = readPaymentOrderRecord("ms_payment_order", "paymentOrderId", "eq", "string",
						"PI19107122J61FC8", "debitAccount", "eq", "string", "10995");
				retryCount = retryCount + 1;
			} while (records == null && retryCount < maxDBReadRetryCount);
			assertNotNull("Product record should not be null", records);
			assertNotNull("Key set should not be null", records.keySet().size());
			assertNotNull("Values should not be null", records.values().size());
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Test
	public void testAvroIngesterConfigBasedMapping() {
		try {
			System.setProperty("temn.msf.ingest.sink.stream", "table-update-paymentorder");
			AvroProducer producer = new AvroProducer("paymentorder-test",
					Environment.getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", "localhost:8081"));
			producer.sendGenericEvent(readFromFile("src/test/resources/PaymentOrderInputAvroData.json"),
					"PAYMENT_ORDEREvent");
			Map<Integer, List<Attribute>> records = null;
			int maxDBReadRetryCount = 3;
			int retryCount = 0;
			do {
				System.out.println("Sleeping for 15 sec before reading data from database...");
				Thread.sleep(15000);
				System.out.println("Reading record back from db, try=" + (retryCount + 1));
				records = readPaymentOrderRecord("ms_payment_order", "paymentOrderId", "eq", "string",
						"PI19107122J61FC9", "debitAccount", "eq", "string", "10995");
				retryCount = retryCount + 1;
			} while (records == null && retryCount < maxDBReadRetryCount);
			assertNotNull("Product record should not be null", records);
			assertNotNull("Key set should not be null", records.keySet().size());
			assertNotNull("Values should not be null", records.values().size());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
