package com.temenos.microservice.payments.ingester.test;

import static com.temenos.microservice.payments.util.ITConstants.JWT_TOKEN_HEADER_NAME;
import static com.temenos.microservice.payments.util.ITConstants.JWT_TOKEN_HEADER_VALUE;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.FixMethodOrder;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runners.MethodSorters;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.client.ClientResponse;

import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.streams.AvroProducer;
import com.temenos.microservice.kafka.util.KafkaStreamProducer;
import com.temenos.microservice.payments.api.test.ITTest;

@Ignore
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ConfigBasedMappingITTest extends ITTest {

	@BeforeClass
	public static void initializeData() {
		daoFacade.openConnection();
		createReferenceDataRecord("ms_reference_data", "type", "string", "paymentref", "value", "string", "GB0010001",
				"description", "string", "description");
	}

	@Before
	public void setUp() throws SQLException {
		this.client = newWebClient();
	}

	@AfterClass
	public static void clearData() {
		deletePaymentOrderRecord("ms_reference_data", "type", "eq", "string", "paymentref", "value", "eq", "string",
				"GB0010001");
		daoFacade.closeConnection();
	}

	@Test
	public void testCBinaryIngesterConfigBasedMapping() {
		try {

			List<byte[]> messageList = new ArrayList<>();
			JSONObject object = new JSONObject();
			object.put("schemaName", "PAYMENT_ORDEREvent");
			List<Object> objectList = new ArrayList<>();
			InputStream inputBinary = ConfigBasedMappingITTest.class.getClassLoader()
					.getResourceAsStream("PaymentInputBinaryData.json");
			Assert.assertNotNull("binary data is not read", inputBinary);
			String binaryInputReader = convertInputStreamToString(inputBinary);
			System.out.println("input for binary data" + binaryInputReader);
			objectList.add(new JSONObject(binaryInputReader));
			object.put("payload", objectList);
			JSONArray array = new JSONArray();
			array.put(0, object);
			messageList.add(array.toString().getBytes());
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

			if ("MYSQL".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
				removeForeignChecksAndDelete();
			} else {
				deletePaymentOrderRecord("ms_payment_order", "paymentOrderId", "eq", "string", "PI19107122J61FC8",
						"debitAccount", "eq", "string", "10995");
			}
		} catch (Exception e) {
			Assert.fail(e.getMessage());
		}

	}

	private void removeForeignChecksAndDelete() throws SQLException {
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
		con.createStatement().execute("TRUNCATE table PaymentOrder_extension");
		con.createStatement().execute("TRUNCATE table ms_payment_order_ExchangeRate");
		con.createStatement().execute("TRUNCATE table ms_payment_order");
		con.createStatement().execute("SET FOREIGN_KEY_CHECKS = 1");
		con.close();
	}

	@Test
	public void testAvroIngesterConfigBasedMapping() {
		try {
			System.setProperty("temn.msf.ingest.sink.stream", "table-update-paymentorder");
			AvroProducer producer = new AvroProducer("paymentorder-test",
					Environment.getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", "localhost:8081"));
			InputStream inputAvro = ConfigBasedMappingITTest.class.getClassLoader()
					.getResourceAsStream("PaymentOrderInputAvroData.json");
			Assert.assertNotNull("avro data is read", inputAvro);
			String inputAvroReader = convertInputStreamToString(inputAvro);
			System.out.println("input for avro data" + inputAvroReader);
			producer.sendGenericEvent(inputAvroReader, "PAYMENT_ORDEREvent");
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
			} while ((records == null || records.isEmpty()) && retryCount < maxDBReadRetryCount);
			assertTrue(!records.isEmpty());
			assertNotNull("Product record should not be null", records);
			assertNotNull("Key set should not be null", records.keySet().size());
			assertNotNull("Values should not be null", records.values().size());
			if ("MYSQL".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
				validateSQLExtensionData();
				validateAltKeyData("MsAltKey");
			} else {
				validateNoSQLExtensionData(records.get(1));
				validateAltKeyData("ms_altkey");
			}
		} catch (Exception e) {
			Assert.fail(e.getMessage());
		}
	}

	private String convertInputStreamToString(InputStream inputStream) throws IOException {

		ByteArrayOutputStream result = new ByteArrayOutputStream();
		byte[] buffer = new byte[1024];
		int length;
		while ((length = inputStream.read(buffer)) != -1) {
			result.write(buffer, 0, length);
		}

		return result.toString(StandardCharsets.UTF_8.name());

	}

	public void validateSQLExtensionData() {
		Map<Integer, List<Attribute>> extensionRecords = readPaymentOrderRecord("Card_extension", "Card_cardid", "eq",
				"string", "124", "name", "eq", "string", "eventId");
		Map<Integer, List<Attribute>> extensionArrayRecords = readPaymentOrderRecord("PaymentMethod_extension",
				"PaymentMethod_id", "eq", "string", "157", "name", "eq", "string", "numbers");
		Map<Integer, List<Attribute>> extensionMultiArrayRecords = readPaymentOrderRecord("PaymentOrder_extension",
				"PaymentOrder_paymentOrderId", "eq", "string", "PI19107122J61FC9", "name", "eq", "string", "test");
		assertTrue(!extensionRecords.isEmpty());
		assertNotNull("Product record should not be null", extensionRecords);
		assertNotNull("Key set should not be null", extensionRecords.keySet().size());
		assertNotNull("Values should not be null", extensionRecords.values().size());
		assertTrue(!extensionArrayRecords.isEmpty());
		assertNotNull("Product record should not be null", extensionArrayRecords);
		assertNotNull("Key set should not be null", extensionArrayRecords.keySet().size());
		assertNotNull("Values should not be null", extensionArrayRecords.values().size());
		assertTrue(!extensionMultiArrayRecords.isEmpty());
		assertNotNull("Product record should not be null", extensionMultiArrayRecords);
		assertNotNull("Key set should not be null", extensionMultiArrayRecords.keySet().size());
		assertNotNull("Values should not be null", extensionMultiArrayRecords.values().size());
	}

	public void validateNoSQLExtensionData(List<Attribute> listEntry) {
		String extensionName = "", extensionValue = "";
		for (Attribute attribute : listEntry) {
			if (attribute.getName().equalsIgnoreCase("extensionData")) {
				extensionName = attribute.getName().toLowerCase();
				extensionValue = attribute.getValue().toString();
				break;
			}
		}
		assertTrue(!extensionValue.isEmpty());
		assertNotNull("Product record should not be null", extensionValue);
	}

	public void validateAltKeyData(String tableName) {
		Map<Integer, List<Attribute>> altKeyRecords = readPaymentOrderRecord(tableName, "alternateName", "eq", "string",
				"OrderingPostAddrline", "alternateKey", "eq", "string", "1 COCA-COLA PLAZA");
		assertNotNull("AltKey table record should not be null", altKeyRecords);
		assertTrue(!altKeyRecords.isEmpty());
	}

	@Test
	public void testBGetPaymentOrderWithAltKey() {
		ClientResponse getResponse;

		try {
			do {
				getResponse = this.client.get()
						.uri("/payments/orders/" + "1 COCA-COLA PLAZA" + ITTest.getCode("GET_PAYMENTODER_AUTH_CODE")
								+ "&alternatekeys=paymentId&alternatenames=OrderingPostAddrline")
						.header(JWT_TOKEN_HEADER_NAME, JWT_TOKEN_HEADER_VALUE).exchange().block();
			} while (getResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
			assertTrue(getResponse.statusCode().equals(HttpStatus.OK));
			String apiResponse = getResponse.bodyToMono(String.class).block();
			System.out.println("body response from ConfigBasedMappingITTest.java::" + apiResponse);
			assertTrue(apiResponse.contains(
					"\"fromAccount\":\"10995\",\"toAccount\":\"898789\",\"paymentReference\":\"GB0010001\",\"paymentDetails\":\"Funds transfer\",\"currency\":\"USD\""));
			if ("MYSQL".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
				removeForeignChecksAndDelete();
			} else {
				deletePaymentOrderRecord("ms_payment_order", "paymentOrderId", "eq", "string", "PI19107122J61FC9",
						"debitAccount", "eq", "string", "10995");
				deletePaymentOrderRecord("ms_altkey", "alternateName", "eq", "string", "OrderingPostAddrline",
						"alternateKey", "eq", "string", "1 COCA-COLA PLAZA");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
