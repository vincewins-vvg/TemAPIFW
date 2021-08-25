#Author: Sai Kushaal K
Feature: CommandProcessed_EventIngester_2 

Scenario: Send Microservice B data to paymentorder-event-topic and validate Event Store table
   #Following two lines are generic
	Given Set the test backgound for PAYMENT_ORDER API
    And Set the Testcase id MS-Test-PO-EventIngester-001 for company GB0010001 
	
#Deleting existing entries in both Inbox table
	    And Delete Record in the table ms_inbox_events for the following criteria
	     | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
	     | MS-Test-PO-EventIngester-001    | eventId    | eq       | string   | 975740c1-effa-4a5c-a690-999b90f31f81 |
	
 #Sending data to PaymentOrder inbox topic
    When Send Data to Topic paymentorder-event-topic from file avro/ingester/CommandProcessedEvent_MicroserviceB.json for Application PAYMENT_ORDER
   
    And set timeout session for 30 seconds
   
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
      | MS-Test-PO-EventIngester-001  | eventId    | eq       | string   | 975740c1-effa-4a5c-a690-999b90f31f81 |
      | MS-Test-PO-EventIngester-001  | eventType  | eq       | string   | CommandProcessed |
      | MS-Test-PO-EventIngester-001  | commandType  | eq       | string   | ms-paymentorder.UpdatePaymentOrder |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1    
      | TestCaseID                   | ColumnName | ColumnValue |
      | MS-Test-PO-EventIngester-001 | eventId    | 975740c1-effa-4a5c-a690-999b90f31f81 |