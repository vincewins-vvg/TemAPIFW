package com.temenos.microservice.test;

import com.temenos.microservice.test.util.ApiUnderTest;

import java.net.Inet4Address;

public class TestCase {
    protected String testCaseID = null;
    protected String hostName = null;
    protected String t24Payload = null;
    protected String companyID = null;
    protected final ApiUnderTest API_UNDER_TEST;

    public TestCase(String testCaseID,String apiUnderTest) throws Exception {
        hostName = Inet4Address.getLocalHost().getHostName();
        this.testCaseID = testCaseID;
        this.API_UNDER_TEST = ApiUnderTest.from(apiUnderTest);
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

    public void setHostName(String hostName) {
        this.hostName = hostName;
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

    public String getTestCaseIDWithHostName() {
        return hostName + ":" + testCaseID;
    }


}
