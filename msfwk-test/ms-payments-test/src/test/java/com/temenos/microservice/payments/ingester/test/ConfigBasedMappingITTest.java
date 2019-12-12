package com.temenos.microservice.payments.ingester.test;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Ignore;
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
				System.out.println(records);
				retryCount = retryCount + 1;
			} while (records == null && retryCount < maxDBReadRetryCount);
			assertTrue(!records.isEmpty());
			assertNotNull("Product record should not be null", records);
			assertNotNull("Key set should not be null", records.keySet().size());
			assertNotNull("Values should not be null", records.values().size());
			Connection con = DriverManager.getConnection(
					new StringBuilder("jdbc:").append(Environment.getEnvironmentVariable("DB_VENDOR", "").toLowerCase())
							.append("://").append(Environment.getEnvironmentVariable("DB_HOST", "")).append(":")
							.append(Environment.getEnvironmentVariable("DB_PORT", "")).append("/")
							.append(Environment.getEnvironmentVariable("DB_NAME", "")).toString(),
					Environment.getEnvironmentVariable("DB_USERNAME", ""),
					Environment.getEnvironmentVariable("DB_PASSWORD", ""));
			con.createStatement().execute("SET FOREIGN_KEY_CHECKS = 0");
			con.createStatement().execute("TRUNCATE table Card");
			con.createStatement().execute("TRUNCATE table Card_extension");
			con.createStatement().execute("TRUNCATE table ExchangeRate");
			con.createStatement().execute("TRUNCATE table ExchangeRate_extension");
			con.createStatement().execute("TRUNCATE table MsAltKey");
			con.createStatement().execute("TRUNCATE table PayeeDetails");
			con.createStatement().execute("TRUNCATE table PaymentMethod_extension");
			con.createStatement().execute("TRUNCATE table PaymentMethod");
			con.createStatement().execute("TRUNCATE table ms_payment_order_ExchangeRate");
			con.createStatement().execute("TRUNCATE table ms_payment_order");
			con.createStatement().execute("SET FOREIGN_KEY_CHECKS = 1");
			con.close();
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
				System.out.println(records);
				retryCount = retryCount + 1;
			} while (records == null && retryCount < maxDBReadRetryCount);
			assertTrue(!records.isEmpty());
			assertNotNull("Product record should not be null", records);
			assertNotNull("Key set should not be null", records.keySet().size());
			assertNotNull("Values should not be null", records.values().size());
			Connection con = DriverManager.getConnection(
					new StringBuilder("jdbc:").append(Environment.getEnvironmentVariable("DB_VENDOR", "").toLowerCase())
							.append("://").append(Environment.getEnvironmentVariable("DB_HOST", "")).append(":")
							.append(Environment.getEnvironmentVariable("DB_PORT", "")).append("/")
							.append(Environment.getEnvironmentVariable("DB_NAME", "")).toString(),
					Environment.getEnvironmentVariable("DB_USERNAME", ""),
					Environment.getEnvironmentVariable("DB_PASSWORD", ""));
			con.createStatement().execute("SET FOREIGN_KEY_CHECKS = 0");
			con.createStatement().execute("TRUNCATE table Card");
			con.createStatement().execute("TRUNCATE table Card_extension");
			con.createStatement().execute("TRUNCATE table ExchangeRate");
			con.createStatement().execute("TRUNCATE table ExchangeRate_extension");
			con.createStatement().execute("TRUNCATE table MsAltKey");
			con.createStatement().execute("TRUNCATE table PayeeDetails");
			con.createStatement().execute("TRUNCATE table PaymentMethod");
			con.createStatement().execute("TRUNCATE table PaymentMethod_extension");
			con.createStatement().execute("TRUNCATE table PaymentOrder_extension");
			con.createStatement().execute("TRUNCATE table ms_payment_order_ExchangeRate");
			con.createStatement().execute("TRUNCATE table ms_payment_order");
			con.createStatement().execute("SET FOREIGN_KEY_CHECKS = 1");
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
