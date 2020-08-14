package com.temenos.microservice.payments.ingester.test;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import com.temenos.des.eventtransformer.data.parse.data.DynamicArrayBuilder;
import com.temenos.des.eventtransformer.data.parse.marker.RuntimeMarker;
import com.temenos.des.eventtransformer.data.parse.marker.TAFJMarker;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.streams.ITestProducer;
import com.temenos.microservice.payments.api.test.ITTest;

@Ignore
public class IngesterITTest extends ITTest{

	private static final RuntimeMarker MARKER = new TAFJMarker();
	private static ITestProducer producer;
	private static final String AVRO_MESSAGE = getIFDataEvent();
	
	@BeforeClass
	public static void initializeData() {
		daoFacade.openConnection();
	}

	@AfterClass
	public static void clearData() {
		daoFacade.closeConnection();
	}

	private static String getIFDataEvent() {
		return new DynamicArrayBuilder(MARKER).value("1544460586.405").fm(4).value("PAYMENT.ORDER")
				.fm().value("abc~123~zyz").fm().lfm(9)
				.value("12121").lfm(5).value("IngesterTest").lfm(3).value("52521").lfm(47)
				.value("USF").lfm(4).value("20190610").lfm(29).value("IN_PROGRESS").lfm(71).value("100.00").fm().build();
	}

	@Test
	public void ingestEvent() {
		System.setProperty("temn.msf.ingest.sink.stream", "table-update");
		producer = new ITestProducer("paymentorder-test", Environment
				.getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", 
						"localhost:8081"));
		producer.sendAsGenericEvent(AVRO_MESSAGE);
		try {
			Map<Integer, List<Attribute>> records = null;
			int maxDBReadRetryCount = 3;
			int retryCount = 0;
			do {
				System.out.println("Sleeping for 15 sec before reading data from database...");
				Thread.sleep(15000);
				System.out.println("Reading record back from db, try=" + (retryCount + 1));
				records = readPaymentOrderRecord("ms_payment_order", "paymentOrderId", "eq", "string",
						"abc~123~zyz", "debitAccount", "eq", "string", "12121");
				retryCount = retryCount + 1;
			} while (records == null && retryCount < maxDBReadRetryCount);
			assertTrue(!records.isEmpty());
			assertNotNull("Product record should not be null", records);
			assertNotNull("Key set should not be null", records.keySet().size());
			assertNotNull("Values should not be null", records.values().size());
			if ("MYSQL".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))
					|| "NUODB".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
				removeForeignChecksAndDelete();
			} else {
				deletePaymentOrderRecord("ms_payment_order", "paymentOrderId", "eq", "string", "abc~123~zyz",
						"debitAccount", "eq", "string", "12121");
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void removeForeignChecksAndDelete() throws SQLException, ClassNotFoundException {
		Connection con;
		if ("MYSQL".equalsIgnoreCase(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
			con = DriverManager.getConnection(
					new StringBuilder("jdbc:").append(Environment.getEnvironmentVariable("DB_VENDOR", "").toLowerCase())
							.append("://").append(Environment.getEnvironmentVariable("DB_HOST", "")).append(":")
							.append(Environment.getEnvironmentVariable("DB_PORT", "")).append("/")
							.append(Environment.getEnvironmentVariable("DB_NAME", "")).toString(),
					Environment.getEnvironmentVariable("DB_USERNAME", ""),
					Environment.getEnvironmentVariable("DB_PASSWORD", ""));
		} else {
			Class.forName("com.nuodb.jdbc.Driver");
			Properties prop = new Properties();
		    prop.put("user", Environment.getEnvironmentVariable("DB_USERNAME", ""));
		    prop.put("password", Environment.getEnvironmentVariable("DB_PASSWORD", ""));
		    prop.put("direct", "true");
			con = DriverManager.getConnection(
					new StringBuilder("jdbc:").append("com.nuodb")
							.append("://").append(Environment.getEnvironmentVariable("DB_HOST", "")).append(":")
							.append(Environment.getEnvironmentVariable("DB_PORT", "")).append("/")
							.append(Environment.getEnvironmentVariable("DB_NAME", ""))
							.append("?schema=ms_paymentorder").toString(), prop);
		}
		con.createStatement().execute("SET FOREIGN_KEY_CHECKS = 0");
		con.createStatement().execute("TRUNCATE table ms_payment_order");
		con.createStatement().execute("SET FOREIGN_KEY_CHECKS = 1");
		con.close();
	}

}
