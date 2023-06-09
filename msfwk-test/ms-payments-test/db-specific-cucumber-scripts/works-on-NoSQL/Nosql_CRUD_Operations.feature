Feature: Nosql_CRUD_Operations 

Background: to set the preconfig for the scenarios

	Given Set the test backgound for PAYMENT_ORDER API 
	And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	And MS request URI is "v1.0.0/account" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
	#POST API
Scenario Outline: create account with accountid

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "accountId" should exist 
	And MS JSON response string property key "modifiedCount" should equal value "1" 
	And MS JSON response string property key "status" should equal value "Successful" 
	
	Examples: 
	
		|payload|
		|{"accountId":"AD1","accountName":"ALEX","accountType":"SAVINGS","branch":"CHENNAI"}|
		
Scenario Outline: duplication check

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	Then check if actual response matches the expected static response <response>
	
	Examples: 
	
		|payload|response|
		|{"accountId":"AD1","accountName":"ALEX","accountType":"SAVINGS","branch":"CHENNAI"}|[{"message":"Could not be saved in Database","code":"MSF-999"}]|
		
		
		
Scenario Outline: to check whether the payloads get updated in post api 

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	Then check if actual response matches the expected static response <response> 
	
	Examples: 
	
		|payload|response|
		|{"accountId":"AD1","accountName":"AAA","accountType":"BBB","branch":"CCC"}|[{"message":"Could not be saved in Database","code":"MSF-999"}]|
		
Scenario Outline: payload conditions-null handling

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	Then check if actual response matches the expected static response <response> 
	
	Examples: 
	
		|payload|response|
		|{"accountId":null,"accountName":"fghj","accountType":"rtyu","branch":"hjj"}|[{"message":"Invalid Request Body","code":"MSF-002"}]|
		
Scenario Outline: payload conditions without extension payload

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	Then check if actual response matches the expected static response <response> 
	
	
	Examples: 
	
		|payload|response|
		|{"accountId":"ABD"}|[{"message":"Invalid Request Body","code":"MSF-002"}]|
		
Scenario Outline: payload conditins without account id

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	Then check if actual response matches the expected static response <response>  
	
	
	Examples: 
	
		|payload|response|
		|{"accountName":"fghj","accountType":"rtyu","branch":"hjj"}|[{"message":"Invalid Request Body","code":"MSF-002"}]|
		
Scenario Outline: payload conditions with junk values
#Script modified as per MSF-3112, by Sai Kushaal K

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And check full response with expected json content from file path "src/test/resources/static-response/NoSQLCRUDOperation.json" 
	
	Examples: 
	
		|payload|
		|{sdfghj}|
		
Scenario Outline: payload condition with no payload

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	Then check if actual response matches the expected static response <response>  
	
	Examples: 
	
		|payload|response|
		||[{"message":"Invalid Body parameter","code":"MSF-001"}]|
		
		#PUT API
		
Scenario Outline: update payload with put api-id mismatch

	When MS request URI is "v1.0.0/account/FIC" 
	When post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	Then check if actual response matches the expected static response <response> 
	
	Examples: 
	
		|payload|response|
		|{"accountId":"AD1","accountName":"AAA","accountType":"BBB","branch":"CCC"}|[{"message":"AccountId does not match with path param","code":"MSF-002"}]|
		
Scenario Outline: payload conditions without account id

	Given MS request URI is "v1.0.0/account/AD1" 
	When post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	Then check if actual response matches the expected static response <response>  
	
	Examples: 
	
		|payload|response|
		|{"accountName":"AAA","accountType":"BBB","branch":"CCC"}|[{"message":"Invalid Request Body -- Check email or name","code":"MSF-002"}]|
		
Scenario Outline: payload conditions with missing extensive payload

	Given MS request URI is "v1.0.0/account/AD1" 
	When post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	Then check if actual response matches the expected static response <response>  
	
	Examples: 
	
		|payload|response|
		|{"accountId":"AD1","accountType":"BBB"}|[{"message":"Invalid Request Body -- Check email or name","code":"MSF-002"}]|

Scenario Outline: update payload with put api

	Given MS request URI is "v1.0.0/account/AD1" 
	When post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	Then check if actual response matches the expected static response <response>
	
	Examples: 
	
		|payload|response|
		|{"accountId":"AD1","accountName":"AAA","accountType":"BBB","branch":"CCC"}|{"accountId":"AD1","accountName":"AAA","accountType":"BBB","branch":"CCC"}|

Scenario Outline: create a new account with put api

	Given MS request URI is "v1.0.0/account/NEW" 
	When post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	Then check if actual response matches the expected static response <response>
	
	Examples: 
	
		|payload|response|
		|{"accountId":"NEW","accountName":"HHH","accountType":"JJJ","branch":"KKK"}|{"accountId":"NEW","accountName":"HHH","accountType":"JJJ","branch":"KKK"}|
				
		#GET API
		
Scenario: get api

	Given MS request URI is "v1.0.0/account/AD1" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "accountId" should equal value "AD1"
	And MS JSON response string property key "accountName" should equal value "AAA"
	And MS JSON response string property key "accountType" should equal value "BBB"
	And MS JSON response string property key "branch" should equal value "CCC"
	
Scenario: invalid account id

	Given MS request URI is "v1.0.0/account/FIC" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 404 
	And MS JSON response string property key "message" should contain value "ID is not present in DB" 
	
	
	#DELETE API
Scenario: delete with invalid id

	Given MS request URI is "v1.0.0/account/FIP" 
	When a "DELETE" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 404 
	And MS JSON response string property key "message" should contain value "ID is not present in DB" 
	
Scenario: delete api_1

	Given MS request URI is "v1.0.0/account/AD1" 
	When a "DELETE" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "accountId" should exist 
	And MS JSON response string property key "modifiedCount" should equal value "1" 
	And MS JSON response string property key "status" should equal value "Successful" 
	
Scenario: delete api_2

	Given MS request URI is "v1.0.0/account/NEW" 
	When a "DELETE" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "accountId" should exist 
	And MS JSON response string property key "modifiedCount" should equal value "1" 
	And MS JSON response string property key "status" should equal value "Successful"	
	
	
	
	
	
 