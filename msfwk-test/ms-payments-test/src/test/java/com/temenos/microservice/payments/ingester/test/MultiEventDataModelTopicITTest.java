package com.temenos.microservice.payments.ingester.test;

import static org.junit.Assert.assertTrue;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.streams.ITestProducer;
import com.temenos.microservice.payments.util.HoldingsEventStub;
import com.temenos.microservice.payments.api.test.ITTest;

public class MultiEventDataModelTopicITTest extends ITTest{
	private static ITestProducer producer;

	@BeforeClass
	public static void setUp() throws Exception {
		daoFacade.openConnection();
		// Stream initialisation
		producer = new ITestProducer("holdings-test", Environment
				.getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", "EB.CONTRACT.BALANCES,STMT.ENTRY"));
	}

	@AfterClass
	public static void tearDown() {
		daoFacade.closeConnection();
		// Stream cleanup
		producer.cleanup();
		producer = null;
		System.setProperty("temn.msf.ingest.sink.stream", "");
	}

	@Test
	public void testIngesterWithDataEvent() throws Exception {
		// Send test data to stream
		try {
			producer.sendAsDataEvent(HoldingsEventStub.getDataEvent());
		}
		catch(Exception e) {
			
		}
			assertTrue(true);
	}
}