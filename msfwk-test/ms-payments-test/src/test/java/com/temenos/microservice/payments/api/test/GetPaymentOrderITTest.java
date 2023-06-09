package com.temenos.microservice.payments.api.test;

import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_INSERT;
import static org.junit.Assert.assertTrue;

import java.sql.SQLException;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ClientResponse;

import com.temenos.microservice.framework.core.conf.Environment;

import reactor.core.publisher.Mono;

public class GetPaymentOrderITTest extends ITTest {

	@Before
	public void setUp() throws SQLException {
		this.client = newWebClient();
	}

	@BeforeClass
	public static void initializeData() {
		daoFacade.openConnection();
		createReferenceDataRecord("ms_reference_data", "type", "string", "paymentref", "value", "string", "PayRef",
				"description", "string", "description");
	}

	@AfterClass
	public static void clearData() {
		if ("MYSQL".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))
				|| "NUODB".equals(Environment.getEnvironmentVariable("DB_VENDOR", "")) ||  "SQLSERVER".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))|| "ORACLE".equals(Environment.getEnvironmentVariable("DB_VENDOR", "")) || "POSTGRES".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
			clearRecords("PO~123~124~USD~100", "123");
		} else {
			deletePaymentOrderRecord("ms_payment_order", "paymentOrderId", "eq", "string", "PO~123~124~USD~100",
					"debitAccount", "eq", "string", "123");
			deletePaymentOrderRecord("ms_reference_data", "type", "eq", "string", "paymentref", "value", "eq", "string",
					"PayRef");
		}
		daoFacade.closeConnection();
	}

	@Test
	public void testGetPaymentOrderFunction() {
		ClientResponse createResponse, getResponse;
		do {
			createResponse = this.client.post()
					.uri("/v1.0.0/payments/orders" + ITTest.getCode("CREATE_PAYMENTORDER_AUTH_CODE"))
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_INSERT), String.class)).exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));

		do {
			getResponse = this.client.get()
					.uri("/v1.0.0/payments/orders/" + "PO~123~124~USD~100" + ITTest.getCode("GET_PAYMENTORDER_AUTH_CODE")).header("serviceid", "client").header("channelid", "web").header("customfilterid", "test")
					.exchange().block();
		} while (getResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(getResponse.statusCode().equals(HttpStatus.OK));
		assertTrue(getResponse.bodyToMono(String.class).block().contains(
				"\"extensionData\":{\"array_BusDayCentres\":[\"India\",\"Aus\"],\"paymentOrderProduct\":\"Temenos\",\"array_NonOspiType\":[{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"UPI\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"3163\"}]}"));
	}

	@Test
	public void testXcamlGetPaymentOrderFunction() {
		ClientResponse createResponse, getResponse;
		do {
			createResponse = this.client.post()
					.uri("/v1.0.0/payments/orders" + ITTest.getCode("CREATE_PAYMENTORDER_AUTH_CODE"))
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_INSERT), String.class)).exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));

		do {
			getResponse = this.client.get()
					.uri("/v1.0.0/payments/orders/" + "PO~123~124~USD~100" + ITTest.getCode("GET_PAYMENTORDER_AUTH_CODE")).header("serviceid", "client").header("channelid", "web")
					.exchange().block();
		} while (getResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(getResponse.statusCode().equals(HttpStatus.OK));
	}
}
