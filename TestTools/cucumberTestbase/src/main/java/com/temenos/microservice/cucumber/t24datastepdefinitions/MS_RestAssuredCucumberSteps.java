package com.temenos.microservice.cucumber.t24datastepdefinitions;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.allOf;
import static org.hamcrest.Matchers.containsString;
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
import static uk.co.datumedge.hamcrest.json.SameJSONAs.sameJSONAs;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.io.IOUtils;
import org.hamcrest.Matchers;
import org.hamcrest.core.Every;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import com.temenos.microservice.cucumber.utility.stepdefs.ExcelDataConfig;
import com.temenos.microservice.cucumber.utility.stepdefs.GlobalConfig;
import com.temenos.microservice.cucumber.utility.stepdefs.ReusableTestDataFunctionRestAssured;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.test.cucumber.MSFrameworkEndPointConfiguration;
import com.temenos.useragent.cucumber.steps.CucumberInteractionSession;
import com.temenos.useragent.cucumber.steps.HeaderStepDefs;
import com.temenos.useragent.cucumber.steps.InteractionSessionStepDefs;
import com.temenos.useragent.cucumber.steps.ScenarioBundleStepDefs;

import cucumber.api.Delimiter;
import cucumber.api.java.Before;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.RestAssured;
import io.restassured.http.Cookie;
import io.restassured.parsing.Parser;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.response.ResponseBody;
import io.restassured.specification.RequestSpecification;

/**
 * Infinity Microservices RestAssured Cucumber StepDefinitions
 *
 * @author mohamedasarudeen
 *
 */
public class MS_RestAssuredCucumberSteps {

    private MSFrameworkEndPointConfiguration endPointConfig;
    private RequestSpecification request;
    private Response response;
    private String requesturi;
    private String requestJsonContents;
    private Map<String, String> queryParameters;
    private Map<String, String> queryParametersTextFile;
    private String stringDataType;
    private String claimsTokenValue;
    private String authCodeVariable = "";

    @Autowired
    private InteractionSessionStepDefs interactionSessionStepDefs;
    @Autowired
    private CucumberInteractionSession cucumberInteractionSession;
    @Autowired
    private ScenarioBundleStepDefs scenarioBundleStepDefs;
    @Autowired
    private GlobalConfig globalConfig;
    @Autowired
    private GlobalConfig globalConfigSharedSecretLogin;
    @Autowired
    private HeaderStepDefs headerStepDefs;

    ReusableTestDataFunctionRestAssured resuableObject = new ReusableTestDataFunctionRestAssured();

    private String authToken = null;
    private String authTokenFilePath = null;

    public MS_RestAssuredCucumberSteps(MSFrameworkEndPointConfiguration endPointConfig) {
        this.endPointConfig = endPointConfig;

    }

    @Before
    public void setUp() {
        interactionSessionStepDefs.createSession();
        interactionSessionStepDefs.setDefaultBasicAuthoriztion();
        interactionSessionStepDefs.setDefaultMediaType();
        RestAssured.defaultParser = Parser.JSON;
        request = given().log().all();
        request.urlEncodingEnabled(false);
        request.baseUri(endPointConfig.getEndpointUri());
        String username = endPointConfig.getUserName(), password = endPointConfig.getPassword();
        if (username != null && password != null) {
            request.auth().basic(username, password);
        }
        this.queryParameters = new HashMap<>();
        this.queryParametersTextFile = new HashMap<>();
    }

    @Given("^*create a new MS request with code using Restassured arguments \"(.*)\"$")
    public void givenCreateMSRequest(String envVariable) throws Throwable {
        System.out.println("Before Initialise");
        initialize(envVariable);
    }

    @Given("^MS request URI is \"(.*)\"$")
    public void givenRequest(String path) throws Throwable {
        requesturi = path;
    }

    // Base path get from text file and concat with path and bundleVariable

    @Given("^concat the MS request URI \"(.*)\" with Bundle Value \"(.*)\"$")
    public void givenRequestBasePathBundleValue(String path, String bundleVariable) throws Throwable {

        String basePathbundleValueStore = cucumberInteractionSession.scenarioBundle()
                .getString(bundleVariable.replace("{", "").replace("}", ""));

        requesturi = path + "/" + basePathbundleValueStore;

    }

    // To support multiple URLs in End to End testing in MS code

    @Given("^MS endpoint uri2 is set with second URL$")
    public void givenEndpointUri2() throws Throwable {
        request.baseUri(endPointConfig.getURI2());
    }

    @Given("^MS endpoint uri3 is set with third URL$")
    public void givenEndpointUri3() throws Throwable {
        request.baseUri(endPointConfig.getURI3());
    }

    @Given("^MS endpoint uri4 is set with fourth URL$")
    public void givenEndpointUri4() throws Throwable {
        request.baseUri(endPointConfig.getURI4());
    }

    @Given("^MS endpoint uri5 is set with fifth URL$")
    public void givenEndpointUri5() throws Throwable {
        request.baseUri(endPointConfig.getURI5());
    }

    // Kony Step definitions

    /*
     * Login for Admin Console API Identity Service
     */

    @Given("^do login authentication for the MS request path with username key \"(.*)\" value pair \"(.*)\" password key \"(.*)\" value pair \"(.*)\" provider key \"(.*)\" value pair \"(.*)\" loginOptions key \"(.*)\" form param value is set to (.*?)$")
    public void givenRequestAuthentication(String usernameKey, String usernameValue, String passwordKey,
            String passwordValue, String providerKey, String providerValue, String loginOptionsKey,
            String loginOptionsValue) throws Throwable {

        request.baseUri(endPointConfig.getLoginURI());
        request.header("Content-Type", "application/x-www-form-urlencoded");
        request.header("X-Kony-App-Key", endPointConfig.getAppKey());
        request.header("X-Kony-App-Secret", endPointConfig.getAppSecret());

        request.formParam(usernameKey, usernameValue);
        request.formParam(passwordKey, passwordValue);
        request.formParam(providerKey, providerValue);
        request.formParam(loginOptionsKey, loginOptionsValue);

    }

    /*
     * Login for Admin Console API Identity Service
     */

    @Given("^do login API authentication for the MS request path with username key \"(.*)\" value pair \"(.*)\" password key \"(.*)\" value pair \"(.*)\" provider key \"(.*)\" value pair \"(.*)\" loginOptions key \"(.*)\" form param value is set to (.*?)$")
    public void givenRequestAPIAuthentication(String usernameKey, String usernameValue, String passwordKey,
            String passwordValue, String providerKey, String providerValue, String loginOptionsKey,
            String loginOptionsValue) throws Throwable {

        request.baseUri(endPointConfig.getLoginURI());

        request.header("Content-Type", "application/x-www-form-urlencoded");
        request.header("X-Kony-App-Key", endPointConfig.getAppKey());
        request.header("X-Kony-App-Secret", endPointConfig.getAppSecret());
        request.header("X-Kony-AC-API-Access-Token", "yKegmTtA28hciLeMryqd");

        request.formParam(usernameKey, usernameValue);
        request.formParam(passwordKey, passwordValue);
        request.formParam(providerKey, providerValue);
        request.formParam(loginOptionsKey, loginOptionsValue);

    }

