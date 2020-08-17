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

public class DeletePaymentOrderTest extends ITTest {

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
		if ("MONGODB".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
			deletePaymentOrderRecord("ms_reference_data", "type", "eq", "string", "paymentref", "value", "eq", "string",
					"PayRef");
		}
		daoFacade.closeConnection();
	}

	@Test
	public void testDeleteOrderFunction() {

		if ("MONGODB".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
			ClientResponse createResponse, deleteResponse;
			do {
				createResponse = this.client.post()
						.uri("/payments/orders" + ITTest.getCode("CREATE_PAYMENTORDER_AUTH_CODE"))
						.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_INSERT), String.class)).exchange()
						.block();
			} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));

			do {
				deleteResponse = this.client
						.delete().uri("/payments/orders/" + "PO~123~124~USD~100"
								+ ITTest.getCode("DELETE_PAYMENTODER_AUTH_CODE") + "&debitAccount=100")
						.exchange().block();
			} while (deleteResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
			System.out.println("deleteResponse.statusCode()::" + deleteResponse.statusCode());
			assertTrue(deleteResponse.statusCode().equals(HttpStatus.OK));
			System.out.println("Delete api response =====" + deleteResponse.bodyToMono(String.class).block());
		}

	}

}
