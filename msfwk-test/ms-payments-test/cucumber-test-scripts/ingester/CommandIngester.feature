# Author: Gowri Chandrika M
Feature: Command Ingester - MFW 2933 

Scenario: To verify if events raised are delivered to ms-eventstore-inbox-topic 
	Given Set the test backgound for EVENT_STORE API 
	Given Set the Testcase id MS-TestCase-001 for company GB0010001 
	
	# Sending event to the topic
	When Send Data to Topic paymentorder-inbox-topic from file avro/ingester/CommandEvent.json for Application PAYMENT_ORDER 
	And set timeout session for one minute 
	
	# Validating the event in the table	
	Then Set the following data criteria 
		| TestCaseID     | ColumnName        | Operator | DataType | ColumnValue          |
		| MS-TestCase-001| eventId    		 | eq   | string   | 5213a00f-1ab3-478e-a4d7-53b0f4327776 |
		
	And Validate the below details from the db table ms_inbox_events 
		| TestCaseID         | ColumnName      | ColumnValue          |
		| MS-TestCase-001    | eventType  	   | ms-paymentorder.GetPaymentOrder |
		
		# Verifying if events are delivered into ms-eventstore-inbox-topic
	And set timeout session for one minute 
	Then check if json data with correlation id 5213a00f-1ab3-478e-a4d7-53b0f4327776 and cloudeventtype ms-paymentorder.GetPaymentOrder is present in topic ms-eventstore-inbox-topic	