Feature: ClauseNegativeTest 

Background: To set the preconfig for the scenarios 

	Given Set the test backgound for PAYMENT_ORDER API 
	Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 

Scenario Outline: To validate whether status of the PO is updated while passing values not existing in the DB. 
	Given MS request URI is "v1.0.0/payments/orders/update" 
	And post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	#Then MS response code should be 200 
	#And MS JSON property "status" should exist 
	#And MS JSON response string property key "status" should equal value "Updated 0 PaymentIds which satisfy this Criteria"
	
	Examples: 
		|payload|
		|{"criteriaDetails":[{"nameOfCriteria":"debitAccount","valueOfCriteria":"4009-test"}],"status":"POUPDATED"}|
	
Scenario: To validate whether PO is deleted when param passed not exists in DB.
	Given MS request URI is "v1.0.0/payments/orders/delete?status=ClauseTest" 
	When a "DELETE" request is sent to MS 
	#Then MS response code should be 200 
	#And MS JSON response string property key "status" should equal value "Deleted 0 PaymentIds which satisfy this Criteria"

Scenario Outline: To validate whether status of the payment order is updated when null value is passed. 
	Given MS request URI is "v1.0.0/payments/orders/update" 
	And post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	#Then MS response code should be 400 
	#And MS JSON property "status" should exist 
	#And MS JSON response string property key "message" should equal value "[Invalid or Null Criteria values entered]"
	
	Examples: 
		|payload|
		|{"criteriaDetails":[{"nameOfCriteria":"debitAccount","valueOfCriteria":null}],"status":"POUPDATED"}|

Scenario: To validate whether a PO is deleted when no param has been passed.
	Given MS request URI is "v1.0.0/payments/orders/delete" 
	When a "DELETE" request is sent to MS 
	#Then MS response code should be 400 
	#And MS JSON response string property key "message" should equal value "[Invalid or Null Status value entered]"
	
 	