package com.temenos.microservice.payments.api.test;

import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_INSERT;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_UPDATE;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ClientResponse;

import com.temenos.microservice.framework.test.dao.Attribute;

import reactor.core.publisher.Mono;

public class IrisMSITTest extends ITTest {

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
	public void testCreateNewPaymentOrderFunction() {
		ClientResponse createResponse;

		do {
			createResponse = this.client.post()
					.uri("v1.0.0/party/account/accountClosure" + ITTest.getCode("CREATE_PAYMENTORDER_AUTH_CODE"))
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_INSERT), String.class)).exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		System.out.println("Status code for api hit:" + createResponse.statusCode().value());
		assertTrue(createResponse.statusCode().equals(HttpStatus.OK));

		Map<Integer, List<Attribute>> insertedRecord = readPaymentOrderRecord("ms_payment_order", "paymentOrderId",
				"eq", "string", "PO~123~124~USD~100", "debitAccount", "eq", "string", "123");
		List<Attribute> entry = insertedRecord.get(1);
		System.out.println("Entry::" + entry);
		assertNotNull(entry);
		assertEquals(entry.get(0).getName().toLowerCase(), "paymentorderid");
		assertEquals(entry.get(0).getValue().toString(), "PO~123~124~USD~100");

		ClientResponse updateResponse;
		do {
			updateResponse = this.client.put()
					.uri("v1.0.0/party/account/accountClosure?" + "paymentId=PO~123~124~USD~100")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_UPDATE), String.class)).exchange().block();
		} while (updateResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		System.out.println("update response::" + updateResponse.statusCode());
		Map<Integer, List<Attribute>> updatedRecords = readPaymentOrderRecord("ms_payment_order", "paymentOrderId",
				"eq", "string", "PO~123~124~USD~100", "debitAccount", "eq", "string", "123");
		List<Attribute> updatedEntry = updatedRecords.get(1);
		assertNotNull(updatedEntry);
		assertEquals(updatedEntry.get(0).getName().toLowerCase(), "paymentorderid");
		assertEquals(updatedEntry.get(0).getValue().toString(), "PO~123~124~USD~100");

		ClientResponse getResponse;
		do {
			getResponse = this.client.get().uri("v1.0.0/party/account/accountClosure?" + "paymentId=PO~123~124~USD~100")
					.exchange().block();
		} while (getResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		System.out.println("getResponse tatus code::" + getResponse.statusCode());
		assertTrue(getResponse.statusCode().equals(HttpStatus.OK));
		String bodyResponse = getResponse.bodyToMono(String.class).block();
		JSONObject jsonObject = new JSONObject(bodyResponse);
		String toAccount = jsonObject.getJSONObject("paymentOrder").getString("toAccount");
		assertTrue("124".equals(toAccount));

	}
}
