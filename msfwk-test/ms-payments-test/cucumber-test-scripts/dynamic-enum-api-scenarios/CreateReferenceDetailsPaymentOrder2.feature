Feature: CreateReferenceDetailsPaymentOrder2 

#In this scenario we are updating a value that has already been deleted in the database.
#Sequence: CreateReference Data >> Delete the value >> Update for for deleted value 

Background: To setup the preconfigs 

	Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDER_AUTH_CODE" 
	And MS request URI is "v1.0.0/payments/orders" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
Scenario Outline: Create reference details of payment order 

#To insert the Payment reference details into the DB for testing purpose
	Given MS request URI is "v1.0.0/reference" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "status" should equal value "200" 
	And MS JSON response string property key "message" should equal value "Operation Successful." 
	
	Examples: 
		|payload|
		| {"references":{"testreference11":[{"value":"Married","description":"Married"}]}}|
		
Scenario: To delete the created value 
#To delete the payment reference details from the DB for testing purpose
	Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDER_AUTH_CODE" 
	And MS request URI is "v1.0.0/reference/testreference11?value=Married" 
	When a "DELETE" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "status" should equal value "200" 
	And MS JSON response string property key "message" should equal value "Delete successful" 
	
Scenario Outline: Update the Payment Order that has been deleted 

	Given MS request URI is "v1.0.0/reference" 
	And post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "status" should equal value "400" 
	And MS JSON response string property key "message" should equal value "Record Not Found for testreference11 and value : Married" 
	
	Examples: 
		|payload|
		|{"references":{"testreference11":[{"value":"Married","description":"tester"}]}}|
		
		
		
