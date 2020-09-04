package com.temenos.microservice.payments.api.test;

import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_ARRAY_NULL;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_BYTEBUFFER_NULL;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_DATATYPES;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_ENUM_NULL;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_NUMBER_MAX;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_NUMBER_MIN;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_NUMBER_NULL;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_OBJECT_NULL;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_STRING_NULL;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_TIMESTAMP_NULL;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_USERDEFINED_NULL;
import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_VALIDATE_UUID_NULL;
import static org.junit.Assert.assertTrue;

import java.sql.SQLException;

import org.junit.Before;
import org.junit.Test;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ClientResponse;

import reactor.core.publisher.Mono;

public class DoInputValidationITTest extends ITTest {

	@Before
	public void setUp() throws SQLException {
		this.client = newWebClient();
	}

	@Test
	public void testInpuValidationWithValidData() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_DATATYPES), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.OK));
		assertTrue(createResponse.bodyToMono(String.class).block().contains(
				"{\"paymentId\":22,\"personalAccNo\":32,\"branchId\":14,\"monthCount\":8,\"penaltyInterest\":6.4,\"yearWiseInterest\":56.0,\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"paymentDate\":1500658348000,\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"seniorCitizen\":false,\"paymentOrders\":[{\"fileOverWrite\":false,\"paymentMethod\":{\"id\":33,\"name\":\"Card\"}}],\"currency\":\"USD\",\"extensionData\":{\"id\":\"43\"},\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33}}"));
	}

	@Test
	public void testInpuValidationExtensionDataNull() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_USERDEFINED_NULL), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block()
				.contains("[{\"message\":\"[PaymentDetails.extensionData must not be null]\",\"code\":\"\"}]"));
	}

	@Test
	public void testInpuValidationObjectNull() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_OBJECT_NULL), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block()
				.contains("[{\"message\":\"[PaymentDetails.PaymentOrdersItems must not be null]\",\"code\":\"\"}]"));
	}

	@Test
	public void testInpuValidationArrayNull() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_ARRAY_NULL), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block()
				.contains("[{\"message\":\"[PaymentDetails.paymentOrders must not be null]\",\"code\":\"\"}]"));
	}

	@Test
	public void testInpuValidationEnumNull() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_ENUM_NULL), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block()
				.contains("[{\"message\":\"[PaymentDetails.currency must not be null]\",\"code\":\"\"}]"));
	}

	@Test
	public void testInpuValidationtTimeStampNull() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_TIMESTAMP_NULL), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block()
				.contains("[{\"message\":\"[PaymentDetails.paymentDate must not be null]\",\"code\":\"\"}]"));
	}

	@Test
	public void testInpuValidationtUuidNull() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_UUID_NULL), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block()
				.contains("[{\"message\":\"[PaymentDetails.socialSecurityNo must not be null]\",\"code\":\"\"}]"));
	}

	@Test
	public void testInpuValidationtByteBufferNull() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_BYTEBUFFER_NULL), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block()
				.contains("[{\"message\":\"[PaymentDetails.fileReadWrite must not be null]\",\"code\":\"\"}]"));
	}

	@Test
	public void testInpuValidationtNumberNull() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_NUMBER_NULL), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block().contains(
				"[{\"message\":\"[PaymentDetails.paymentId must not be null, PaymentDetails.branchId must not be null, PaymentDetails.monthCount must not be null, PaymentDetails.yearWiseInterest must not be null]\",\"code\":\"\"}]"));
	}

	@Test
	public void testInpuValidationtNumberMIN() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_NUMBER_MIN), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block().contains(
				"[{\"message\":\"[PaymentDetails.personalAccNo must be greater than or equal to 5, PaymentDetails.branchId must be greater than or equal to 5, PaymentDetails.penaltyInterest must be greater than or equal to 5, PaymentDetails.yearWiseInterest must be greater than or equal to 1.0]\",\"code\":\"\"}]"));
	}

	@Test
	public void testInpuValidationtNumberMAX() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_NUMBER_MAX), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block().contains(
				"[{\"message\":\"[PaymentDetails.personalAccNo must be lesser than or equal to 50, PaymentDetails.branchId must be lesser than or equal to 50, PaymentDetails.penaltyInterest must be lesser than or equal to 50, PaymentDetails.yearWiseInterest must be lesser than or equal to 60.0]\",\"code\":\"\"}]"));
	}

	@Test
	public void testInpuValidationtStringNull() {
		ClientResponse createResponse;
		do {
			createResponse = this.client.post().uri("/payments/validations")
					.body(BodyInserters.fromPublisher(Mono.just(JSON_BODY_TO_VALIDATE_STRING_NULL), String.class))
					.exchange().block();
		} while (createResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
		assertTrue(createResponse.statusCode().equals(HttpStatus.BAD_REQUEST));
		assertTrue(createResponse.bodyToMono(String.class).block()
				.contains("[{\"message\":\"[PaymentDetails.paymentMethod must not be null]\",\"code\":\"\"}]"));
	}
}