    @Given("^MS login claims token set in global config is set to \"(.*)\"$")
    public void givenLoginClaimsToken(String claimsTokenKey) throws Throwable {

        JsonPath responseBody = JsonPath.from(response.body().asString());

        String token = responseBody.getString(claimsTokenKey);

        globalConfig.setToken(token);
    }

    @Given("^get the MS identity claims token value is set for header key \"(.*)\"$")
    public void givenClaimsTokenValueSetBundleValue(String headerKey) throws Throwable {

        System.out.println("CLAIMSTOKEN_VALUE: " + globalConfig.getToken());
        request.header(headerKey, globalConfig.getToken());

    }

    // SharedSecretTokenLogin refresh token value generation

    @Given("^MS login shared secret refresh token set in global config is set to \"(.*)\"$")
    public void givenLoginRefreshToken(String refreshTokenKey) throws Throwable {

        JsonPath responseBody = JsonPath.from(response.body().asString());

        String sharedSecretLoginToken = responseBody.getString(refreshTokenKey);

        globalConfig.setSharedSecretLoginToken(sharedSecretLoginToken);
    }

    @Given("^get the MS identity refresh token value is set for header key \"(.*)\"$")
    public void givenRefreshTokenValueSetBundleValue(String headerKey) throws Throwable {

        System.out.println("Refresh Token value for Shared Secret Login : " + globalConfig.getSharedSecretLoginToken());
        request.header(headerKey, globalConfig.getSharedSecretLoginToken());

    }

    @Given("^MS Application response api JSessionID cookies value is set to \"(.*)\"$")
    public void givenCookiesValue(String cookiesValue) throws Throwable {

        Cookie cookie = response.getDetailedCookie(cookiesValue);
        String JsessionID = cookie.getValue();
        globalConfig.setCookie(JsessionID);
    }

    @Given("^get the MS cookies JSessionId value is set for header key \"(.*)\"$")
    public void givenCookiesJSessionIdValueSetBundleValue(String headerKey) throws Throwable {

        System.out.println("JESSION_ID VALUE : " + globalConfig.getCookie());
        request.header(headerKey, "JSESSIONID=" + globalConfig.getCookie());

    }

    @Given("^do the MS login API authentication for the service request path and username password from property file$")
    public void givenRequestAPIAuthentication() throws Throwable {

        System.out.println("Property getLoginURI : " + endPointConfig.getLoginURI());
        request.baseUri(endPointConfig.getLoginURI());
    }

    @Given("^MS request header \"([^\"]*)\" is set to \"(.*)\"$")
    public void givenRequestHeader(String headerName, String headerValue) throws Throwable {
        request.header(headerName, headerValue);
    }
    
    @Given("^MS request form-data \"([^\"]*)\" is set to \"(.*)\"$")
    public void setFormData(String formDataKey, String formDataValue) throws Throwable {
        request.multiPart(formDataKey, formDataValue);
    }

    @Given("^I set the MS request header values for X-Kony-ReportingParams$")
    public void givenRequestHeaderReportingParams() throws Throwable {
        
      
        request.header("X-Kony-ReportingParams",
                "{\"os\":\"71\",\"dm\":\"\",\"did\":\"1544592656431-5e10-a1f1-7b6f\",\"ua\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36\",\"aid\":\"KonyOLB\",\"aname\":\"Customer360\",\"chnl\":\"Mobile\",\"plat\":\"windows\",\"aver\":\"1.0.0\",\"atype\":\"spa\",\"stype\":\"b2c\",\"kuid\":\"admin2\",\"mfaid\":\"61cffb74-340f-497f-b637-ff553e93dae5\",\"mfbaseid\":\"92b54bcc-e43e-4a62-bbd9-f7d1ca009391\",\"mfaname\":\"KonyBankingAdminConsole\",\"sdkversion\":\"8.3.5\",\"sdktype\":\"js\",\"fid\":\"frmLogin\",\"rsid\":\"1544972285376-6808-1496-9004\",\"svcid\":\"login_KonyBankingAdminConsoleIdentityService\"}");
    }

    @Given("^I set the MS request header values for X-Kony-App-Key and X-Kony-App-Secret-Key$")
    public void givenRequestKonyAppKeySecretKey() throws Throwable {

        request.header("X-Kony-App-Key", endPointConfig.getAppKey());
        request.header("X-Kony-App-Secret", endPointConfig.getAppSecret());
    }

    @Given("^and store MS CLAIM_TOKEN to the file path \"([^\"]*)\"$")
    public void storeClaimTokenToFile(String path) throws Throwable {
        this.authTokenFilePath = path;
        File file = new File(path);
        FileWriter writer = new FileWriter(file);
        writer.write(this.authToken);
        writer.close();

        /*
         * IOUtils.write(this.authToken, new
         * FileOutputStream(System.getProperty("user.dir") + "/" + path),
         * "UTF-8")
         */;
    }

