#Author: sabapathy, update by Sai Kushaal K
Feature: PayloadKeyNull MSF-2181 

Background: To setup the preconfigs 

	Given Set the test backgound for PAYMENT_ORDER API 
	And MS query parameter for Azure env is set to value "" 
	And MS request URI is "v1.0.0/payments/orders" 
	And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
Scenario Outline: Create a new Payment Order with Null value for JSON-Data,Object,Nested-Object and Array 

	And post the static MS JSON as payload <payload> 
	And MS query parameter for Azure env is set to value "" 
	And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	When a "POST" request is sent to MS 
	Then MS response code should be 200 
	
	Examples: 
	
		|payload|
		|{"fromAccount":"101","toAccount":"112","paymentReference":"paytest","paymentDetails":null,"currency":"USD","amount":10,"expires":0,"fileContent":"TEST","paymentMethod":{"id":1,"name":"ONLINE_TXN","card":{"cardid":1,"cardname":null,"cardlimit":10}},"exchangeRates":[{"id":11,"name":null,"value":10},{"id":12,"name":"WesternUnion","value":10}],"payeeDetails":{"payeeName":"bsnl","payeeType":null},"descriptions":[null]}|
		
		
Scenario Outline: Create a new Payment Order with Null value for Amount (i.e XACML Policy-Validation Applicable) 

	And post the static MS JSON as payload <payload> 
	And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	When a "POST" request is sent to MS 
	Then MS response code should be 401 
	
	Examples: 
	
		|payload|
		|{"fromAccount":"201","toAccount":"202","paymentReference":"paytest","paymentDetails":"paymentDetails_TEST","currency":"USD","amount":null,"expires":0,"fileContent":"TEST","paymentMethod":{"id":1,"name":"ONLINE_TXN","card":{"cardid":1,"cardname":"HDFC","cardlimit":10}},"exchangeRates":[{"id":1,"name":"MoneyExchange","value":10}],"payeeDetails":{"payeeName":"bsnl","payeeType":"ONLINE"},"descriptions":[]}|
		
		
Scenario: To get PO with Null value for JSON-Data,Object,Nested-Object and Array 

	Given create a new MS request with code using Restassured arguments "" 
	And MS request URI is "v1.0.0/payments/orders/PO~101~102~USD~10" 
	
	And create a new MS request with code using Restassured arguments "GET_PAYMENTODER_AUTH_CODE" 
	And MS request header "serviceid" is set to "client" 
	And MS request header "channelid" is set to "web" 
	And MS request header "customfilterid" is set to "test" 
	
	When a "GET" request is sent to MS 
	Then MS response code should be 200 
	Then MS JSON property "paymentDetails" should not exist 
	Then MS JSON property "paymentMethod.card.cardname" should not exist 
	Then MS JSON property "exchangeRates.name[0]" should not exist 
	Then MS JSON property "payeeDetails.payeeType" should not exist 
	
	#Author: Sai Kushaal K(Defect MSF-2620)
Scenario Outline: Create a Payment Order with exchangeRate as null

	And post the static MS JSON as payload <payload> 
	And MS query parameter for Azure env is set to value "" 
	And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	When a "POST" request is sent to MS 
	Then MS response code should be 200
	
	Examples: 
		|payload|
		|  {"fromAccount":"799","toAccount":"1201","paymentReference":"paytest","paymentDetails":"Success","currency":"INR","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":null,"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
		
		
Scenario: To get created PO 
	Given create a new MS request with code using Restassured arguments "" 
	And MS request URI is "v1.0.0/payments/orders/PO~799~1201~INR~483" 
	And create a new MS request with code using Restassured arguments "GET_PAYMENTORDERS_AUTH_CODE" 
	And MS request header "serviceid" is set to "client" 
	And MS request header "channelid" is set to "web" 
	And MS request header "customfilterid" is set to "test" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	Then MS JSON property "paymentOrder.exchangeRates.name[0]" should be null 
	Then MS JSON property "paymentOrder.exchangeRates.value[1]" should be null
		
Scenario Outline: Create a Payment Order with exchangeRate as an empty array block 

	And post the static MS JSON as payload <payload> 
	And MS query parameter for Azure env is set to value "" 
	And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	When a "POST" request is sent to MS 
	Then MS response code should be 200
	
	Examples: 
		|payload|
		|  {"fromAccount":"899","toAccount":"1201","paymentReference":"paytest","paymentDetails":"Success","currency":"INR","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
		
		
Scenario: To get created PO
	Given create a new MS request with code using Restassured arguments "" 
	And MS request URI is "v1.0.0/payments/orders/PO~899~1201~INR~483" 
	And create a new MS request with code using Restassured arguments "GET_PAYMENTORDERS_AUTH_CODE" 
	And MS request header "serviceid" is set to "client" 
	And MS request header "channelid" is set to "web" 
	And MS request header "customfilterid" is set to "test" 
	When a "GET" request is sent to MS 
	And log all MS response in console
	Then MS response code should be 200 
	Then MS JSON property "paymentOrder.exchangeRates.name[0]" should be null 
	Then MS JSON property "paymentOrder.exchangeRates.value[1]" should be null
	
    