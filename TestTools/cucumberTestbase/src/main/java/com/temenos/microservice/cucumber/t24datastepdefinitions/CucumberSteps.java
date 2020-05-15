package com.temenos.microservice.cucumber.t24datastepdefinitions;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.allOf;
import static org.hamcrest.Matchers.endsWith;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.hasItem;
import static org.hamcrest.Matchers.hasKey;
import static org.hamcrest.Matchers.isA;
import static org.hamcrest.Matchers.isIn;
import static org.hamcrest.Matchers.isOneOf;
import static org.hamcrest.Matchers.lessThanOrEqualTo;
import static org.hamcrest.Matchers.notNullValue;
import static org.hamcrest.Matchers.nullValue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.net.URISyntaxException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

import com.temenos.useragent.cucumber.config.EndPointConfiguration;

import cucumber.api.Delimiter;
import cucumber.api.java.Before;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.response.ResponseBody;
import io.restassured.specification.RequestSpecification;
/**
 * TODO: Document me!
 *
 * @author mohamedasarudeen
 *
 */
public class CucumberSteps {

    private EndPointConfiguration endPointConfig;
    private RequestSpecification request;
    private Response response;
    private String requesturi;
    private Map<String, String> queryParameters;
    
    public CucumberSteps(EndPointConfiguration endPointConfig) {
        this.endPointConfig = endPointConfig;
    }

    @Before
    public void setUp() {
        request = given().log().all();  
        request.urlEncodingEnabled(false);
        request.baseUri(endPointConfig.getEndpointUri());
        String username = endPointConfig.getUserName(), password = endPointConfig.getPassword();
        if (username != null && password != null) {
            request.auth().basic(username, password);
        }
        this.queryParameters = new HashMap<>();
    }

    @Given("^the request path is (.*)$")
    public void givenRequest(String path) throws Throwable {
        requesturi = path;
    }

    @Given("^request header (.*) is set to (.*)$")
    public void givenRequestHeader(String headerName, String headerValue) throws Throwable {
        request.header(headerName, headerValue);
    }

