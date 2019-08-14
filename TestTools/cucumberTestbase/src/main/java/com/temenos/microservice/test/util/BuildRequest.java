package com.temenos.microservice.test.util;

import com.temenos.microservice.framework.core.conf.Environment;
import io.restassured.RestAssured;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.config.HttpClientConfig;
import io.restassured.config.RestAssuredConfig;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import io.restassured.response.ResponseBody;
import io.restassured.specification.RequestSpecification;
import org.apache.http.params.CoreConnectionPNames;

import java.util.LinkedHashMap;
import java.util.Map;

public class BuildRequest {

    private ApiUnderTest apiUndertest;
    private Map<String, Object> queryParams = new LinkedHashMap<String, Object>();
    private String baseUrl;
    private String bodyMessage;
    RequestSpecBuilder requestSpecBuilder = new RequestSpecBuilder();
    RestAssuredConfig restAssuredConfig;
    Response response;

    public BuildRequest(ApiUnderTest apiUnderTest) {
        this.apiUndertest = apiUnderTest;
        restAssuredConfig = RestAssured.config()
                .httpClient(HttpClientConfig.httpClientConfig()
                        .setParam(CoreConnectionPNames.CONNECTION_TIMEOUT, 60000)
                        .setParam(CoreConnectionPNames.SO_TIMEOUT, 60000));
    }

    public String getURL() {
        return null;
    }

    public void addHeader(String header, String value) {
        requestSpecBuilder.addHeader(header, value);
    }

    public void addQueryParam(String key, Object value) {
        queryParams.put(key, value);
    }

    private boolean isAzureEnv() {
        return Environment.getEnvironmentVariable
                ("CLOUDENV", "").equalsIgnoreCase("AZURE");
    }

    private void formBaseURL() {
        switch (apiUndertest.getName()) {
            case "CALL_BACK_REGISTRY":
                baseUrl = getCallBKRegistryURL();
                System.out.println(baseUrl);
                break;
            default:
                baseUrl = null;
        }

    }

    public void setBodyMessage(String bodyMessage) {
        this.bodyMessage = bodyMessage;
    }

    private String getCallBKRegistryURL() {
        return Environment.getEnvironmentVariable("API_BASE_URL", "")
                .equalsIgnoreCase("") ?
                "http://localhost:8085/ms-callbackregistry-api/api/v1.0.0/callbackregistry/callbacks" :
                Environment.getEnvironmentVariable("API_BASE_URL", "") +
                        "/v1.0.0/callbackregistry/callbacks";
    }

    public void buildRequest() {
        if (isAzureEnv()) putAzureToken();
        if (Environment.getEnvironmentVariable("API_KEY", null) != null) {
            addHeader("x-api-key", Environment.getEnvironmentVariable("API_KEY", null));
            System.out.println("Header Added");
        }
        formBaseURL();
        requestSpecBuilder.setBaseUri(baseUrl)
                .addParams(queryParams)
                .addHeader("Content-Type","application/json")
                .setBody(bodyMessage);
    }

    public void sendRequest() throws Exception {
        RequestSpecification httpRequest = RestAssured.given().config(restAssuredConfig);
        response = httpRequest.spec(requestSpecBuilder.build())
                .post();
        if (response.statusCode() != 200) {
            throw new Exception("Error Response code " + response.statusCode());
        }
        System.out.println(response);

    }

    private void putAzureToken() {
        switch (apiUndertest.getName()) {
            case "CALL_BACK_REGISTRY":
                addQueryParam("code", Environment.getEnvironmentVariable("callbacks", ""));
        }
    }

}