    @Given("^and use last authenticated MS CLAIM_TOKEN for the request header \"([^\"]*)\"$")
    public void useClaimToken(String headerKey) throws Throwable {
        try {
            String authFileToken = IOUtils
                    .toString(new FileInputStream(System.getProperty("user.dir") + "/" + this.authTokenFilePath));
            request.header(headerKey, authFileToken);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Bundle value set in request path - MS code

    @Given("^the MS request path is set to pre path \"(.*)\" appending bundle value \"(.*)\" with post path \"(.*)\"$")
    public void givenRequestFromBundleValue(String prePath, String bundleValue, String postPath) throws Throwable {

        String bundleValuePath = cucumberInteractionSession.scenarioBundle()
                .getString(bundleValue.replace("{", "").replace("}", ""));

        requesturi = prePath + bundleValuePath + postPath;

    }

    @Given("^MS request header \"([^\"]*)\" is set with bundle value \"(.*)\"$")
    public void givenRequestHeaderBundleValue(String headerName, String bundleValue) throws Throwable {

        String bundleValueStore = cucumberInteractionSession.scenarioBundle()
                .getString(bundleValue.replace("{", "").replace("}", ""));
        request.header(headerName, bundleValueStore);
        
    }

    @Given("^the MS request body is set to the contents of \"(.*)\"$")
    public void givenRequestBody(String body) {
        try {
            request.body(IOUtils.toString(new FileInputStream(System.getProperty("user.dir") + "/" + body)));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Given("^the MS request body after dynamically updated values is set to the contents of \"(.*)\"$")
    public void givenRequestBodyDynamicUpdateValue(String body) {
        try {
            request.body(IOUtils.toString(new FileInputStream(System.getProperty("user.dir") + "/" + body)));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Given("^MS request form param values for x-www-form-urlencoded header type key \"([^\"]*)\" value is set to \"([^\"]*)\"$")
    public void givenRequestFormParam(String formKey, String formValue) throws Throwable {
        request.formParam(formKey, formValue);
    }

    // Key and value should be mandatorily passed
    @Given("^MS query parameter \"([^\"]*)\" is set to value \"([^\"]*)\"$")
    public void givenAQueryParameter(String queryParameterName, String queryParameterValue) {
        queryParameters.put(queryParameterName, queryParameterValue + this.authCodeVariable);

    }

    // Used for passing query param values on Azure env, value will be passed
    // during run time
    // Value should not be passed explicitly, mandatory step for all MS scripts
    @Given("^MS query parameter for Azure env is set to value \"([^\"]*)\"$")
    public void givenAzureQueryParameter(String queryParameterValue) {
        request.queryParam(queryParameterValue + this.authCodeVariable);

    }

    // QueryParams get from Text file Variable like ScenarioBundle

    @Given("^MS query parameter fetch from text file \"([^\"]*)\" is set to \"([^\"]*)\"$")
    public void givenAQueryParameterFetchFromTextFile(String queryParameterName, String queryParameterVariable) {

        String queryParameterbundleValueStore = cucumberInteractionSession.scenarioBundle()
                .getString(queryParameterVariable.replace("{", "").replace("}", ""));

        queryParametersTextFile.put(queryParameterName, queryParameterbundleValueStore);

        request.queryParams(queryParametersTextFile);

    }

    // MS code query param is set from bundle value

    @Given("^MS query parameter \"([^\"]*)\" is set from bundle value \"([^\"]*)\"$")
    public void givenAQueryParameterFromBundleValue(String queryParameterName, String queryParameterBundleValue) {

        String queryParamBundleValue = cucumberInteractionSession.scenarioBundle()
                .getString(queryParameterBundleValue.replace("{", "").replace("}", ""));

        queryParameters.put(queryParameterName, queryParamBundleValue + this.authCodeVariable);
    }

    @Given("^And MS request body \"([^\"]*)\" is set to \"([^\"]*)\"$")
    public void updateRequestStringDynamicValues(String replaceKey, String replaceValue) {
        this.requestJsonContents = this.requestJsonContents.replace(replaceKey, replaceValue);
        request.body(this.requestJsonContents);
    }

    @Given("^post the static MS JSON as payload (.*?)$")
    public void givenRequestBodyContent(String jsonBody) {
        this.requestJsonContents = jsonBody;
        request.body(jsonBody);
    }

    @When("^a \"(GET|POST|PUT|PATCH|DELETE)\" request is sent to MS$")
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
        case "PATCH":
            response = request.patch(requesturi);
            break;
        default:
            break;
        }
    }

    @Then("^MS response code should be (\\d+)$")
    public void theResponseStatusEquals(int status) throws Throwable {
        assertEquals(status, response.statusCode());
       
    }

    @Then("^MS response code should be one of \"([^\"]*)\"$")
    public void theResponseStatusEquals(List<Integer> statusList) throws Throwable {
        System.out.println(Optional.ofNullable(response.getBody()).map(ResponseBody::prettyPrint).orElse(""));
        System.out.println("Actual: " + response.getStatusCode());
        statusList.forEach(item -> System.out.println("Expected: " + item));
        // assertTrue(statusList.contains(response.getStatusCode()));
    }

    @Then("^MS response body should be empty")
    public void responseBodyShouldBeEmpty() {
        assertTrue(response.getBody().asString().isEmpty());
    }

    @Then("^log all MS response in console")
    public void logResponses() {
        response.then().log().headers();
        response.then().log().cookies();
        
        System.out.println("Actual Status Code: " + response.getStatusCode());
        System.out.println("Response Body: ");
        System.out.println(System.lineSeparator());
        Optional.ofNullable(response.getBody()).map(ResponseBody::prettyPrint).orElse("");

    }

    @Then("^log all  MS request body in console")
    public void logRequestBody() {
        request.given().log().body().get().asString();

    }

    @Then("^the MS response body should equal \"(.+)\"$")
    public void responseBodyShouldEqual(String value) {
        response.then().assertThat().contentType(equalTo(value));
    }

    @Then("^MS JSON boolean property \"([^\"]*)\" should equal (true|false)$")
    public void jsonResponseBooleanPropertyXEqualsY(String property, boolean value) {
        response.then().body(property, notNullValue());
        boolean actualValue = JsonPath.from(response.body().asString()).getBoolean(property);
        assertEquals(value, actualValue);
        response.then().body(property, equalTo(actualValue));
    }

    @Then("^MS JSON integer property \"([^\"]*)\" should equal (\\d+)$")
    public void jsonResponseIntegerPropertyXEqualsNumberY(String property, int value) throws Throwable {
        response.then().body(property, notNullValue());
        int actualValue = JsonPath.from(response.body().asString()).getInt(property);
        assertEquals(value, actualValue);
    }

    @Then("^MS JSON integer property \"([^\"]*)\" should equal \"([^\"]*)\"$")
    public void jsonResponseIntegerPropertyXEqualsNumberZ(String property, int value) throws Throwable {
        response.then().body(property, notNullValue());
        int actualValue = JsonPath.from(response.body().asString()).getInt(property);
        assertEquals(value, actualValue);
    }

    @Then("^MS JSON integer property \"([^\"]*)\" should be greater than (\\d+)$")
    public void jsonResponseIntegerPropertyXGreaterThanY(String property, int minimum) throws Throwable {
        response.then().body(property, notNullValue());
        int actualValue = JsonPath.from(response.body().asString()).getInt(property);
        response.then().body(property, greaterThanOrEqualTo(minimum));
    }

    @Then("^MS JSON integer property \"([^\"]*)\" should be less than (\\d+)$")
    public void jsonResponseIntegerPropertyXLessThanY(String property, int maximum) throws Throwable {
        response.then().body(property, notNullValue());
        int actualValue = JsonPath.from(response.body().asString()).getInt(property);
        response.then().body(property, lessThanOrEqualTo(maximum));
    }

    @Then("^MS JSON integer property \"([^\"]*)\" should be greater than (\\d+) and less than (\\d+)$")
    public void jsonResponseIntegerPropertyXGreaterThanYLessThanZ(String property, int minimum, int maximum)
            throws Throwable {
        response.then().body(property, notNullValue());
        int actualValue = JsonPath.from(response.body().asString()).getInt(property);
        response.then().body(property, allOf(greaterThanOrEqualTo(minimum), lessThanOrEqualTo(maximum)));
    }

    @Then("^MS JSON string property \"([^\"]*)\" should be a local link ending with \"(.+)\"")
    public void jsonResponseStringPropertyXIsALinkEndingInY(String property, String ending) throws Throwable {
        response.then().body(property, notNullValue());
        response.then().body(property, endsWith(ending));
    }

    @Then("^MS JSON string property \"([^\"]*)\" should equal \"(.+)\"$")
    public void jsonResponseStringPropertyXEqualsNumberY(String property, String value) throws Throwable {
        response.then().body(property, notNullValue());
        response.then().body(property, equalTo(value));

    }

    @Then("^MS JSON string property \"([^\"]*)\" should match \"(.+)\"$")
    public void jsonResponseStringPropertyXMatchesY(String property, String regex) throws Throwable {
        response.then().body(property, notNullValue());
        String actualValue = JsonPath.from(response.body().asString()).getString(property);
        assertTrue(actualValue.matches(regex));
    }

    @Then("^MS JSON string property \"([^\"]*)\" should be at least (\\d*) characters and at most (\\d*) characters$")
    public void jsonResponseStringPropertyIsCorrectLength(String property, int minLength, int maxLength)
            throws Throwable {
        response.then().body(property, notNullValue());
        int actualLength = JsonPath.from(response.body().asString()).getString(property).length();
        assertTrue(actualLength >= minLength && actualLength <= maxLength);
    }

    @Then("^MS JSON property \"([^\"]*)\" should contain (\\d+) elements?$")
    public void jsonResponsePropertyContainsNNumberOfElements(String property, int count) throws Throwable {
        JsonPath responseBody = response.jsonPath();
//        response.then().body(property, notNullValue());
//        assertThat(responseBody.get(property), isA(List.class));
        System.out.println(responseBody.get(property).toString());
        List<String> actualValue = responseBody.getList(property);
        
        assertEquals(count, actualValue.size());
    }

    @Then("^MS JSON property \"([^\"]*)\" should contain at least (\\d+) elements?$")
    public void jsonResponsePropertyContainsAtLeastNNumberOfElements(String property, int count) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        response.then().body(property, notNullValue());
        assertThat(responseBody.get(property), isA(List.class));
        List<Object> actualValue = responseBody.getList(property);
        assertThat(actualValue.size(), greaterThanOrEqualTo(count));
    }

    @Then("^MS JSON property \"([^\"]*)\" should contain at most (\\d+) elements?$")
    public void jsonResponsePropertyContainsAtMostNNumberOfElements(String property, int count) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        response.then().body(property, notNullValue());
        assertThat(responseBody.get(property), isA(List.class));
        List<Object> actualValue = responseBody.getList(property);
        assertThat(actualValue.size(), lessThanOrEqualTo(count));
    }

    @Then("^MS JSON property (.*?) should contain at least (\\d+) elements? and at most (\\d+) elements?$")
    public void jsonResponsePropertyContainsAtLeastMAndAtMostNNumberOfElements(String property, int min, int max)
            throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        response.then().body(property, notNullValue());
        assertThat(responseBody.get(property), isA(List.class));
        List<Object> actualValue = responseBody.getList(property);
        assertThat(actualValue.size(), allOf(greaterThanOrEqualTo(min), lessThanOrEqualTo(max)));
    }

    @Then("^MS JSON root array should contain (\\d+) elements?$")
    public void jsonResponseRootArrayContainsAtMostNNumberOfElements(int count) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(), isA(List.class));
        List<Object> actualValue = responseBody.get();
        assertEquals(count, actualValue.size());
    }

    @Then("^all elements in MS JSON array (.*?) should be equal to one of \"(.*?)\"")
    public void jsonResponseArrayElementsMatchGivenValue(String property, String elements) {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        response.then().body(property, notNullValue());
        assertThat(responseBody.get(property), isA(List.class));
        for (Object o : responseBody.getList(property)) {
            assertThat(o, isOneOf(elements.split(",")));
        }
    }

    @Then("^MS JSON property \"([^\"]*)\" should be null$")
    public void jsonPropertyShouldBeNull(String property) {
        response.then().body(property, nullValue());
    }

    @Then("^MS JSON property \"([^\"]*)\" should not exist$")
    public void jsonPropertyShouldNotExist(String property) {
        response.then().body(property, not(hasKey(property)));
    }

    @Then("^MS JSON property \"([^\"]*)\" should exist$")
    public void jsonPropertyShouldExist(String property) {
        response.then().body(property, notNullValue());
    }

    @And("^MS response header \"([^\"]*)\" should be \"([^\"]*)\"$")
    public void theResponseHeaderShouldBeEqualTo(String name, String value) throws Throwable {
        assertThat(response.getHeader(name), equalTo(value));
    }

    @Then("^MS JSON property \"([^\"]*)\" should be a decimal number$")
    public void jsonPropertyShouldBeADecimalNumber(String property) {
        JsonPath responseBody = JsonPath.from(response.body().asString());

        assertThat(responseBody.getDouble(property), notNullValue());
    }

    @Then("^MS JSON property \"([^\"]*)\" should be a decimal number greater than (-?\\d+) and less than (-?\\d+)$")
    public void jsonPropertyShouldBeADecimalNumberGreaterThanXAndLessThanY(String property, long minimum,
            long maximum) {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        Number value = responseBody.get(property), minNum = minimum, maxNum = maximum;
        assertThat(value, notNullValue());
        assertThat(value.doubleValue(),
                allOf(greaterThanOrEqualTo(minNum.doubleValue()), lessThanOrEqualTo(maxNum.doubleValue())));
    }

    @Then("^the MS JSON response root should be array$")
    public void theJSONResponseRootShouldBeArray() {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(), isA(List.class));
    }

    @Then("^the MS JSON object \\[(\\d+)] should have key \"([^\"]*)\" and value \"([^\"]*)\"$")
    public void theJSONObjectShouldHaveTypeNumericAndValue(int arg0, String arg1, String arg2) {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(), isA(List.class));
        List<Object> actualValue = responseBody.get();
        response.then().body(arg1, notNullValue());
        HashMap value = (HashMap) actualValue.get(arg0);
        assertTrue(value.containsKey(arg1));
        assertEquals(value.get(arg1), arg2);
    }

    @Then("^the MS JSON object \\[(\\d+)] should have key \"([^\"]*)\" and value should be array$")
    public void theJSONObjectShouldHaveKeyAndValueShouldBeArray(int arg0, String arg1) {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(), isA(List.class));
        List<Object> actualValue = responseBody.get();
        HashMap value = (HashMap) actualValue.get(arg0);
        response.then().body(arg1, notNullValue());
        assertTrue(value.containsKey(arg1));
        assertThat((List) value.get(arg1), isA(List.class));
    }

    @Then("^the MS JSON array \"([^\"]*)\" in the position (\\d+) should have key \"([^\"]*)\" and value \"([^\"]*)\"$")
    public void theJSONObjectDataPositionShouldHaveKeyAndValue(String array, int arg0, String arg1, String arg2) {
        List<Object> actualValue = getJsonArray(array);
        HashMap value = (HashMap) actualValue.get(arg0);
        response.then().body(array, notNullValue());
        assertTrue(value.containsKey(arg1));
        assertEquals(value.get(arg1), arg2);
    }

    // Expected value comparison from feature File

    @Then("^In the MS JSON array with datatype assertion in response \"([^\"]*)\" in the position (\\d+) should have key \"([^\"]*)\" and value \"([^\"]*)\"$")
    public void theJSONObjectDataDatatypePositionShouldHaveKeyAndValue(String array, int arg0, String arg1,
            String arg2) {
        List<Object> actualValue = getJsonArray(array);
        HashMap value = (HashMap) actualValue.get(arg0);
        response.then().body(array, notNullValue());
        assertTrue(value.containsKey(arg1));
        if (!arg2.equals("")) {
            assertEquals(value.get(arg1), arg2);
        }

        checkType(value.get(arg1));
    }

    // Expected value comparison from Expected Static Text File

    @Then("^In the MS JSON array with expected value assertion from file in response \"([^\"]*)\" in the position (\\d+) should have expected variable key \"([^\"]*)\" and actual property key \"([^\"]*)\" with expected values from file path \"(.*)\"$")
    public void theJSONObjectPositionShouldHaveKeyAndValueExpectedFilePath(String array, int arg0, String expectedKey,
            String key, String expectedFilePath) {
        List<Object> actualValue = getJsonArray(array);
        HashMap value = (HashMap) actualValue.get(arg0);
        response.then().body(array, notNullValue());
        String expectedValue = resuableObject.compareKeyValuesTextFiles(expectedKey, expectedFilePath);
        assertTrue(value.containsKey(key));
        assertEquals("Expected and Actual json property values are equal: ", expectedValue, value.get(key));
        System.out.println("<--- Expected and Actual json property values are equal ---> " + System.lineSeparator()
                + "Expected Value = " + expectedValue);
        checkType(value.get(key));
    }

    // Method to check the Integer datatype of property from the json response

    @Then("^MS JSON response jsonObject Integer property \"([^\"]*)\" datatype check$")
    public void jsonResponseJsonObjectIntegerPropertyDatatypeCheck(String property) throws Throwable {
        int responseBody = JsonPath.from(response.body().asString()).getInt(property);
        response.then().body(property, notNullValue());
        checkType(responseBody);

    }

    // Method to check the String datatype of property from the json response

    @Then("^MS JSON response jsonObject String property \"([^\"]*)\" datatype check$")
    public void jsonResponseJsonObjectStringPropertyDatatypeCheck(String property) throws Throwable {
        String responseBody = JsonPath.from(response.body().asString()).getString(property);
        response.then().body(property, notNullValue());
        checkType(responseBody);

    }

    @Then("^the MS JSON array \"([^\"]*)\" should have an element with key \"([^\"]*)\" and value \"([^\"]*)\"$")
    public void theJSONObjectDataShouldHaveKeyAndValue(String array, String key, String val) {
        response.then().body(array, notNullValue());
        List<String> actualValues = getValuesFromJsonArrayWithKey(key, array);
        assertThat(actualValues, hasItem(val));
    }

    @Then("^the MS JSON array \"([^\"]*)\" should not have an element with key \"([^\"]*)\" and values? \"([^\"]*)\"$")
    public void theJSONObjectDataShouldNotHaveKeyAndValue(String array, String key,
            @Delimiter(":") List<String> values) {
        response.then().body(array, notNullValue());
        List<String> actualValues = getValuesFromJsonArrayWithKey(key, array);
        for (String val : values) {
            assertThat(actualValues, not(hasItem(val)));
        }
    }

    @Then("^the MS JSON array \"([^\"]*)\" should have values? \"([^\"]*)\"$")
    public void theJSONArrayShouldHaveValues(String array, @Delimiter(":") List<String> values) {
        response.then().body(array, notNullValue());
        for (String val : values) {
            assertThat(getJsonArrayValues(array), hasItem(val));
        }
    }

    @Then("^the MS JSON array \"([^\"]*)\" should not have values other than \"([^\"]*)\"$")
    public void theJSONArrayShouldNotHaveValuesOtherThan(String array, @Delimiter(":") List<String> values) {
        response.then().body(array, notNullValue());
        for (String value : getJsonArrayValues(array)) {
            assertThat(value, isIn(values));
        }

    }

    @Then("^store the MS response data from restassured json response \"(.*)\" in keyvalue pair \"(.*)\" from file path \"(.*)\"$")
    public void storeResponsePropertyField(String key, String value, String fileName) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        String propertyKey = responseBody.getString(value);
        resuableObject.storeKeyValues(key, propertyKey, fileName);
    }

    // To store a value from the json array response

    @Then("^store the value from json array MS response in the variable \"(.*)\" taken from keyvalue pair \"(.*)\" under the json array \"(.*)\" to get value of \"(.*)\" from file path \"(.*)\"$")
    public void storeResponsePropField(String key, String value, String jsonValue, String storeValue, String fileName)
            throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        String propertyKey = responseBody.getString(value);
        JSONObject jsonObject = new JSONObject(propertyKey);
        JSONArray tsmresponse = (JSONArray) jsonObject.get(jsonValue);
        String idValue = null;
        for (int i = 0; i < tsmresponse.length(); i++) {
            idValue = tsmresponse.getJSONObject(i).getString(storeValue);
            resuableObject.storeKeyValues(key, idValue, fileName);
        }
    }

    @Then("^fetch the MS response data for rest assured json response \"(.*)\" from file path \"(.*)\"$")
    public void fetchResponsePropertyField(String key, String fileName) throws Throwable {
        scenarioBundleStepDefs.setBundleStringValue(key, resuableObject.fetchKeyValues(key, fileName));
    }

    @Given("^MS request content \"([^\"]*)\" is set with bundle value \"(.*)\"$")
    public void givenRequestBodyBundleValue(String requestKeyName, String bundleValue) throws Throwable {
        String bundleValueStore = scenarioBundleStepDefs.getBundleStringValue(bundleValue);
        this.requestJsonContents = this.requestJsonContents.replace(requestKeyName, bundleValueStore);
        request.body(this.requestJsonContents);
    }

    @Given("^MS response content \"([^\"]*)\" should be an empty array$")
    public void givenRequestEmptyArrayCheck(String jsonPath) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.getList(jsonPath).size(), equalTo(0));
    }

    @Given("^MS response content \"([^\"]*)\" should not be an empty array$")
    public void givenRequestNotEmptyArrayCheck(String jsonPath) throws Throwable {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.getList(jsonPath).size(), greaterThanOrEqualTo(1));
    }

    // fetch the values from json response and update direct dynamic string
    // values in json payload request input file

    @Given("^MS request body key \"(.*)\" is update with dynamic values \"(.*)\" from the json file path \"(.*)\"$")
    public void updateRequestFileDynamicValues(String jsonpath, String dynamicValue, String jsonFilePath) {

        resuableObject.updateRequestFileDynamicValues(jsonpath,
                dynamicValue.replace("{TIMESTAMP}", String.valueOf(System.currentTimeMillis()).replace("}", "")),
                jsonFilePath);

    }

    // Scenario Bundle fetch the values from json response and update dynamic
    // values in json payload request input file

    @Given("^MS request body fetch from scenario bundle key value \"(.*)\" is update with dynamic values \"(.*)\" from the json file path \"(.*)\"$")
    public void updateRequestFileDynamicValuesFromScenarioBundle(String jsonpath, String dynamicValue,
            String jsonFilePath) throws Exception {

        String bundleValueStore = cucumberInteractionSession.scenarioBundle()
                .getString(dynamicValue.replace("{", "").replace("}", ""));

        resuableObject.updateRequestFileDynamicValues(jsonpath, bundleValueStore, jsonFilePath);

        String body = resuableObject.updateRequestFileDynamicValues(jsonpath, bundleValueStore, jsonFilePath);
        System.out.println("Body Values: " + body);

        request.body(body);

    }

    // Scenario Bundle fetch the array values from json response and update
    // dynamic
    // values in json payload request input file

    @Given("^MS request body fetch from scenario bundle key value \"(.*)\" is update with array dynamic values \"(.*)\" from the json file path \"(.*)\"$")
    public void updateRequestFileDynamicArrayValuesFromScenarioBundle(String jsonpath, String dynamicValue,
            String jsonFilePath) throws Exception {

        String bundleValueStore = cucumberInteractionSession.scenarioBundle()
                .getString(dynamicValue.replace("{", "").replace("}", ""));

        resuableObject.updateArrayRequestFileDynamicValues(jsonpath, bundleValueStore, jsonFilePath);

        String body = resuableObject.updateArrayRequestFileDynamicValues(jsonpath, bundleValueStore, jsonFilePath);
        System.out.println("Body Values: " + body);

        request.body(body);

    }

    // Scenario Bundle fetch the array values from json response and update
    // dynamic
    // values with single quotes and back slash removal
    // values in json payload request input file

    @Given("^the MS request body fetch from scenario bundle key value \"(.*)\" is update with array dynamic values \"(.*)\" and property \"(.*)\" from the json file path \"(.*)\"$")
    public void updateRequestFileDynamicArrayValuesFromScenarioBundleJayWayLib(String jsonArraypath,
            String dynamicValue, String property, String jsonFilePath) throws Exception {

        String bundleValueStore = cucumberInteractionSession.scenarioBundle()
                .getString(dynamicValue.replace("{", "").replace("}", ""));

        String body = resuableObject.updateJsonFileContentsJayWayLib(jsonArraypath, property, bundleValueStore,
                jsonFilePath);
        System.out.println("Body Values: " + body);

        request.body(body);

    }

    // Scenario Bundle fetch the array values from json response and update
    // dynamic
    // values with double quotes and back slash
    // values in json payload request input file

    @Given("^the MS request body fetch from scenario bundle key value \"(.*)\" is update with array dynamic values \"(.*)\" and property having doublequotes with backslash value \"(.*)\" from the json file path \"(.*)\"$")
    public void updateRequestFileDynamicArrayValuesFromScenarioBundleJayWayLibFeatures(String jsonArraypath,
            String dynamicValue, String property, String jsonFilePath) throws Exception {

        String bundleValueStore = cucumberInteractionSession.scenarioBundle()
                .getString(dynamicValue.replace("{", "").replace("}", ""));

        String body = resuableObject.updateJsonFileContentsJayWayLibFeatures(jsonArraypath, property, bundleValueStore,
                jsonFilePath);
        System.out.println("Body Values: " + body);

        request.body(body);

    }

    // Scenario Bundle fetch the array values from json response and update
    // dynamic
    // values in json payload request input file without String only plain Array
    // in
    // Json payload file

    @Given("^the MS request body fetch from scenario bundle key value \"(.*)\" is update without string array with dynamic values \"(.*)\" and property \"(.*)\" from the json file path \"(.*)\"$")
    public void updateRequestFileDynamicArrayValuesFromScenarioBundleJayWayLibPlainArray(String jsonArraypath,
            String dynamicValue, String property, String jsonFilePath) throws Exception {

        String bundleValueStore = cucumberInteractionSession.scenarioBundle()
                .getString(dynamicValue.replace("{", "").replace("}", ""));

        String body = resuableObject.updateJsonFileContentsJayWayLibPlainArray(jsonArraypath, property,
                bundleValueStore, jsonFilePath);
        System.out.println("Body Values: " + body);

        request.body(body);
        

    }

    @Then("^MS JSON string parent and child JSON object property \"([^\"]*)\" should equal \"(.+)\"$")
    public void jsonResponseStringJsonParentAndChildPropertyXequalsY(String property, String value) throws Throwable {
        String actualValue = JsonPath.from(response.body().asString()).getString(property);
        response.then().body(property, notNullValue());
        assertEquals(value, actualValue);
    }

    private List<Object> getJsonArray(String array) {
        JsonPath responseBody = JsonPath.from(response.body().asString());
        assertThat(responseBody.get(array), notNullValue());
        return responseBody.get(array);
    }

    private List<String> getJsonArrayValues(String array) {
        return getJsonArray(array).stream().map(object -> Objects.toString(object, null)).collect(Collectors.toList());
    }

    private List<String> getValuesFromJsonArrayWithKey(String key, String array) {
        List<String> values = new ArrayList<>();
        for (Object obj : getJsonArray(array)) {
            Map<String, String> props = (Map<String, String>) obj;
            values.add(props.get(key));
        }
        return values;
    }

    /*
     * Compare values from Feature file fetch list of values from a single json
     * array/object
     */

    @Then("^the MS JSON array \"([^\"]*)\" should have key \"(.*)\" with values \"(.*)\"$")
    public void theJSONArrayShouldHaveValues(String arrayJsonPath, String key, @Delimiter(":") List<String> values) {
        /* Validate given jsonpath is array */
        Iterable<Object> responseBody = JsonPath.from(response.body().asString()).getList(arrayJsonPath);
        assertEquals(true, responseBody instanceof List);
        response.then().body(arrayJsonPath, notNullValue());
        for (String val : values) {
            assertThat(getValuesFromJsonArrayWithKey(key, arrayJsonPath), hasItem(val));
        }

    }

    /*
     * Expected value comparison from Expected Static Text File fetch list of
     * values from a single json array/object
     */

    @Then("^the MS JSON array \"([^\"]*)\" should have expected variable key \"(.*)\" and actualPropertyKey \"(.*)\" with expected values from file path \"(.*)\"$")
    public void theJSONArrayShouldHaveValuesExpectedTxtFilePath(String arrayJsonPath, String expectedKey, String key,
            String expectedFilePath) {
        /* Validate given jsonpath is array */
        Iterable<Object> responseBody = JsonPath.from(response.body().asString()).getList(arrayJsonPath);
        assertEquals(true, responseBody instanceof List);
        response.then().body(arrayJsonPath, notNullValue());

        String expectedValue = resuableObject.compareKeyValuesTextFiles(expectedKey, expectedFilePath);

        String[] expectedSpiltValue = expectedValue.split(":");

        for (String val : expectedSpiltValue) {

            assertThat(getValuesFromJsonArrayWithKey(key, arrayJsonPath), hasItem(val));
        }

    }

    /*
     * Expected value comparison from Expected Static Excel Files fetch list of
     * values from a single json array/object
     */

    @Then("^the MS JSON array \"([^\"]*)\" comparing expected and actual json response values from expected variable key \"(.*)\" with actual property from response \"(.*)\" and sheetindex (\\d+) rownumber (\\d+) and columnnumber (\\d+) from the expected excel file path \"(.*)\"$")
    public void theJSONArrayShouldHaveValuesExpectedExcelFilePath(String arrayJsonPath, String expectedVariableKey,
            String actualPropertyKey, int sheetNumber, int rowNumber, int ColumnNumber, String expectedFilePath) {
        /* Validate given jsonpath is array */
        Iterable<Object> responseBody = JsonPath.from(response.body().asString()).getList(arrayJsonPath);
        assertEquals(true, responseBody instanceof List);
        response.then().body(arrayJsonPath, notNullValue());

        ExcelDataConfig excel = new ExcelDataConfig(expectedFilePath);

        String expectedValue_Excel = excel.getExpectedValueExcelData(sheetNumber, rowNumber, ColumnNumber);

        if (!(expectedValue_Excel == null) && !(expectedVariableKey == null)) {

            String[] expectedSpiltValue = expectedValue_Excel.split(":");

            for (String val : expectedSpiltValue) {

                assertThat(getValuesFromJsonArrayWithKey(actualPropertyKey, arrayJsonPath), hasItem(val));
            }
        }

    }

    // validate multiple array/object values from the response --- validate from
    // feature file

    @Then("^the MS JSON array \"([^\"]*)\" should have key \"([^\"]*)\" with string multiple array values \"([^\"]*)\"$")

    public void theJSONArrayShouldHaveMultipleValues(String arrayJsonPath, String key,
            @Delimiter(":") List<String> values) {
        /* Validate given jsonpath is array */
        JsonPath responseBody = JsonPath.from(response.body().asString());
        Iterable<Object> ItrResponseBody = responseBody.getList(arrayJsonPath);
        assertEquals(true, ItrResponseBody instanceof List);
        response.then().body(arrayJsonPath, notNullValue());

        List<String> respValues = new ArrayList<>();
        for (Object obj : ItrResponseBody) {
            @SuppressWarnings("unchecked")
            Map<String, String> props = (Map<String, String>) obj;
            respValues.add(props.get(key));

            // Datatype also asserted for multiple values in Array List

            checkType(props.get(key));
        }

        /*
         * Check the Assertion values if not equal to "" passing in feature
         * files otherwise if expected value is passed it will assert with
         * Actual value in Response
         */

        if (!values.equals("")) {

            for (String val : values) {

                assertEquals(true, respValues.contains(val));

                for (String assertValue : respValues)

                    if (assertValue.equals(val)) {
                        assertEquals(assertValue, val);
                    }
            }

        }

    }

    @Given("^the MS request body key \"(.*)\" is update with dynamic values \"(.*)\" with uniqueId value \"(.*)\" from the json file path \"(.*)\"$")
    public void updateRequestFileDynamicValuesConcatWithUniqueId(String jsonpath, String ValueTobeUpdate, String uniqID,
            String jsonFilePath) {

        String uniqueId = cucumberInteractionSession.scenarioBundle().getString(uniqID);

        String valueConcat = ValueTobeUpdate.concat(uniqueId);

        resuableObject.updateRequestFileDynamicValues(jsonpath, valueConcat, jsonFilePath);

    }

    @Given("^the MS request body key \"(.*)\" is update with dynamic values with next increment business days value \"(.*)\" from the json file path \"(.*)\"$")
    public void updateRequestFileDynamicValuesUpdateWithBusinessDaysIncrement(String jsonpath,
            String businessDaysIncrement, String jsonFilePath) {

        String dateIncrement = cucumberInteractionSession.scenarioBundle().getString(businessDaysIncrement);
        int i = 1;
        i++;
        String dateAfterIncrementOne = String.valueOf(Integer.parseInt(dateIncrement) + i);

        StringBuilder StartDateBuilder = new StringBuilder(dateAfterIncrementOne);
        StartDateBuilder.insert(4, '-');
        StartDateBuilder.insert(7, '-');

        String modifiedDateWithHyphen = StartDateBuilder.toString();

        resuableObject.updateRequestFileDynamicValues(jsonpath, modifiedDateWithHyphen, jsonFilePath);

    }

    @Then("^MS JSON response string property key \"([^\"]*)\" should equal value \"([^\"]*)\"$")
    public void jsonResponseStringPropertyXEqualsValueZ(String property, String value) throws Throwable {
        String actualValue = JsonPath.from(response.body().asString()).getString(property);
        assertEquals(value, actualValue);
    }
    
    @Then("^MS JSON response string property key \"([^\"]*)\" should contain value \"([^\"]*)\"$")
    public void jsonResponseStringPropertyXContainsValueZ(String property, String value) throws Throwable {
        String actualValue = JsonPath.from(response.body().asString()).getString(property);
        assertThat(actualValue, containsString(value));
    }

    // ENABLE for TXT - Expected and actual values comparison.

    @Then("^Compare the Expected and Actual json MS response values passing expectedKey \"(.*)\" and actualPropertyKeyValue is \"(.*)\" from the expected file path \"(.*)\"$")
    public void compareExpectedAndActualValuesPropertyXPropertyYFiles(String expectedKey, String actualPropertyKeyValue,
            String expectedFilePath) throws Throwable {

        JsonPath responseBody = JsonPath.from(response.body().asString());
        response.then().body(actualPropertyKeyValue, notNullValue());
        String actualValue = responseBody.getString(actualPropertyKeyValue);

        String expectedValue = resuableObject.compareKeyValuesTextFiles(expectedKey, expectedFilePath);
        assertEquals("Expected and Actual json property values are equal from txt file: ", expectedValue, actualValue);
        System.out.println("<--- Expected and Actual json property values are equal from txt file ---> "
                + System.lineSeparator() + "Expected Value = " + expectedValue);

    }

    // Excel Expected and Actual String values comparison based on expected
    // variable
    // key ---

    @Then("^Compare the Expected and Actual JSON response values from expected variable key \"(.*)\" with actual property from response \"(.*)\" and sheetindex (\\d+) rownumber (\\d+) and columnnumber (\\d+) from the expected excel file path \"(.*)\"$")
    public void compareExpectedAndActualValuesPropertyXPropertyYExcelFile(String expectedVariableKey,
            String actualPropertyKey, int sheetNumber, int rowNumber, int ColumnNumber, String expectedFilePath)
            throws Throwable {

        JsonPath responseBody = JsonPath.from(response.body().asString());
        response.then().body(actualPropertyKey, notNullValue());
        String actualValue = responseBody.getString(actualPropertyKey);

        ExcelDataConfig excel = new ExcelDataConfig(expectedFilePath);

        String expectedValue_Excel = excel.getExpectedValueExcelData(sheetNumber, rowNumber, ColumnNumber);

        if (!(expectedValue_Excel == null) && !(expectedVariableKey == null)) {

            assertEquals("Expected and Actual json property values are equal from excel file : ", expectedValue_Excel,
                    actualValue);
            System.out.println("<--- Expected and Actual json property values are equal from excel file ---> "
                    + System.lineSeparator() + "Expected Value = " + expectedValue_Excel);

        }

    }

    @Then("^Clear all the expected MS JSON values from file path \"(.*)\"$")
    public void clearExpectedValuesPropertyFile(String expectedFilePath) throws Throwable {
        resuableObject.removeExpectedValuesPropertyFile(expectedFilePath);
    }    

    @Then("^the MS JSON array root path key \"(.*)\" should contains the string value \"(.*)\"$")
        public void theJSONObjectDataShouldHaveKeyContainsValue(String arrayKey, String Containsvalue) {
            response.then().body(arrayKey, Every.everyItem(Matchers.containsString(Containsvalue)));       
           
        }



    // To get the UTC time and store in the request payload

    @Given("^the MS request body key \"(.*)\" is update with dynamic values \"(.*)\" with current system date and time \"(.*)\" from the json file path \"(.*)\"$")
    public void updateRequestFileSystemDate(String jsonpath, String ValueTobeUpdate, String dateTime,
            String jsonFilePath) {
        OffsetDateTime value = OffsetDateTime.now(ZoneId.of("UTC"));
        dateTime = value.toString();
        String valueConcat = ValueTobeUpdate.concat(dateTime);
        resuableObject.updateRequestFileDynamicValues(jsonpath, valueConcat, jsonFilePath);
    }

    // To compare full response with file content

     @Then("^check full response with expected json content from file path \"(.*)\"$")
     public void fullResponseAssertionWithJSONFile(String
     expectedJSONFilePath) throws Throwable {
     String actualJSONResponse = response.asString();
    
     File expectedResponsefile = new File(expectedJSONFilePath);
    
     String expectedResponse = IOUtils.toString(new
     FileInputStream(System.getProperty("user.dir") + "/" +
     expectedJSONFilePath));
    
    
     System.out.println(expectedResponse);
     //Lenient mode will ignore any missing fields in JSON
     //JSONAssert.assertEquals(expected, data, false);
     assertThat(actualJSONResponse,sameJSONAs(expectedResponse).allowingExtraUnexpectedFields().allowingAnyArrayOrdering());
    
     }
     
     //To check if response complies with the JSON schema
