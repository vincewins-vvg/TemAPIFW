Feature: UpdatePOByClauseTest 

Background: To set the preconfig for the scenarios 

	Given Set the test backgound for PAYMENT_ORDER API 
	Given create a new MS request with code using Restassured arguments "" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
Scenario Outline: Create a new Payment Order using POST METHOD. 
#To insert the Payment reference details into the DB for testing purpose
	Given enter the tablename ms_reference_data 
	And enter data for table 
		| Fields   | type | data|
		| type | string |paymentref|
		| value | string |paytest1|
		| description | string |Payment ref| 
		
	And MS request URI is "v1.0.0/payments/orders" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "paymentId" should exist 
	And MS JSON response string property key "status" should equal value "INITIATED" 
	
	Examples: 
		|payload|
		|  {  "fromAccount": "3004",  "toAccount": "123-ABC", "paymentReference": "paytest1","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
		
Scenario Outline: Update the status of the created payment order using the update clause
	Given MS request URI is "v1.0.0/payments/orders/update" 
	And post the static MS JSON as payload <payload> 
	When a "PUT" request is sent to MS 
	Then MS response code should be 200 
	And MS JSON property "status" should exist 
	
	Examples: 
		|payload|
		|{"criteriaDetails":[{"nameOfCriteria":"debitAccount","valueOfCriteria":"3004"}],"status":"POUPDATED"}|
		
		
Scenario: To get the created PO using GET METHOD inorder to validate the updated status 
	Given create a new MS request with code using Restassured arguments "" 
	And Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001 
	And MS request URI is "v1.0.0/payments/orders/PO~3004~123-ABC~USD~485" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	
	And set timeout session for 30 seconds 
	
	#Check the entries in payment order table
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
		| MS-Test-Payments-MS-001       | paymentOrderId    | eq       | string   | PO~3004~123-ABC~USD~485|
		
		
	And Validate the below details from the db table ms_payment_order and check no of record is 1 
	
		| TestCaseID                    | ColumnName | ColumnValue|
		| MS-Test-Payments-MS-001       | status     | POUPDATED |
		

	
	
    