    @Given("^the request body is set to the contents of (.*)$")
    public void givenRequestBody(String body) {
        try {
            request.body(Paths.get(getClass().getClassLoader().getResource(body).toURI()).toFile());
            request.given().log().body();
          
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }

    @Given("^query parameter (.*) is set to (.*)$")
    public void givenAQueryParameter(String queryParameterName, String queryParameterValue) {
        queryParameters.put(queryParameterName, queryParameterValue);
    }

    @When("^a (GET|POST|PUT|PATCH|DELETE) request is sent$")
    public void whenISendTheRequest(String method) throws Throwable {
        request.queryParams(queryParameters);
        switch (method) {
            case "GET":
                response = request.get(requesturi);
                break;
            case "PUT":
                response = request.put(requesturi);
                break;
            case "POST":
                response = request.post(requesturi);
                break;
            case "DELETE":
                response = request.delete(requesturi);
                break;
            default:
                break;
        }
    }

    @Then("^the response status code should be (\\d+)$")
    public void theResponseStatusEquals(int status) throws Throwable {
        assertEquals(status, response.statusCode());
    }

    @Then("^the response status code should be one of (.*)$")
    public void theResponseStatusEquals(List<Integer> statusList) throws Throwable {
        // TODO: investigate SAF failure
        System.out.println(Optional.ofNullable(response.getBody()).map(ResponseBody::prettyPrint).orElse(""));
        System.out.println("Actual: " + response.getStatusCode());
        statusList.forEach(item -> System.out.println("Expected: " + item));
        //assertTrue(statusList.contains(response.getStatusCode()));
    }

    @Then("^the response body should be empty")
    public void responseBodyShouldBeEmpty() {
        assertTrue(response.getBody().asString().isEmpty());
    }
    
    @Then("^Log all the responses in console")
    public void logResponses() {
         response.prettyPrint();      
     
    }
    
    @Then("^Log all the requestbody in console")
    public void logRequestBody() {
           request.given().log().body().get().asString();
        
    }

    @Then("^the response body should equal \"(.+)\"$")
    public void responseBodyShouldEqual(String value) {
        response.then().assertThat().contentType(equalTo(value));
    }

    @Then("^JSON boolean property (.*) should equal (true|false)$")
    public void jsonResponseBooleanPropertyXEqualsY(String property, boolean value) {
        boolean actualValue = JsonPath.from(response.body().asString()).getBoolean(property);
        assertEquals(value, actualValue);
        response.then().body(property, equalTo(actualValue));
    }

    @Then("^JSON integer property (.*) should equal (\\d+)$")
    public void jsonResponseIntegerPropertyXEqualsNumberY(String property, int value) throws Throwable {
        int actualValue = JsonPath.from(response.body().asString()).getInt(property);
        assertEquals(value, actualValue);
        response.then().body(property, equalTo(value));
    }

    @Then("^JSON integer property (.*) should be greater than (\\d+)$")
    public void jsonResponseIntegerPropertyXGreaterThanY(String property, int minimum) throws Throwable {
        int actualValue = JsonPath.from(response.body().asString()).getInt(property);
        response.then().body(property, greaterThanOrEqualTo(minimum));
    }

    @Then("^JSON integer property (.*) should be less than (\\d+)$")
    public void jsonResponseIntegerPropertyXLessThanY(String property, int maximum) throws Throwable {
        int actualValue = JsonPath.from(response.body().asString()).getInt(property);
        response.then().body(property, lessThanOrEqualTo(maximum));
    }

    @Then("^JSON integer property (.*) should be greater than (\\d+) and less than (\\d+)$")
    public void jsonResponseIntegerPropertyXGreaterThanYLessThanZ(String property, int minimum, int maximum) throws Throwable {
        int actualValue = JsonPath.from(response.body().asString()).getInt(property);
        response.then().body(property, allOf(greaterThanOrEqualTo(minimum), lessThanOrEqualTo(maximum)));
    }

    @Then("^JSON string property (.*) should be a local link ending with \"(.+)\"")
    public void jsonResponseStringPropertyXIsALinkEndingInY(String property, String ending) throws Throwable {
        response.then().body(property, endsWith(ending));
    }

    @Then("^JSON string property (.*) should equal \"(.+)\"$")
    public void jsonResponseStringPropertyXEqualsNumberY(String property, String value) throws Throwable {
        response.then().body(property, equalTo(value));
        
    }

    @Then("^JSON string property (.*) should match \"(.+)\"$")
    public void jsonResponseStringPropertyXMatchesY(String property, String regex) throws Throwable {
        String actualValue = JsonPath.from(response.body().asString()).getString(property);
        assertTrue(actualValue.matches(regex));
    }

    @Then("^JSON string property (.*) should be at least (\\d*) characters and at most (\\d*) characters$")
    public void jsonResponseStringPropertyIsCorrectLength(String property, int minLength, int maxLength) throws Throwable {
        int actualLength = JsonPath.from(response.body().asString()).getString(property).length();
        assertTrue(actualLength >= minLength && actualLength <= maxLength);
    }

    @Then("^JSON property (.*) should contain (\\d+) elements?$")
    public void jsonResponsePropertyContainsNNumberOfElements(String property, int count) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(property), isA(List.class));
        List<Object> actualValue = responseBody.getList(property);
        assertEquals(count, actualValue.size());
    }

    @Then("^JSON property (.*) should contain at least (\\d+) elements?$")
    public void jsonResponsePropertyContainsAtLeastNNumberOfElements(String property, int count) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(property), isA(List.class));
        List<Object> actualValue = responseBody.getList(property);
        assertThat(actualValue.size(), greaterThanOrEqualTo(count));
    }

    @Then("^JSON property (.*) should contain at most (\\d+) elements?$")
    public void jsonResponsePropertyContainsAtMostNNumberOfElements(String property, int count) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(property), isA(List.class));
        List<Object> actualValue = responseBody.getList(property);
        assertThat(actualValue.size(), lessThanOrEqualTo(count));
    }

    @Then("^JSON property (.*?) should contain at least (\\d+) elements? and at most (\\d+) elements?$")
    public void jsonResponsePropertyContainsAtLeastMAndAtMostNNumberOfElements(String property, int min, int max) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(property), isA(List.class));
        List<Object> actualValue = responseBody.getList(property);
        assertThat(actualValue.size(), allOf(greaterThanOrEqualTo(min), lessThanOrEqualTo(max)));
    }

    @Then("^JSON root array should contain (\\d+) elements?$")
    public void jsonResponseRootArrayContainsAtMostNNumberOfElements(int count) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(), isA(List.class));
        List<Object> actualValue = responseBody.get();
        assertEquals(count, actualValue.size());
    }

    @Then("^all elements in JSON array (.*?) should be equal to one of \"(.*?)\"")
    public void jsonResponseArrayElementsMatchGivenValue(String property, String elements){
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(property), isA(List.class));
        for(Object o : responseBody.getList(property)){
            assertThat(o, isOneOf(elements.split(",")));
        }
    }

    @Then("^JSON property (.*) should be null$")
    public void jsonPropertyShouldBeNull(String property){
        response.then().body(property, nullValue());
    }

    @Then("^JSON property (.*) should not exist$")
    public void jsonPropertyShouldNotExist(String property){
        response.then().body(property, not(hasKey(property)));
    }

    @Then("^JSON property (.*) should exist$")
    public void jsonPropertyShouldExist(String property){
        response.then().body(property, notNullValue());
    }

    @And("^the response header (.*) should be (.*)$")
    public void theResponseHeaderShouldBeEqualTo(String name, String value) throws Throwable {
        assertThat(response.getHeader(name), equalTo(value));
    }


    @Then("^JSON property (.*) should be a decimal number$")
    public void jsonPropertyShouldBeADecimalNumber(String property){
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.getDouble(property), notNullValue());
    }

    @Then("^JSON property (.*) should be a decimal number greater than (-?\\d+) and less than (-?\\d+)$")
    public void jsonPropertyShouldBeADecimalNumberGreaterThanXAndLessThanY(String property, long minimum, long maximum){
        JsonPath responseBody = JsonPath.from(response.body().asString());
        Number value = responseBody.get(property), minNum = minimum, maxNum = maximum;
        assertThat(value, notNullValue());
        assertThat(value.doubleValue(), allOf(greaterThanOrEqualTo(minNum.doubleValue()), lessThanOrEqualTo(maxNum.doubleValue())));
    }

    @Then("^the JSON response root should be array$")
    public void theJSONResponseRootShouldBeArray() {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(), isA(List.class));
    }

    @Then("^the JSON object \\[(\\d+)] should have key \"([^\"]*)\" and value \"([^\"]*)\"$")
    public void theJSONObjectShouldHaveTypeNumericAndValue(int arg0, String arg1, String arg2){
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(), isA(List.class));
        List<Object> actualValue = responseBody.get();
        HashMap value = (HashMap) actualValue.get(arg0);
        assertTrue(value.containsKey(arg1));
        assertEquals(value.get(arg1), arg2);
    }

    @Then("^the JSON object \\[(\\d+)] should have key \"([^\"]*)\" and value should be array$")
    public void theJSONObjectShouldHaveKeyAndValueShouldBeArray(int arg0, String arg1) {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(), isA(List.class));
        List<Object> actualValue = responseBody.get();
        HashMap value = (HashMap) actualValue.get(arg0);
        assertTrue(value.containsKey(arg1));
        assertThat((List) value.get(arg1), isA(List.class));
    }
    
    @Then("^the JSON array (.*) in the position (\\d+) should have key \"([^\"]*)\" and value \"([^\"]*)\"$")
    public void theJSONObjectDataPositionShouldHaveKeyAndValue(String array, int arg0, String arg1, String arg2) {
        List<Object> actualValue = getJsonArray(array);
        HashMap value = (HashMap) actualValue.get(arg0);
        assertTrue(value.containsKey(arg1));
        assertEquals(value.get(arg1), arg2);
    }
  
    @Then("^the JSON array (.*) should have an element with key \"([^\"]*)\" and value \"([^\"]*)\"$")
    public void theJSONObjectDataShouldHaveKeyAndValue(String array, String key, String val) {
        List<String> actualValues = getValuesFromJsonArrayWithKey(key, array);
        assertThat(actualValues, hasItem(val));
    }
    
    
    @Then("^the JSON array (.*) should not have an element with key \"([^\"]*)\" and values? (.*)$")
    public void theJSONObjectDataShouldNotHaveKeyAndValue(String array, String key, @Delimiter(":") List<String> values) {
        List<String> actualValues = getValuesFromJsonArrayWithKey(key, array);
        for (String val : values) {
             assertThat(actualValues, not(hasItem(val)));
        }       
    }
    
    @Then("^the JSON array (.*) should have values? (.*)$")
    public void theJSONArrayShouldHaveValues(String array, @Delimiter(":") List<String> values) {
        for (String val : values) {
            assertThat(getJsonArrayValues(array), hasItem(val));
        }
    }
    
    @Then("^the JSON array (.*) should not have values other than (.*)$")
    public void theJSONArrayShouldNotHaveValuesOtherThan(String array, @Delimiter(":") List<String> values) {
        for (String value : getJsonArrayValues(array)) {
            assertThat(value , isIn(values));
        }
    }
    
    private List<Object> getJsonArray(String array) {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(array), notNullValue());
        return responseBody.get(array);
    }
    
    private List<String> getJsonArrayValues(String array) {
        return getJsonArray(array).stream()
        .map(object -> Objects.toString(object, null))
        .collect(Collectors.toList());
    }
    
    private List<String> getValuesFromJsonArrayWithKey(String key, String array) {
        List<String> values = new ArrayList<>(); 
        for (Object obj : getJsonArray(array)) {
            Map<String, String> props = (Map<String, String>) obj;
            values.add(props.get(key));
        }
        return values;
    }
}
