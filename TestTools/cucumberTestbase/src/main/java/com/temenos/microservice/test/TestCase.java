package com.temenos.microservice.test;

import com.temenos.microservice.test.util.ApiUnderTest;


import java.net.Inet4Address;
import java.util.Optional;

public class TestCase {
    protected String testCaseID = null;
    protected String t24Payload = null;
    protected String companyID = null;
    protected final ApiUnderTest API_UNDER_TEST;

    public TestCase(String testCaseID,String apiUnderTest) throws Exception {
        this.testCaseID = testCaseID;
        this.API_UNDER_TEST = Optional.ofNullable(ApiUnderTest.from(apiUnderTest))
                .orElse(ApiUnderTest.DUMMY_API);
    }

    public ApiUnderTest getApiUnderTest() {
        return API_UNDER_TEST;
    }

    public String getCompanyID() {
        return companyID;
    }

    public void setCompanyID(String companyID) {
        this.companyID = companyID;
    }

    public void setTestCaseID(String testCaseID) {
        this.testCaseID = testCaseID;
    }


    public String getT24Payload() {
        return t24Payload;
    }

    public void setT24Payload(String t24Payload) {
        this.t24Payload = t24Payload;
    }


    public String getTestCaseID() {
        return testCaseID;

    }




}
