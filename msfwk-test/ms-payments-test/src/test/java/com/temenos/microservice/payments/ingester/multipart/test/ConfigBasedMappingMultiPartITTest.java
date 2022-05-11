package com.temenos.microservice.payments.ingester.multipart.test;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.FixMethodOrder;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runners.MethodSorters;

import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.streams.AvroProducer;
import com.temenos.microservice.payments.api.test.ITTest;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import com.temenos.microservice.framework.test.dao.Attribute;


@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ConfigBasedMappingMultiPartITTest extends ITTest{
	static String sinkStreamValue;
	
	@BeforeClass
	public static void initializeData() {
		ConfigBasedMappingMultiPartITTest.sinkStreamValue = System.getProperty("temn.msf.ingest.sink.stream");
		daoFacade.openConnection();
	}
	
	@AfterClass
	public static void afterTest() {
		System.setProperty("temn.msf.ingest.sink.stream", ConfigBasedMappingMultiPartITTest.sinkStreamValue);
	}
	

	@Test
	public void testAvroIngesterConfigBasedMapping() {
		try {
			System.setProperty("temn.msf.ingest.sink.stream", Environment.getEnvironmentVariable("temn.msf.ingest.sink.stream.multipart", "multipart-topic"));
			AvroProducer producer = new AvroProducer("paymentorder-test",
					Environment.getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", "localhost:8081"));
			//		"http://schema-registry:8081");
			InputStream inputAvro = ConfigBasedMappingMultiPartITTest.class.getClassLoader()
					.getResourceAsStream("PaymentOrderInputAvroDataMultiPart.json");
			Assert.assertNotNull("avro data is read", inputAvro);
			String inputAvroReader = convertInputStreamToString(inputAvro);
			//System.out.println("input for avro data" + inputAvroReader);
			producer.sendGenericEvent(inputAvroReader, "PAYMENT_ORDEREvent");
			
			 Map<Integer, List<Attribute>> records = null;
			 
				int maxDBReadRetryCount = 5;
				int retryCount = 0;
				do {
					System.out.println("Sleeping for 15 sec before reading data from database...");
					Thread.sleep(15000);
					System.out.println("Reading record back from db, try=" + (retryCount + 1));
					records = readPaymentOrderRecord("ms_error", "errorSourceTopic", "eq", "string", "multipart-topic",
							 "dataEventId", "eq", "string", "U000021_37b9cacf-5c85-4862-9894-91a61b7d5177005uB_0001");

					System.out.println(records);
					retryCount = retryCount + 1;
				} while ((records == null || records.isEmpty()) && retryCount < maxDBReadRetryCount);
				assertTrue(!records.isEmpty());
				assertNotNull("ms_error table record should not be null", records);
				assertNotNull("ms_error table Key set should not be null", records.keySet().size());
				assertNotNull("ms_error table Values should not be null", records.values().size());
			 
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
}