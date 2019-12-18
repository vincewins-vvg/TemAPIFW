package com.temenos.microservice.payments.api.test;

import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_INSERT;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.sql.SQLException;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ClientResponse;

import junit.framework.Assert;
import reactor.core.publisher.Mono;
public class GetPaymentOrderITTest extends ITTest {

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
	public void testGetPaymentOrderFunction() {
		ClientResponse createResponse, getResponse;

		do {
			createResponse = this.client.post()
					.uri("/payments/orders" + ITTest.getCode("CREATE_PAYMENTORDER_AUTH_CODE"))
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_INSERT), String.class)).exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));

		do {
			getResponse = this.client.get()
					.uri("/payments/orders/" + "PO~123~124~USD~100" + ITTest.getCode("GET_PAYMENTODER_AUTH_CODE"))
					.exchange().block();
		} while (getResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(getResponse.statusCode().equals(HttpStatus.OK));
		assertTrue(getResponse.bodyToMono(String.class).block().contains(
				"\"paymentStatus\":{\"paymentId\":\"PO~123~124~USD~100\",\"status\":\"INITIATED\",\"details\":\"PayDetails\""));
	}
}