Feature: CreateReferenceDetailsPaymentOrder1.3

#In this scenario we get the values using GET Method that is already available in the DB.
#Sequence: CreateReference Data >> Add a new value for the already exisiting collection data >> Update the newly added data >> Get the data along with the newly added data

Background: To setup the preconfigs 

	Given create a new MS request with code using Restassured arguments "" 
	And MS request URI is "payments/orders" 
	And MS query parameter for Azure env is set to value "" 
	And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
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
		| {"references":{"testreference30":[{"value":"Married","description":"Married"}],"testreference31":[{"value":"Male","description":"Male"}]}}|
		
		#To add an additional value to already exisiting collection using POST-AddReferenceDataAPI
Scenario Outline: Add a value to already existing collection 

	Given MS request URI is "v1.0.0/reference/testreference30" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "status" should equal value "200" 
	And MS JSON response string property key "message" should equal value "Operation Successful." 
	
	Examples: 
		|payload|
		|{"value": "Others","description": "Others"}|
		
Scenario Outline: Update the description of the reference that is newly created 

	Given MS request URI is "v1.0.0/reference" 
	And post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "status" should equal value "200" 
	And MS JSON response string property key "message" should equal value "Operation Successful." 
	
	Examples: 
		|payload|
		|{"references":{"testreference30":[{"value":"Others","description":"tester"}]}}|
		
Scenario: Get the reference data along with the newly added data 

	Given create a new MS request with code using Restassured arguments "" 
	And MS request URI is "v1.0.0/reference?type=testreference30" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "status" should equal value "200" 
	
 