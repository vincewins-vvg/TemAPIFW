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
	public static final String JSON_BODY_TO_INSERT = "{\"fromAccount\":\"123\",\"toAccount\":\"124\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"refDet\",\"currency\":\"USD\",\"expires\":1,\"extensionData\":{\"array_BusDayCentres\":[\"India\",\"Aus\"],\"paymentOrderProduct\":\"Temenos\",\"array_NonOspiType\":[{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"UPI\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"3163\"}]},\"amount\":100,\"paymentMethod\":{\"id\":100,\"name\":\"cashpayment\",\"card\":{\"cardid\":1,\"cardname\":\"allwin\",\"cardlimit\":1}},\"exchangeRates\":[{\"id\":1,\"name\":\"allwin\",\"value\":1}],\"payeeDetails\":{\"payeeName\":\"paydetail\",\"payeeType\":\"visa\"},\"descriptions\":[\"data\"]}";
	public static final String JSON_BODY_TO_INSERT_INVALIDPARAM = "{\"fromAccount\":\"123\",\"toAccount\":\"124\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"PayDetails\",\"currency\":\"INR\",\"amount\":100,\"expires\":0,\"paymentMethod\":{\"id\":1,\"name\":\"DEBIT\",\"card\":{\"cardid\":132,\"cardname\":\"DEBITCARD\",\"cardlimit\":5000}},\"exchangeRates\":[{\"id\":10,\"name\":\"Rate1\",\"value\":45.7},{\"id\":20,\"name\":\"Rate1\",\"value\":54.32}],\"descriptions\":[\"TEST\"]}";
	public static final String JSON_BODY_TO_INSERT_WRONG = "{\"fromAccount\":\"123\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"PayDetails\",\"currency\":\"USD\",\"amount\":100,\"expires\":0,\"paymentMethod\":{\"id\":101,\"name\":\"DEBIPAYMENT\",\"card\":{\"cardid\":132,\"cardname\":\"DEBITCARD\",\"cardlimit\":5000}},\"exchangeRates\":[{\"id\":10,\"name\":\"Rate1\",\"value\":45.7},{\"id\":20,\"name\":\"Rate1\",\"value\":54.32}],\"descriptions\":[\"TEST\"]}";
	public static final String JSON_BODY_TO_UPDATE = "{\"debitAccount\":\"123\",\"paymentId\":\"PO~123~124~USD~100\",\"status\":\"INITIATED1\",\"details\":\"PayDetailsModified\",\"paymentMethod\":{\"id\":1,\"name\":\"new1\",\"card\":{\"cardid\":123,\"cardname\":\"CREDITCARD\",\"cardlimit\":5000.67}},\"exchangeRates\":[{\"id\":1,\"name\":\"new2\",\"value\":45.67},{\"id\":2,\"name\":\"new3\",\"value\":54.32}]}";
	public static final String JSON_BODY_TO_FILEUPLOAD = "{\r\n" + "  \"documentId\": \"78945\",\r\n" + "  \"documentName\": \"applicationcontext\"\r\n" + "}";
	public static final String JSON_BODY_TO_VALIDATE_MIN = "{\"fromAccount\":\"123\",\"toAccount\":\"124\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"refDet\",\"currency\":\"USD\",\"expires\":1,\"extensionData\":{\"array_BusDayCentres\":[\"India\",\"Aus\"],\"paymentOrderProduct\":\"Temenos\",\"array_NonOspiType\":[{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"UPI\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"3163\"}]},\"amount\":100,\"paymentMethod\":{\"id\":0,\"name\":\"cashpayment\",\"card\":{\"cardid\":1,\"cardname\":\"allwin\",\"cardlimit\":1}},\"exchangeRates\":[{\"id\":1,\"name\":\"allwin\",\"value\":1}],\"payeeDetails\":{\"payeeName\":\"paydetail\",\"payeeType\":\"visa\"},\"descriptions\":[\"data\"]}";
	public static final String JSON_BODY_TO_VALIDATE_MAX = "{\"fromAccount\":\"123\",\"toAccount\":\"124\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"refDet\",\"currency\":\"USD\",\"expires\":1,\"extensionData\":{\"array_BusDayCentres\":[\"India\",\"Aus\"],\"paymentOrderProduct\":\"Temenos\",\"array_NonOspiType\":[{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"UPI\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"3163\"}]},\"amount\":100,\"paymentMethod\":{\"id\":1999999,\"name\":\"cashpayment\",\"card\":{\"cardid\":1,\"cardname\":\"allwin\",\"cardlimit\":1}},\"exchangeRates\":[{\"id\":1,\"name\":\"allwin\",\"value\":1}],\"payeeDetails\":{\"payeeName\":\"paydetail\",\"payeeType\":\"visa\"},\"descriptions\":[\"data\"]}";
	public static final String JSON_BODY_TO_VALIDATE_MINLENGTH = "{\"fromAccount\":\"123\",\"toAccount\":\"124\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"refDet\",\"currency\":\"USD\",\"expires\":1,\"extensionData\":{\"array_BusDayCentres\":[\"India\",\"Aus\"],\"paymentOrderProduct\":\"Temenos\",\"array_NonOspiType\":[{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"UPI\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"3163\"}]},\"amount\":100,\"paymentMethod\":{\"id\":100,\"name\":\"c\",\"card\":{\"cardid\":1,\"cardname\":\"allwin\",\"cardlimit\":1}},\"exchangeRates\":[{\"id\":1,\"name\":\"allwin\",\"value\":1}],\"payeeDetails\":{\"payeeName\":\"paydetail\",\"payeeType\":\"visa\"},\"descriptions\":[\"data\"]}";
	public static final String JSON_BODY_TO_VALIDATE_MAXLENGTH = "{\"fromAccount\":\"123\",\"toAccount\":\"124\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"refDet\",\"currency\":\"USD\",\"expires\":1,\"extensionData\":{\"array_BusDayCentres\":[\"India\",\"Aus\"],\"paymentOrderProduct\":\"Temenos\",\"array_NonOspiType\":[{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"UPI\",\"NonOspiId\":\"12456\"},{\"NonOspiType\":\"DebitCard\",\"NonOspiId\":\"3163\"}]},\"amount\":100,\"paymentMethod\":{\"id\":100,\"name\":\"paymentmethodpaymentMethod\",\"card\":{\"cardid\":1,\"cardname\":\"allwin\",\"cardlimit\":1}},\"exchangeRates\":[{\"id\":1,\"name\":\"allwin\",\"value\":1}],\"payeeDetails\":{\"payeeName\":\"paydetail\",\"payeeType\":\"visa\"},\"descriptions\":[\"data\"]}";
	public static final String JSON_BODY_TO_VALIDATE_NULLABLE = "{\"fromAccount\":\"123\",\"toAccount\":\"124\",\"paymentReference\":\"PayRef\",\"paymentDetails\":\"refDet\",\"currency\":\"USD\",\"expires\":1,\"amount\":100,\"paymentMethod\":null,\"exchangeRates\":[{\"id\":1,\"name\":\"allwin\",\"value\":1}],\"payeeDetails\":{\"payeeName\":\"paydetail\",\"payeeType\":\"visa\"},\"descriptions\":[\"data\"]}";	
	public static final String JSON_BODY_TO_VALIDATE_DATATYPES = "{\"paymentId\":22,\"personalAccNo\":32,\"branchId\":14,\"monthCount\":8,\"penaltyInterest\":6.4,\"yearWiseInterest\":56.0,\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"paymentDate\":1500658348000,\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"seniorCitizen\":false,\"paymentOrders\":[{\"fileOverWrite\":false,\"paymentMethod\":{\"id\":33,\"name\":\"Card\"}}],\"currency\":\"USD\",\"extensionData\":{\"id\":\"43\"},\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33}}";
	public static final String JSON_BODY_TO_VALIDATE_USERDEFINED_NULL = "{\"paymentId\":22,\"personalAccNo\":32,\"branchId\":14,\"monthCount\":8,\"penaltyInterest\":6.4,\"yearWiseInterest\":56,\"currency\": \"USD\",\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"paymentDate\":\"2017-07-21T17:32:28Z\",\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"paymentOrders\":[{\"paymentMethod\":{\"name\":\"Card\",\"id\":33}}],\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33}}";
	public static final String JSON_BODY_TO_VALIDATE_OBJECT_NULL = "{\"paymentId\":22,\"personalAccNo\":32,\"branchId\":14,\"monthCount\":8,\"penaltyInterest\":6.4,\"yearWiseInterest\":56,\"currency\": \"USD\",\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"paymentDate\":\"2017-07-21T17:32:28Z\",\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"paymentOrders\":[{\"paymentMethod\":{\"name\":\"Card\",\"id\":33}}],\"extensionData\":{\"id\":\"43\"}}";
	public static final String JSON_BODY_TO_VALIDATE_ARRAY_NULL = "{\"paymentId\":22,\"personalAccNo\":32,\"branchId\":14,\"monthCount\":8,\"penaltyInterest\":6.4,\"yearWiseInterest\":56,\"currency\": \"USD\",\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"paymentDate\":\"2017-07-21T17:32:28Z\",\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33},\"extensionData\":{\"id\":\"43\"}}";
	public static final String JSON_BODY_TO_VALIDATE_ENUM_NULL = "{\"paymentId\":22,\"personalAccNo\":32,\"branchId\":14,\"monthCount\":8,\"penaltyInterest\":6.4,\"yearWiseInterest\":56,\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"paymentDate\":\"2017-07-21T17:32:28Z\",\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"paymentOrders\":[{\"paymentMethod\":{\"name\":\"Card\",\"id\":33}}],\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33},\"extensionData\":{\"id\":\"43\"}}";
	public static final String JSON_BODY_TO_VALIDATE_TIMESTAMP_NULL = "{\"paymentId\":22,\"personalAccNo\":32,\"branchId\":14,\"monthCount\":8,\"penaltyInterest\":6.4,\"yearWiseInterest\":56,\"currency\": \"USD\",\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"paymentOrders\":[{\"paymentMethod\":{\"name\":\"Card\",\"id\":33}}],\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33},\"extensionData\":{\"id\":\"43\"}}";
	public static final String JSON_BODY_TO_VALIDATE_UUID_NULL = "{\"paymentId\":22,\"personalAccNo\":32,\"branchId\":14,\"monthCount\":8,\"penaltyInterest\":6.4,\"yearWiseInterest\":56.0,\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"paymentDate\":1500658348000,\"actualDate\":\"2017-07-21\",\"seniorCitizen\":false,\"paymentOrders\":[{\"fileOverWrite\":false,\"paymentMethod\":{\"id\":33,\"name\":\"Card\"}}],\"currency\":\"USD\",\"extensionData\":{\"id\":\"43\"},\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33}}";
	public static final String JSON_BODY_TO_VALIDATE_BYTEBUFFER_NULL = "{\"paymentId\":22,\"personalAccNo\":32,\"branchId\":14,\"monthCount\":8,\"penaltyInterest\":6.4,\"yearWiseInterest\":56.0,\"userIdenfication\":88,\"paymentMethod\":\"card\",\"paymentDate\":1500658348000,\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"seniorCitizen\":false,\"paymentOrders\":[{\"fileOverWrite\":false,\"paymentMethod\":{\"id\":33,\"name\":\"Card\"}}],\"currency\":\"USD\",\"extensionData\":{\"id\":\"43\"},\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33}}";
	public static final String JSON_BODY_TO_VALIDATE_NUMBER_NULL = "{\"personalAccNo\":32,\"penaltyInterest\":6.4,\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"paymentDate\":\"2017-07-21T17:32:28Z\",\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\", \"paymentOrders\":[{\"paymentMethod\":{\"name\":\"Card\",\"id\":33}}],\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33},\"extensionData\":{\"id\":\"43\"},\"currency\": \"USD\"}";
	public static final String JSON_BODY_TO_VALIDATE_NUMBER_MIN = "{\"paymentId\":3,\"personalAccNo\":3,\"branchId\":3,\"monthCount\":8,\"penaltyInterest\":3,\"yearWiseInterest\":0,\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"paymentDate\":\"2017-07-21T17:32:28Z\",\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"paymentOrders\":[{\"paymentMethod\":{\"name\":\"Card\",\"id\":33}}],\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33},\"extensionData\":{\"id\":\"43\"},\"currency\": \"USD\"}";
	public static final String JSON_BODY_TO_VALIDATE_NUMBER_MAX = "{\"paymentId\":22,\"personalAccNo\":52,\"branchId\":54,\"monthCount\":8,\"penaltyInterest\":60,\"yearWiseInterest\":76,\"userIdenfication\":88,\"paymentMethod\":\"card\",\"fileReadWrite\":\"file\",\"paymentDate\":\"2017-07-21T17:32:28Z\",\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"paymentOrders\":[{\"paymentMethod\":{\"name\":\"Card\",\"id\":33}}],\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33},\"extensionData\":{\"id\":\"43\"},\"currency\": \"USD\"}";
	public static final String JSON_BODY_TO_VALIDATE_STRING_NULL = "{\"paymentId\":22,\"personalAccNo\":32,\"branchId\":14,\"monthCount\":8,\"penaltyInterest\":6.4,\"yearWiseInterest\":56.0,\"userIdenfication\":88,\"fileReadWrite\":\"file\",\"paymentDate\":1500658348000,\"actualDate\":\"2017-07-21\",\"socialSecurityNo\":\"046b6c7f-0b8a-43b9-b35d-6489e6daee91\",\"seniorCitizen\":false,\"paymentOrders\":[{\"fileOverWrite\":false,\"paymentMethod\":{\"id\":33,\"name\":\"Card\"}}],\"currency\":\"USD\",\"extensionData\":{\"id\":\"43\"},\"paymentOrdersItems\":{\"name\":\"Card\",\"id\":33}}";
	
}