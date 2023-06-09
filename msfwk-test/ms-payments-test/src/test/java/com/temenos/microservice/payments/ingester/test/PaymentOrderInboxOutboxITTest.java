package com.temenos.microservice.payments.ingester.test;

import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_INSERT;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.FixMethodOrder;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runners.MethodSorters;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ClientResponse;

import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.dao.Criterion;
import com.temenos.microservice.payments.api.test.ITTest;

import reactor.core.publisher.Mono;

@Ignore
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class PaymentOrderInboxOutboxITTest extends ITTest {
	static String requestedEventId = "";

	@Before
	public void setUp() throws SQLException {
		this.client = newWebClient();
	}

	@BeforeClass
	public static void initializeData() {
		daoFacade.openConnection();
	}

	@AfterClass
	public static void clearData() {
		daoFacade.closeConnection();
	}

	@Test
	public void testCreatePayment() {
		ClientResponse createResponse;

		do {
			createResponse = this.client.post()
					.uri("/v1.0.0/payments/orders" + ITTest.getCode("CREATE_PAYMENTORDER_AUTH_CODE"))
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_INSERT), String.class)).exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));

		Map<Integer, List<Attribute>> insertedRecord = readPaymentOrderRecord("ms_payment_order", "paymentOrderId",
				"eq", "string", "PO~123~124~USD~100", "debitAccount", "eq", "string", "123");
		List<Attribute> entry = insertedRecord.get(1);
		assertTrue(createResponse.statusCode().equals(HttpStatus.OK));
		assertNotNull(entry);
		assertEquals(entry.get(0).getName().toLowerCase(), "paymentorderid");
		assertEquals(entry.get(0).getValue().toString(), "PO~123~124~USD~100");
	}

	@Test
	public void testInboxCheck() {
		String tableName = "ms_inbox_events";
		String eventId = "";
		List<Criterion> criterions = new ArrayList<Criterion>();
		try {
			Map<Integer, List<Attribute>> insertedValues = daoFacade.readItems(tableName, criterions);
			if (insertedValues != null) {
				for (int i = 1; i < insertedValues.size(); i++) {
					List<Attribute> values = insertedValues.get(i);
					eventId = values.get(0).getValue().toString();
					Map<Integer, List<Attribute>> insertedRecord = readPaymentOrderRecord(tableName, "eventid", "eq",
							"string", eventId, "eventname", "eq", "string", "CreateNewPaymentOrder");
					if (insertedRecord.size() > 0) {
						List<Attribute> entry = insertedRecord.get(1);
						assertNotNull(entry);
						assertEquals(entry.get(0).getName().toLowerCase(), "eventid");
						requestedEventId = eventId;
					}
				}
			}
		} catch (Exception ex) {
		}
	}

	@Test
	public void testOutboxCheck() {
		String tableName = "ms_outbox_events";
		if (requestedEventId != null) {
			try {
				List<Criterion> criterions = new ArrayList<Criterion>();
				Map<Integer, List<Attribute>> insertedValues = daoFacade.readItems(tableName, criterions);
				assertEquals(insertedValues.size(), 0);
			} catch (Exception ex) {
			}
		}
	}
}
