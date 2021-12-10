Feature: ValidationUtilityNegativeTests 

Background: To set the preconfig for the scenarios 

	Given Set the test backgound for PAYMENT_ORDER API 
	Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
Scenario Outline:Validate utilies for datatypes using POST METHOD by passing values below threshold limit. 
	And MS request URI is "v1.0.0/payments/validations" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	
	
	Examples: 
		|payload|
		|{"paymentId":50,"personalAccNo":4,"branchId":4,"monthCount":5,"penaltyInterest":4.9,"yearWiseInterest":0.9,"userIdenfication":9,"fileReadWrite":"file","paymentDate":"2017-07-21T17:32:28Z","actualDate":"2017-07-21","socialSecurityNo":"046b6c7f-0b8a-43b9-b35d-6489e6daee91","paymentOrdersItems":{"name":"Card","id":33},"paymentOrders":[{"paymentMethod":{"name":"C","id":33}}],"paymentMethod":"card","extensionData":{"id":"43"},"currency":"USD"}|
		
Scenario Outline:Validate utilies for datatypes using POST METHOD by passing values above threshold limit. 
	And MS request URI is "v1.0.0/payments/validations" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	
	Examples: 
		|payload|
		|{"paymentId":50,"personalAccNo":51,"branchId":51,"monthCount":5,"penaltyInterest":50.5,"yearWiseInterest":60.5,"userIdenfication":91,"fileReadWrite":"file","paymentDate":"2017-07-21T17:32:28Z","actualDate":"2017-07-21","socialSecurityNo":"046b6c7f-0b8a-43b9-b35d-6489e6daee91","paymentOrdersItems":{"name":"Card","id":33},"paymentOrders":[{"paymentMethod":{"name":"TEST000000000000000000000001","id":33}}],"paymentMethod":"card","extensionData":{"id":"43"},"currency":"USD"}|
		
Scenario Outline:Validate utilies for datatypes using POST METHOD by passing values as null. 
	And MS request URI is "v1.0.0/payments/validations" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	
	Examples: 
		|payload|
		|{"paymentId":null,"personalAccNo":null,"branchId":null,"monthCount":null,"penaltyInterest":null,"yearWiseInterest":null,"userIdenfication":null,"paymentMethod":null,"currency":null}|