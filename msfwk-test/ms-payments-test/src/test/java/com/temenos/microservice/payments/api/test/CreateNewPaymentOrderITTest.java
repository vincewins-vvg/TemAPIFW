package com.temenos.microservice.payments.api.test;

import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_INSERT;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_INSERT_WRONG;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ClientResponse;

import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.dao.Attribute;

import reactor.core.publisher.Mono;

public class CreateNewPaymentOrderITTest extends ITTest {

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
		if ("MYSQL".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
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
	public void testCreateNewPaymentOrderFunction() {
		ClientResponse createResponse;
		String paymentOrderId = null;
		String paymentOrderValue = null;
		do {
			createResponse = this.client.post()
					.uri("/payments/orders" + ITTest.getCode("CREATE_PAYMENTORDER_AUTH_CODE"))
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_INSERT), String.class)).exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));

		assertTrue(createResponse.statusCode().equals(HttpStatus.OK));

		Map<Integer, List<Attribute>> insertedRecord = readPaymentOrderRecord("ms_payment_order", "paymentOrderId",
				"eq", "string", "PO~123~124~USD~100", "debitAccount", "eq", "string", "123");
		List<Attribute> entry = insertedRecord.get(1);
		assertNotNull(entry);
		for (Attribute attribute : entry) {
			if (attribute.getName().equalsIgnoreCase("paymentOrderId")) {
				paymentOrderId = attribute.getName().toLowerCase();
				paymentOrderValue = attribute.getValue().toString();
				break;
			}
		}
		assertEquals(paymentOrderId, "paymentorderid");
		assertEquals(paymentOrderValue, "PO~123~124~USD~100");
		if ("MYSQL".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
			validateSQLExtensionData();
		} else {
			validateNoSQLExtensionData(entry);
		}

	}

	@Test
	public void testBCreateNewPaymentOrderFunction() {
		ClientResponse createResponse;

		do {
			createResponse = this.client.post()
					.uri("/payments/orders" + ITTest.getCode("CREATE_PAYMENTORDER_AUTH_CODE"))
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_INSERT_WRONG), String.class)).exchange()
					.block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));

		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block()
				.contains("[{\"message\":\"To Account is mandatory\",\"code\":\"PAYM-PORD-A-2104\"}]"));
	}

	public void validateSQLExtensionData() {
		Map<Integer, List<Attribute>> insertedArrayExtensionRecord = readPaymentOrderRecord("PaymentOrder_extension",
				"PaymentOrder_paymentOrderId", "eq", "string", "PO~123~124~USD~100", "name", "eq", "string",
				"array_BusDayCentres");
		Map<Integer, List<Attribute>> insertedExtensionRecord = readPaymentOrderRecord("PaymentOrder_extension",
				"PaymentOrder_paymentOrderId", "eq", "string", "PO~123~124~USD~100", "name", "eq", "string",
				"paymentOrderProduct");
		Map<Integer, List<Attribute>> insertedAssoMultiValueArrayExtensionRecord = readPaymentOrderRecord(
				"PaymentOrder_extension", "PaymentOrder_paymentOrderId", "eq", "string", "PO~123~124~USD~100", "name",
				"eq", "string", "array_NonOspiType");
		List<Attribute> extensioneEntry = insertedExtensionRecord.get(1);
		List<Attribute> arrayExtensionEntry = insertedArrayExtensionRecord.get(1);
		List<Attribute> multivalueArrayExtensionEntry = insertedAssoMultiValueArrayExtensionRecord.get(1);
		assertNotNull(extensioneEntry);
		assertNotNull(arrayExtensionEntry);
		assertNotNull(multivalueArrayExtensionEntry);
		assertEquals(arrayExtensionEntry.get(0).getName(), "PaymentOrder_paymentOrderId");
		assertEquals(arrayExtensionEntry.get(0).getValue(), "PO~123~124~USD~100");
		assertEquals(arrayExtensionEntry.get(1).getName(), "value");
		assertEquals(arrayExtensionEntry.get(1).getValue(), "[\"India\",\"Aus\"]");
		assertEquals(arrayExtensionEntry.get(2).getName(), "name");
		assertEquals(arrayExtensionEntry.get(2).getValue(), "array_BusDayCentres");
		assertEquals(extensioneEntry.get(0).getName(), "PaymentOrder_paymentOrderId");
		assertEquals(extensioneEntry.get(0).getValue(), "PO~123~124~USD~100");
		assertEquals(extensioneEntry.get(1).getName(), "value");
		assertEquals(extensioneEntry.get(1).getValue(), "Temenos");
		assertEquals(extensioneEntry.get(2).getName(), "name");
		assertEquals(extensioneEntry.get(2).getValue(), "paymentOrderProduct");
		assertEquals(multivalueArrayExtensionEntry.get(0).getName(), "PaymentOrder_paymentOrderId");
		assertEquals(multivalueArrayExtensionEntry.get(0).getValue(), "PO~123~124~USD~100");
		assertEquals(multivalueArrayExtensionEntry.get(1).getName(), "value");
		assertEquals(multivalueArrayExtensionEntry.get(1).getValue(),
				"[{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"UPI\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"3163\"}]");
		assertEquals(multivalueArrayExtensionEntry.get(2).getName(), "name");
		assertEquals(multivalueArrayExtensionEntry.get(2).getValue(), "array_NonOspiType");
	}

	public void validateNoSQLExtensionData(List<Attribute> listEntry) {
		String extensionName = "", extensionValue = "";
		for (Attribute attribute : listEntry) {
			if (attribute.getName().equalsIgnoreCase("extensionData")) {
				extensionName = attribute.getName().toLowerCase();
				extensionValue = attribute.getValue().toString();
				break;
			}
		}
		assertEquals(extensionName, "extensiondata");
		assertTrue(extensionValue.contains("array_BusDayCentres"));
		assertTrue(extensionValue.contains("India"));
		assertTrue(extensionValue.contains("array_NonOspiType"));
		assertTrue(extensionValue.contains("NonOspiType"));
		assertTrue(extensionValue.contains("paymentOrderProduct"));
		assertTrue(extensionValue.contains("Temenos"));
	}

}