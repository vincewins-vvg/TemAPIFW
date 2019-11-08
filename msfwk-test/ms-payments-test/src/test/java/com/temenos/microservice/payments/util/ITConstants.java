package com.temenos.microservice.payments.util;

/**
 * TODO: Document me!
 *
 * @author vinods
 *
 */
public class ITConstants {
	public static final String API_KEY = "x-api-key";
	public static final String BASE_URI = "http://localhost:8090/ms-paymentorder-api/api";
	public static final String JSON_BODY_TO_INSERT = "{\"fromAccount\":\"123\",\"toAccount\":\"124\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"PayDetails\",\"currency\":\"USD\",\"amount\":100,\"expires\":0,\"paymentMethod\":{\"id\":1,\"name\":\"DEBIT\",\"card\":{\"cardid\":132,\"cardname\":\"DEBITCARD\",\"cardlimit\":5000}},\"exchangeRates\":[{\"id\":10,\"name\":\"Rate1\",\"value\":45.7},{\"id\":20,\"name\":\"Rate1\",\"value\":54.32}],\"descriptions\":[\"TEST\"]}";
	public static final String JSON_BODY_TO_UPDATE = "{\"debitAccount\":\"123\",\"paymentId\":\"PO~123~124~USD~100\",\"status\":\"INITIATED1\",\"details\":\"PayDetailsModified\",\"paymentMethod\":{\"id\":1,\"name\":\"new1\",\"card\":{\"cardid\":123,\"cardname\":\"CREDITCARD\",\"cardlimit\":5000.67}},\"exchangeRates\":[{\"id\":1,\"name\":\"new2\",\"value\":45.67},{\"id\":2,\"name\":\"new3\",\"value\":54.32}]}";
}