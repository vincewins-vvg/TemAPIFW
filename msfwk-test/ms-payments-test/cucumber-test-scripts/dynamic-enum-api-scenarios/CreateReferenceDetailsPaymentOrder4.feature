Feature: CreateReferenceDetailsPaymentOrderwithCode


Background: To setup the preconfigs 

	Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDER_AUTH_CODE" 
	And MS request URI is "v1.0.0/payments/orders" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
Scenario Outline: Create reference details of payment order 

#To insert the Payment reference details into the DB for testing purpose
	Given MS request URI is "v1.0.0/reference/OrderTable/ID" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200  
	
	Examples: 
		|payload|
		|{"value":"100","description":"Maximumorder"}|
		
		#To update the description of the existing value that is already available in the database
Scenario Outline: Update an existing Payment Order reference 

	Given MS request URI is "v1.0.0/reference/OrderTable/100" 
	And post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	
	Examples: 
		|payload|
		|{"value":"100","description":"MaximumorderUpdated"}|
		
		#To get the Payment reference details after making updates to already available data.
Scenario: To GET created PO reference 
#To get the payment reference details from the DB for testing purpose
	Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDER_AUTH_CODE" 
	And MS request URI is "v1.0.0/reference/OrderTable/100" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	
#To Delete the Payment reference details after making updates to already available data.
Scenario: To Delete created PO reference 
#To Delete the payment reference details from the DB for testing purpose
	Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDER_AUTH_CODE" 
	And MS request URI is "v1.0.0/reference/OrderTable/100" 
	When a "DELETE" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	
   