package com.temenos.microservice.payments.ingester.test;

import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_INSERT;
import static org.junit.Assert.*;

import java.sql.SQLException;
import java.util.*;
import org.junit.*;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ClientResponse;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.dao.Criterion;
import com.temenos.microservice.payments.api.test.ITTest;

import org.junit.runners.*;
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
					.uri("/payments/orders" + ITTest.getCode("CREATE_PAYMENTORDER_AUTH_CODE"))
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
		String eventId = "";
		if (requestedEventId != null) {
			try {
				List<Criterion> criterions = new ArrayList<Criterion>();
				Map<Integer, List<Attribute>> insertedValues = daoFacade.readItems(tableName, criterions);
				if (insertedValues != null) {
					for (int i = 1; i < insertedValues.size(); i++) {
						List<Attribute> values = insertedValues.get(i);
						eventId = values.get(0).getValue().toString();
						Map<Integer, List<Attribute>> insertedRecord = readPaymentOrderRecord(tableName, "eventid",
								"eq", "string", eventId, "eventname", "eq", "string",
								"PaymentOrder.PaymentOrderCreated");
						if (insertedRecord.size() > 0) {
							List<Attribute> entry = insertedRecord.get(1);
							String correlationId = entry.get(2).getValue().toString().trim();
							if (correlationId.equalsIgnoreCase(requestedEventId.trim())) {
								assertEquals(entry.get(0).getName().toLowerCase(), "eventid");
							}
						}

					}
				}
			} catch (Exception ex) {
			}
		}
	}
}
