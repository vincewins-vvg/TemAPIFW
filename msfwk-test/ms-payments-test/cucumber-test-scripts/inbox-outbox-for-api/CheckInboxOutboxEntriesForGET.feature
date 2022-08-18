Feature: CheckInboxOutboxEntriesForGET 


Scenario Outline: Create a new Payment Order for checking IO box entries 

#To insert the Payment reference details into the DB for testing purpose
	Given enter the tablename ms_reference_data 
	And enter data for table 
		| Fields   | type | data|
		| type | string |paymentref|
		| value | string |payiopget|
		| description | string |Payment ref|
		
	Given Set the test backgound for PAYMENT_ORDER API 
	And Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001 
	And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	And MS request URI is "v1.0.0/payments/orders" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	And MS request header "UUID" is set to "fda5244e-a140-470e-83ad-768cb225510-get0" 
	
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	
	Examples: 
	
		|payload|
		|{"fromAccount":"101-SBI","toAccount":"232-IOBC","paymentReference":"payiopget","paymentDetails":"Success","currency":"INR","amount":125,"expires":10,"fileContent":"dGVzdA==","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeId":1234,"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
		
Scenario: GETALL Payment Order for checking IO box entries 
	Given Set the test backgound for PAYMENT_ORDER API 
	And Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001 
	And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	And MS request URI is "v1.0.0/payments/orders" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	And MS request header "UUID" is set to "fda5244e-a140-470e-83ad-768cb225510-get1" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	
	#Check the entries in Inbox
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
		| MS-Test-Payments-MS-001       | eventId    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510-get1 |     
		
	And Validate if below details not present in db table ms_inbox_events 
	
		| TestCaseID                    | ColumnName | ColumnValue |
		| MS-Test-Payments-MS-001       | eventId    | fda5244e-a140-470e-83ad-768cb225510-get1 |
		
		#Check the entries in Outbox
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
		| MS-Test-Payments-MS-001       | correlationid    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510-get1 |     
		
	And Validate if below details not present in db table ms_outbox_events 
	
		| TestCaseID                    | ColumnName       | ColumnValue |
		| MS-Test-Payments-MS-001       | correlationid    | fda5244e-a140-470e-83ad-768cb225510-get1 |
		
Scenario: GET a Payment Order for checking IO box entries 
	Given Set the test backgound for PAYMENT_ORDER API 
	And Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001 
	And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	And MS request URI is "v1.0.0/payments/orders/PO~101-SBI~232-IOBC~INR~125" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "serviceid" is set to "client" 
	And MS request header "channelid" is set to "web" 
	And MS request header "customfilterid" is set to "test" 
	And MS request header "Content-Type" is set to "application/json" 
	And MS request header "UUID" is set to "fda5244e-a140-470e-83ad-768cb225510-get2" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	
	#Check the entries in Inbox
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
		| MS-Test-Payments-MS-001       | eventId    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510-get2 |     
		
	And Validate if below details not present in db table ms_inbox_events 
	
		| TestCaseID                    | ColumnName | ColumnValue |
		| MS-Test-Payments-MS-001       | eventId    | fda5244e-a140-470e-83ad-768cb225510-get2 |
		
		#Check the entries in Outbox
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
		| MS-Test-Payments-MS-001       | correlationid    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510-get2 |     
		
	And Validate if below details not present in db table ms_outbox_events 
	
		| TestCaseID                    | ColumnName       | ColumnValue |
		| MS-Test-Payments-MS-001       | correlationid    | fda5244e-a140-470e-83ad-768cb225510-get2 |
		
Scenario: GET a Payment Order by currency for checking IO box entries 
	Given Set the test backgound for PAYMENT_ORDER API 
	And Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001 
	And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	And MS request URI is "v1.0.0/payments/orders/currency" 
	And MS query parameter for Azure env is set to value "" 
	And MS query parameter "currency" is set to value "INR" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	And MS request header "UUID" is set to "fda5244e-a140-470e-83ad-768cb225510-get3" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	
	#Check the entries in Inbox
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
		| MS-Test-Payments-MS-001       | eventId    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510-get3 |     
		
	And Validate if below details not present in db table ms_inbox_events 
	
		| TestCaseID                    | ColumnName | ColumnValue |
		| MS-Test-Payments-MS-001       | eventId    | fda5244e-a140-470e-83ad-768cb225510-get3 |
		
		#Check the entries in Outbox
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
		| MS-Test-Payments-MS-001       | correlationid    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510-get3 |     
		
	And Validate if below details not present in db table ms_outbox_events 
	
		| TestCaseID                    | ColumnName       | ColumnValue |
		| MS-Test-Payments-MS-001       | correlationid    | fda5244e-a140-470e-83ad-768cb225510-get3 | 
		
		
		
		
    