package com.temenos.microservice.payments.api.test;

import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_INSERT;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_UPDATE;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ClientResponse;

import com.temenos.microservice.framework.test.dao.Attribute;

import reactor.core.publisher.Mono;

public class UpdatePaymentOrderITTest extends ITTest {

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
		deletePaymentOrderRecord("ms_payment_order", "paymentOrderId", "eq", "string", "PO~123~124~USD~100",
				"debitAccount", "eq", "string", "123");
		daoFacade.closeConnection();
	}

	@Test
	public void testUpdatePaymentOrderFunction() {
		ClientResponse createResponse, updateResponse;
		String paymentOrderId = null;
		String paymentOrderValue = null;
		do {
			createResponse = this.client.post()
					.uri("/payments/orders" + ITTest.getCode("CREATE_PAYMENTORDER_AUTH_CODE"))
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_INSERT), String.class)).exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));

		do {
			updateResponse = this.client.put()
					.uri("/payments/orders/" + "PO~123~124~USD~100" + ITTest.getCode("UPDATE_PAYMENTORDER_AUTH_CODE"))
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_UPDATE), String.class)).exchange().block();
		} while (updateResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));

		Map<Integer, List<Attribute>> insertedRecord = readPaymentOrderRecord("ms_payment_order", "paymentOrderId",
				"eq", "string", "PO~123~124~USD~100", "debitAccount", "eq", "string", "123");
		List<Attribute> entry = insertedRecord.get(1);
		assertNotNull(entry);
		for(Attribute attribute : entry) {
			if(attribute.getName().equalsIgnoreCase("paymentOrderId")) {
				paymentOrderId = attribute.getName().toLowerCase();
				paymentOrderValue = attribute.getValue().toString();
				break;
			}
		}
		assertEquals(paymentOrderId, "paymentorderid");
		assertEquals(paymentOrderValue, "PO~123~124~USD~100");
	}
}