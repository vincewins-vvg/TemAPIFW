package com.temenos.microservice.payments.cucumber;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * T24 Test Runner for Cucumber Microservices tests
 *
 * 
 */
@RunWith(Cucumber.class)
@CucumberOptions(junit = "--no-step-notifications", features = { "cucumber-test-scripts/" }, glue = { "cucumber.api.spring",
				"com.temenos.useragent.cucumber.steps", "com.temenos.interaction.cucumber.stepdefs",
				"com.temenos.microservice.payments.cucumber",
				"com.temenos.microservice.cucumber.t24datastepdefinitions" }, format = { "pretty",
						"html:target/cucumber", "json:target/cucumber/cucumber.json" })

public class MSRunnnerITTest {

	@BeforeClass
	public static void beforeSuite() {
	}

	@AfterClass
	public static void afterSuite() {
	}
}