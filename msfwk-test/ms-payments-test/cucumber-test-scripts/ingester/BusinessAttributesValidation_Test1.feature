Feature: BusinessAttributesValidation_Test1 

#Author: Sai Kushaal K
#Description: In this feature, we are sending a cloudEvent(with businessKey & sequenceNo. in to paymentorder-inbox-topic
#The Cloud event in turn creates a Payment Order with businessKey and sequenceNo.

Background: To setup the preconfigs 
	Given Set the test backgound for PAYMENT_ORDER API 
	And MS query parameter for Azure env is set to value "" 
	And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
Scenario: Send CloudEvent_data to topic and validate the businessAttributes 
#sequenceNo = 1 in payload

	Given enter the tablename ms_reference_data 
	And enter data for table 
		| Fields   | type | data|
		| type | string |paymentref|
		| value | string |paybatt |
		| description | string |Payment ref|
		
	Given Set the Testcase id MS-Test-PO-CloudEvent-001 for company GB0010001 
	
	And Delete Record in the table ms_inbox_events for the following criteria 
		| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
		| MS-Test-PO-CloudEvent-001    | eventId    | eq       | string   | 9225e8-3ca-9-b-8801 |
		
	When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/BusinessAttributesValidation_Test1.json for Application PAYMENT_ORDER 
	
	And set timeout session for 30 seconds 
	
	#Check the entries in Inbox
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
		| MS-Test-PO-CloudEvent-001       | eventId    | eq       | string   | 9225e8-3ca-9-b-8801 |
		| MS-Test-PO-CloudEvent-001       | eventType    | eq       | string   | PaymentOrder.CreateNewPaymentOrder |
		
	And Validate the below details from the db table ms_inbox_events and check no of record is 1 
	
		| TestCaseID                    | ColumnName | ColumnValue |
		| MS-Test-PO-CloudEvent-001       | status     | PROCESSED |
		| MS-Test-PO-CloudEvent-001       | businessKey     | PO123 |
		| MS-Test-PO-CloudEvent-001       | sequenceNo    | 1 |
		
		#To get the created PO
	Given create a new MS request with code using Restassured arguments "" 
	Given MS request URI is "v1.0.0/payments/orders/PO~419967~7546~USD~124" 
	And create a new MS request with code using Restassured arguments "GET_PAYMENTORDERS_AUTH_CODE" 
	And MS request header "serviceid" is set to "client" 
	And MS request header "channelid" is set to "web" 
	And MS request header "customfilterid" is set to "test" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And check full response with expected json content from file path "src/test/resources/static-response/BusinessAttributes_CloudEvent.json" 
	
Scenario: To validate if sequenceNo is accepted and status is changed to UPDATED 
#sequenceNo = 2 in payload

	When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/BusinessAttributesValidation_Test2.json for Application PAYMENT_ORDER 
	
	And set timeout session for 30 seconds 
	
	Given Set the Testcase id MS-Test-PO-CloudEvent-002 for company GB0010001 
	
	#Check the entries in Inbox to validate if sequenceNo entry has been accepted
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
		| MS-Test-PO-CloudEvent-002       | eventId    | eq       | string   | f5798d48-4d89-4e0c-b341-0370d18e47b7 |
		| MS-Test-PO-CloudEvent-002       | eventType    | eq       | string   | PaymentOrder.UpdatePaymentOrder |
		
	And Validate the below details from the db table ms_inbox_events and check no of record is 1 
	
		| TestCaseID                    | ColumnName | ColumnValue |
		| MS-Test-PO-CloudEvent-002       | status     | PROCESSED |
		| MS-Test-PO-CloudEvent-002       | businessKey     | PO123 |
		| MS-Test-PO-CloudEvent-002       | sequenceNo    | 2 |
		
	And set timeout session for 30 seconds 
	
	#Check the entries in ms_payment_order table to validate if status has been updated
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
		| MS-Test-PO-CloudEvent-002       | paymentOrderId    | eq       | string   | PO~419967~7546~USD~124 |
		
	And Validate the below details from the db table ms_payment_order and check no of record is 1 
	
		| TestCaseID                    | ColumnName | ColumnValue |
		| MS-Test-PO-CloudEvent-002       | status     | UPDATED |
		| MS-Test-PO-CloudEvent-002       | businessKey     | PO123 |
		
		
Scenario: To validate Out of Sequence when sequence is not followed 
#sequenceNo = 5 in payload

	When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/BusinessAttributesValidation_Test3.json for Application PAYMENT_ORDER 
	
	And set timeout session for 30 seconds 
	
	Given Set the Testcase id MS-Test-PO-CloudEvent-003 for company GB0010001 
	
	#Check for no entries in ms_inbox_table table 
	Then Set the following data criteria 
		| TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
		| MS-Test-PO-CloudEvent-003| eventId    | eq       | string   | g5798d48-4d89-4e0c-b341-0370d18e47b7 |
		
	And Validate if below details not present in db table ms_inbox_events
		| TestCaseID                        | ColumnName      | ColumnValue          |
		| MS-Test-PO-CloudEvent-003    | eventId  | g5798d48-4d89-4e0c-b341-0370d18e47b7 |