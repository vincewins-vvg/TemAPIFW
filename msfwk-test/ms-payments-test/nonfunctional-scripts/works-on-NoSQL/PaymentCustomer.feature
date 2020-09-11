Feature: PaymentCustomer
Background: to set the preconfig for the scenarios

	Given Set the test backgound for PAYMENT_ORDER API 
	And create a new MS request with code using Restassured arguments "" 
	And MS request URI is "payments/customers" 
	And MS query parameter for Azure env is set to value "" 
	And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
	#POST API
	#data_1
Scenario Outline: create customer using post method

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "customerId" should exist 
	And MS JSON response string property key "status" should equal value "Created"
	
	Examples: 
        |payload|
		|{"customerId":"AD1","customerName":"Riya","account":"Savings","loanTypes":["education loan"],"dateOfJoining":"2020-08-26"}|
		
#data_2
Scenario Outline: create customer using post method

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "customerId" should exist 
	And MS JSON response string property key "status" should equal value "Created"
	
	Examples: 
        |payload|
		|{"customerId":"AD2","customerName":"Ram","account":"Salary","loanTypes":["education loan"],"dateOfJoining":"2020-09-22"}|	
	
#data_3
Scenario Outline: create customer using post method

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "customerId" should exist 
	And MS JSON response string property key "status" should equal value "Created"
	
	Examples: 
        |payload|
		|{"customerId":"AD3","customerName":"Janani","account":"Savings","loanTypes":["housing loan"],"dateOfJoining":"2021-12-10"}|
		
#data_4
Scenario Outline: create customer using post method

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "customerId" should exist 
	And MS JSON response string property key "status" should equal value "Created"
	
	Examples: 
        |payload|
		|{"customerId":"AD4","customerName":"Ema","account":"Savings","loanTypes":["housing loan"],"dateOfJoining":"2025-12-10"}|	
				
#data_5
Scenario Outline: create customer using post method

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "customerId" should exist 
	And MS JSON response string property key "status" should equal value "Created"
	
	Examples: 
        |payload|
		|{"customerId":"AD5","customerName":"Raja","account":"Savings","loanTypes":["education loan"],"dateOfJoining":"1700-02-10"}|	
		
	
#data_6
Scenario Outline: create customer using post method-invalid date format

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400

	
	Examples: 
        |payload|
		|{"customerId":"AD7","customerName":"arthi","account":"Savings","loanTypes":["housing loan"],"dateOfJoining":"1800.03.16"}|	
									
#data_7
Scenario Outline: create customer using post method-invalid date format

	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400

	
	Examples: 
        |payload|
		|{"customerId":"AD8","customerName":"asal","account":"Savings","loanTypes":["housing loan"],"dateOfJoining":"1800/03/16"}|	
																			
#getapi
	Scenario: to retrieve a customer using query param-from and todate

	And MS query parameter "fromDate" is set to value "2020-01-10" 
	And MS query parameter "toDate" is set to value "2021-12-10" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	#And check full response with expected json content from file path "src/test/resources/static-response/GetPaymentCustomerResponse1.json"
	Then MS JSON property "" should contain at least 3 elements
	
	Scenario: to retrieve a customer using query param-from and todate
	And MS query parameter "fromDate" is set to value "2022-01-10" 
	And MS query parameter "toDate" is set to value "2026-12-10" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	#And check full response with expected json content from file path "src/test/resources/static-response/GetPaymentCustomerResponse2.json"
	Then MS JSON property "" should contain at least 1 elements
	
	Scenario: to retrieve a customer using query param-from ,todate  and loantypes

	And MS query parameter "fromDate" is set to value "2020-01-10" 
	And MS query parameter "toDate" is set to value "2021-12-10"
	And MS query parameter "loanTypes" is set to value "housing%20loan" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200  
	#And check full response with expected json content from file path "src/test/resources/static-response/GetPaymentCustomerResponse4.json"
	Then MS JSON property "" should contain at least 1 elements
	
	Scenario: to retrieve a customer using query param-from ,todate  and account

	And MS query parameter "fromDate" is set to value "2020-01-10" 
	And MS query parameter "toDate" is set to value "2021-12-10"
	And MS query parameter "account" is set to value "Salary" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200  
	#And check full response with expected json content from file path "src/test/resources/static-response/GetPaymentCustomerResponse4.json"
	Then MS JSON property "" should contain at least 1 elements
	
	Scenario: to retrieve a customer using query param-from ,todate 

	And MS query parameter "fromDate" is set to value "null" 
	And MS query parameter "toDate" is set to value "2021-12-10"
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should contain value "Check the date format entered" 
	And MS JSON response string property key "code" should contain value "400"
	
	Scenario: to retrieve a customer using query param-from and  invalid todate
	And MS query parameter "fromDate" is set to value "2022-01-10" 
	And MS query parameter "toDate" is set to value "2026/12/10" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400
	And MS JSON response string property key "message" should contain value "Check the date format entered" 
	And MS JSON response string property key "code" should contain value "400" 
	
	Scenario: to retrieve a customer using query param- invalid from and todate
	And MS query parameter "fromDate" is set to value "2022/01/10" 
	And MS query parameter "toDate" is set to value "2026-12-10" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should contain value "Check the date format entered" 
	And MS JSON response string property key "code" should contain value "400"
	
	Scenario: to retrieve a customer using query param-null from date
	And MS query parameter "fromDate" is set to value "" 
	And MS query parameter "toDate" is set to value "2026-12-10" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400
	And MS JSON response string property key "message" should contain value "No Record found" 
	And MS JSON response string property key "code" should contain value "400"
	
	Scenario: to retrieve a customer using query param-null to date
	And MS query parameter "fromDate" is set to value "2021-12-10" 
	And MS query parameter "toDate" is set to value "" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should contain value "No Record found" 
	And MS JSON response string property key "code" should contain value "400"
	
	Scenario: to retrieve a customer using query param-no data within that range
	And MS query parameter "fromDate" is set to value "2029-12-10" 
	And MS query parameter "toDate" is set to value "2039-12-10" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400
	And MS JSON response string property key "message" should contain value "No Record found" 
	And MS JSON response string property key "code" should contain value "400"
	
	Scenario: to retrieve a customer using query param-junk in fromdate
	And MS query parameter "fromDate" is set to value "!@#$" 
	And MS query parameter "toDate" is set to value "2039-12-10" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400
	And MS JSON response string property key "message" should contain value "Check the date format entered" 
	And MS JSON response string property key "code" should contain value "400" 
	 
	
				
				
			
				
		
				
						