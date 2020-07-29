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
	public static final String JSON_BODY_TO_INSERT = "{\"fromAccount\":\"123\",\"toAccount\":\"124\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"refDet\",\"currency\":\"USD\",\"expires\":1,\"extensionData\":{\"array_BusDayCentres\":[\"India\",\"Aus\"],\"paymentOrderProduct\":\"Temenos\",\"array_NonOspiType\":[{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"UPI\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"3163\"}]},\"amount\":100,\"paymentMethod\":{\"id\":1,\"name\":\"paymentmethod\",\"card\":{\"cardid\":1,\"cardname\":\"allwin\",\"cardlimit\":1}},\"exchangeRates\":[{\"id\":1,\"name\":\"allwin\",\"value\":1}],\"payeeDetails\":{\"payeeName\":\"paydetail\",\"payeeType\":\"visa\"},\"descriptions\":[\"data\"]}";
	public static final String JSON_BODY_TO_INSERT_INVALIDPARAM = "{\"fromAccount\":\"123\",\"toAccount\":\"124\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"PayDetails\",\"currency\":\"INR\",\"amount\":100,\"expires\":0,\"paymentMethod\":{\"id\":1,\"name\":\"DEBIT\",\"card\":{\"cardid\":132,\"cardname\":\"DEBITCARD\",\"cardlimit\":5000}},\"exchangeRates\":[{\"id\":10,\"name\":\"Rate1\",\"value\":45.7},{\"id\":20,\"name\":\"Rate1\",\"value\":54.32}],\"descriptions\":[\"TEST\"]}";
	public static final String JSON_BODY_TO_INSERT_WRONG = "{\"fromAccount\":\"123\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"PayDetails\",\"currency\":\"USD\",\"amount\":100,\"expires\":0,\"paymentMethod\":{\"id\":1,\"name\":\"DEBIT\",\"card\":{\"cardid\":132,\"cardname\":\"DEBITCARD\",\"cardlimit\":5000}},\"exchangeRates\":[{\"id\":10,\"name\":\"Rate1\",\"value\":45.7},{\"id\":20,\"name\":\"Rate1\",\"value\":54.32}],\"descriptions\":[\"TEST\"]}";
	public static final String JSON_BODY_TO_UPDATE = "{\"debitAccount\":\"123\",\"paymentId\":\"PO~123~124~USD~100\",\"status\":\"INITIATED1\",\"details\":\"PayDetailsModified\",\"paymentMethod\":{\"id\":1,\"name\":\"new1\",\"card\":{\"cardid\":123,\"cardname\":\"CREDITCARD\",\"cardlimit\":5000.67}},\"exchangeRates\":[{\"id\":1,\"name\":\"new2\",\"value\":45.67},{\"id\":2,\"name\":\"new3\",\"value\":54.32}]}";
	public static final String JSON_BODY_TO_FILEUPLOAD = "{\r\n" + "  \"documentId\": \"78945\",\r\n"
			+ "  \"documentName\": \"applicationcontext\"\r\n" + "}";

	public static final String JWT_TOKEN_HEADER_NAME = "Authorization";
	public static final String JWT_TOKEN_HEADER_VALUE = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw";
}