//     @Then("^check if response complies with schema from file path \"(.*)\"$")
//     public void checkResponseMatchesSchema(String schemaPath) throws Throwable {
//    
//     File poSchema = new File(schemaPath);
//     
//     System.out.println("Schema is: "+poSchema.toString());
//     System.out.println("response :"+response.body().asString());
//     response.then().body(matchesJsonSchema(poSchema));
//    
//     }
     
     @Then("^upload document with key \"(.*)\" from file path \"(.*)\"$")
     public void uploadFile(String controlName, String filePath) throws Throwable {
         
     File fileToBeUploaded = new File(System.getProperty("user.dir") + "/" +filePath);
     request = request.multiPart(controlName, fileToBeUploaded);
    
     }
     
     @Then("^check if file download is successful and size is equal to file uploaded from file path \"(.*)\"$")
     public void verifyFileDownload(String uploadedFilePath) throws Exception  {
         
         int uploadedFileSize;
         File uploadedFile =  new File (System.getProperty("user.dir")+ "/" +uploadedFilePath);
         
         uploadedFileSize = (int)uploadedFile.length();
         
         byte[] downloadedFile = response.asByteArray();
          //assertEquals(fileSize, downloadedFile.length);
         if(uploadedFileSize==downloadedFile.length)
         {
             System.out.println("File download is successful and file size is same");
         }
         else{
             
             System.out.println("The uploaded file length is: "+uploadedFileSize);
             System.out.println("---------------------------------------");
             System.out.println("The downloaded file length is: "+downloadedFile.length);
             throw new Exception("Mismatch in downloaded file size/content or download did not happen correctly");
         }
        }

    private <T extends Object> void checkType(T object) {
        if (object instanceof Integer)
            System.out.println("Response value type is Integer ");
        else if (object instanceof Double)
            System.out.println("Response value type is Double ");
        else if (object instanceof Float)
            System.out.println("Response value type is Float : ");
        else if (object instanceof List)
            System.out.println("Response value type is List! ");
        else if (object instanceof Set)
            System.out.println("Response value type is Set! ");
        else if (object instanceof String)
            System.out.println("Response value type is String! ");
        else if (object instanceof Number)
            System.out.println("Response value type is Number! ");
    }

    public void initialize(String authEnvVariable) {

        if (Environment.getEnvironmentVariable("CLOUDENV", "").equalsIgnoreCase("AZURE")) {

            System.out.println(" Inside Initialise" + Environment.getEnvironmentVariable(authEnvVariable, ""));
            this.authCodeVariable = "&code=" + Environment.getEnvironmentVariable(authEnvVariable, "");
            // cucumberInteractionSession.queryParam("code="+Environment.getEnvironmentVariable(authEnvVariable,
            // ""));
        }

        // To pass api key as header while sending the request if platform is
        // AWS
        String apiKey = System.getProperty("API_KEY");
        if (apiKey != null) {
            request.header("x-api-Key", apiKey);
        }
    }

    public void setQueryParamsAzure(String queryParams) {
        if (queryParams.startsWith("&")) {
            queryParams = queryParams.substring(1);
        }
        System.out.println(queryParams);
        cucumberInteractionSession.queryParam(queryParams);
        System.out.println(this.cucumberInteractionSession.url());
    }

}
