package com.temenos.microservice.payments.api.test;

import static com.temenos.microservice.framework.test.dao.TestDbUtil.populateCriterian;
import static org.junit.Assert.assertTrue;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Ignore;

import com.temenos.connect.config.Environment;
import com.temenos.inboxoutbox.cache.InboxOutboxIgniteCacheImpl;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.dao.Criterion;
import com.temenos.microservice.framework.test.dao.Item;

@Ignore
public class SchedulerProcessorITTest extends ITTest {

	static InboxOutboxIgniteCacheImpl inboxOutboxIgniteCacheImpl = null;

	public void setUp() throws SQLException {
		this.client = newWebClient();
	}

	public static void initializeData() throws InterruptedException {
		System.getProperties().setProperty("tmn.ignite.host", "127.0.0.1");
		System.getProperties().setProperty("tmn.ignite.port", "10800");

		daoFacade.openConnection();
		inboxOutboxIgniteCacheImpl = new InboxOutboxIgniteCacheImpl("paymentorder-inbox");
		String insertQuery = "";
		if (Environment.getEnvironmentVariable("DB_VENDOR", "").equalsIgnoreCase("mysql")) {
			insertQuery = "INSERT INTO ms_inbox_events(eventid,eventtype,creationtime,eventdetails,payload,processedtime,status) VALUES ('1a316d88-3c7-4-ad7e-773961ac21','PaymentOrder.CreateNewPaymentOrder',now(),  '{}',   '{\"eventId\":\"1a316d88-3c7-4-ad7e-773961ac21\",\"dateTime\":\"2019-10-21T00:49:35.000+0000\",\"organizationId\":null,\"correlationId\":null,\"tenantId\":null,\"userId\":null,\"priority\":0,\"status\":\"new\",\"eventSourceId\":null,\"businessObjects\":null,\"eventType\":\"PaymentOrder.CreateNewPaymentOrder\",\"operationInstanceId\":null,\"payload\":{\"body\":{\"fromAccount\":\"1733\",\"toAccount\":\"3621\",\"paymentReference\":\"hello\",\"paymentDetails\":\"test\",\"currency\":\"USD\",\"amount\":901,\"expires\":0}},\"sequenceInstanceId\":null}',now(),'NEW')";
		} else {
			insertQuery = "INSERT INTO ms_paymentorder.ms_inbox_events(eventid,eventtype,creationtime,eventdetails,payload,processedtime,status) VALUES ('1a316d88-3c7-4-ad7e-773961ac21','PaymentOrder.CreateNewPaymentOrder',dateof(now()),  '{}',   '{\"eventId\":\"1a316d88-3c7-4-ad7e-773961ac21\",\"dateTime\":\"2019-10-21T00:49:35.000+0000\",\"organizationId\":null,\"correlationId\":null,\"tenantId\":null,\"userId\":null,\"priority\":0,\"status\":\"new\",\"eventSourceId\":null,\"businessObjects\":null,\"eventType\":\"PaymentOrder.CreateNewPaymentOrder\",\"operationInstanceId\":null,\"payload\":{\"body\":{\"fromAccount\":\"1733\",\"toAccount\":\"3621\",\"paymentReference\":\"hello\",\"paymentDetails\":\"test\",\"currency\":\"USD\",\"amount\":901,\"expires\":0}},\"sequenceInstanceId\":null}',  dateof(now()),'NEW')";
		}
		daoFacade.insertRecord(insertQuery);
	}

	public static void clearData() {
		List<Criterion> criterions = new ArrayList<Criterion>();
		criterions.add(populateCriterian("eventid", "eq", "string", "1a316d88-3c7-4-ad7e-773961ac21"));
		daoFacade.deleteItems("ms_inbox_events", criterions);
		daoFacade.closeConnection();
	}

	public void testCachupProcessor() throws InterruptedException {
		Item item = new Item();
		item.setTableName("ms_inbox_events");
		String status = "NEW";
		String eventId = "";

		List<Criterion> criterions = new ArrayList<Criterion>();
		criterions.add(populateCriterian("status", "eq", "string", status));
		Map<Integer, List<Attribute>> result = daoFacade.readItems("ms_inbox_events", criterions);
		if (result != null) {
			Map<String, String> inboxAttributesMap = new HashMap<String, String>();
			for (Attribute attribute : result.get(1)) {
				if (attribute.getName().equalsIgnoreCase("eventid")) {
					eventId = attribute.getValue().toString();
				}
			}
			Thread.sleep(120000);
			assertTrue(eventId != null);
			if (!inboxOutboxIgniteCacheImpl.getAllItems().isEmpty()) {
				assertTrue(inboxOutboxIgniteCacheImpl.getAllItems().toString().contains(eventId));
			}
		}
	}
}
