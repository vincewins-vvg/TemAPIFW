Feature: UserIDGenerationNegativeTests 

Background: To set the preconfig for the scenarios 

	Given Set the test backgound for PAYMENT_ORDER API 
	Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
Scenario Outline: Create a new userID using POST METHOD with NULL values. 
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should equal value "[Invalid Request Body -- Check email or name]" 
	
	Examples: 
		|payload|
		|{"name":null,"email":null}|
		
Scenario Outline: Create a new userID using POST METHOD without at symbol in email. 
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should equal value "[Invalid Request Body -- Check email or name]" 
	
	Examples: 
		|payload|
		|{"name":"testername","email":"testgmail.com"}|
		
Scenario Outline: Create a new userID using POST METHOD without com in email. 
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should equal value "[Invalid Request Body -- Check email or name]" 
	
	Examples: 
		|payload|
		|{"name":"testername","email":"test@gmail"}|
		
Scenario Outline: Create a new userID using POST METHOD with number in both name & email. 
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should equal value "[Invalid Request Body -- Check email or name]" 
	
	Examples: 
		|payload|
		|{"name":1234,"email":123}|
		
Scenario Outline: Create a new userID using POST METHOD with empty values. 
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should equal value "[Invalid Request Body -- Check email or name]" 
	
	Examples: 
		|payload|
		|{ }|
		
Scenario Outline: Create a new userID using POST METHOD with empty values. 
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should equal value "[Invalid Body parameter]" 
	
	Examples: 
		|payload|
		| |