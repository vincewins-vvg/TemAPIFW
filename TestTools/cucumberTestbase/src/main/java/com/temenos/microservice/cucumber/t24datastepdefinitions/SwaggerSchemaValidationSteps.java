package com.temenos.microservice.cucumber.t24datastepdefinitions;

import static io.restassured.RestAssured.given;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import com.temenos.microservice.test.cucumber.MSFrameworkEndPointConfiguration;

import cucumber.api.java.Before;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
/**
 * TODO: Document me!
 *
 * @author mohamedasarudeen
 *
 */
public class SwaggerSchemaValidationSteps{
private MSFrameworkEndPointConfiguration endPointConfig;
private RequestSpecification requestDocument;
private RequestSpecification requestValidator;
private Response responseDocument;
private Response responseValidator;
private String requestDocumentUri;
private String requestValidatorUri;
private Map<String, String> queryParametersDocument;
private Map<String, String> queryParametersValidator;

public SwaggerSchemaValidationSteps(MSFrameworkEndPointConfiguration endPointConfig) {
    this.endPointConfig = endPointConfig;
}

@Before
public void setUp() {
    requestDocument = given();
    requestValidator = given();

    requestDocument.urlEncodingEnabled(false);
    requestValidator.urlEncodingEnabled(false);

    requestDocument.baseUri(endPointConfig.getEndpointUri());
    requestValidator.baseUri(endPointConfig.getEndpointUri());

    String username = endPointConfig.getUserName(), password = endPointConfig.getPassword();
    if (username != null && password != null) {
        requestDocument.auth().basic(username, password);
        requestValidator.auth().basic(username, password);
    }
    this.queryParametersDocument = new HashMap<>();
    this.queryParametersValidator = new HashMap<>();
}


@And("^the document needs to be converted$")
public void theResponseNeedsToBeConverted() {
    String base64encoded = new String(Base64.getEncoder().encode(responseDocument.body().asString().getBytes()));
    assertNotNull(base64encoded);
    String body = "{ \"bodyString\": \"" + base64encoded +"\"}";
    requestValidator.body(body);
}

@Given("^the document request path is (.*)$")
public void givenRequest(String path) {
    requestDocumentUri = path;
}

@Given("^the validator request path is (.*)$")
public void givenValidatorRequest(String path) {
    requestValidatorUri = path;
}

@Given("^document request header (.*) is set to (.*)$")
public void givenRequestHeader(String headerName, String headerValue) {
    requestDocument.header(headerName, headerValue);
}

@Given("^validator request header (.*) is set to (.*)$")
public void givenRequestValidatorHeader(String headerName, String headerValue) {
    requestValidator.header(headerName, headerValue);
}

@When("^a (GET|POST|PUT|PATCH|DELETE) document request is sent$")
public void whenISendTheRequest(String method) {
    requestDocument.queryParams(queryParametersDocument);
    switch (method) {
        case "GET":
            responseDocument = requestDocument.get(requestDocumentUri);
            break;
        case "PUT":
            responseDocument = requestDocument.put(requestDocumentUri);
            break;
        case "POST":
            responseDocument = requestDocument.post(requestDocumentUri);
            break;
        case "DELETE":
            responseDocument = requestDocument.delete(requestDocumentUri);
            break;
        default:
            break;
    }
}

@When("^a (GET|POST|PUT|PATCH|DELETE) validator request is sent$")
public void whenISendTheValidatorRequest(String method) {
    requestValidator.queryParams(queryParametersValidator);
    switch (method) {
        case "POST":
            responseValidator = requestValidator.post(requestValidatorUri);
            break;
        default:
            break;
    }
}

@Then("^the response document status code should be (\\d+)$")
public void theResponseStatusEquals(int status) {
    assertEquals(status, responseDocument.statusCode());
}

@Then("^the response validator status code should be (\\d+)$")
public void theResponseValidatorStatusEquals(int status) {
    assertEquals(status, responseValidator.statusCode());
}
}
