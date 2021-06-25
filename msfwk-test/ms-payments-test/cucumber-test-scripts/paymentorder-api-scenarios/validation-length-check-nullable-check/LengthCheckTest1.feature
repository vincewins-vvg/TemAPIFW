Feature: LengthCheckTest1 

Background: To set the preconfig for the scenarios 

	Given Set the test backgound for PAYMENT_ORDER API 
	Given create a new MS request with code using Restassured arguments "" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
	
Scenario Outline: Create a new paymentorder against length check validation Test1. 
#To create PO details in order to validate against length checks.
	And MS request URI is "v1.0.0/payments/orders" 
	And post the static MS JSON as payload <payload>
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should equal value "[[PaymentOrder.paymentMethod.id must be greater than or equal to 1, PaymentOrder.paymentMethod.name length must be greater than or equal to 2]]" 
	
	Examples: 
		|payload|
		|{"fromAccount":"523","toAccount":"521","PaymentReferenceTestData":"payref","paymentDetails":"TEST","currency":"USD","amount":100,"expires":0,"fileContent":"TEST","paymentMethod":{"id":0,"name":"T","card":{"cardid":11,"cardname":"IDFC","cardlimit":111}},"exchangeRates":[{"id":11,"name":"TEST","value":12}],"payeeDetails":{"payeeName":"TESTER","payeeType":"ONLINE"},"descriptions":["TEST"]}|	
		
Scenario Outline: Create a new paymentorder against length check validation Test2. 
#To create PO details in order to validate against length checks.
	And MS request URI is "v1.0.0/payments/orders" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should equal value "[[PaymentOrder.paymentMethod.id must be greater than or equal to 1, PaymentOrder.paymentMethod.name length must be lesser than or equal to 20]]" 
	
	Examples:
	|payload|
	|{"fromAccount":"523","toAccount":"521","PaymentReferenceTestData":"payref","paymentDetails":"TEST","currency":"USD","amount":100,"expires":0,"fileContent":"TEST","paymentMethod":{"id":0,"name":"TEST000001TEST000001TEST000000001","card":{"cardid":11,"cardname":"IDFC","cardlimit":111}},"exchangeRates":[{"id":11,"name":"TEST","value":12}],"payeeDetails":{"payeeName":"TESTER","payeeType":"ONLINE"},"descriptions":["TEST"]}|
	
Scenario Outline: Create a new paymentorder against length check validation Test3. 
#To create PO details in order to validate against length checks.
	And MS request URI is "v1.0.0/payments/orders" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should equal value "[[PaymentOrder.paymentMethod.name length must be greater than or equal to 2]]" 
	
	Examples: 
		|payload|
		|{"fromAccount":"523","toAccount":"521","PaymentReferenceTestData":"payref","paymentDetails":"TEST","currency":"USD","amount":100,"expires":0,"fileContent":"TEST","paymentMethod":{"id":100,"name":"T","card":{"cardid":11,"cardname":"IDFC","cardlimit":111}}}|
		
		
		
	