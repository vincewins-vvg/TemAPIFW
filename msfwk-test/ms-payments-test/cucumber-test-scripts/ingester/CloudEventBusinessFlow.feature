##Author: Sabapathy
##MSF-2739
#Feature: CloudEvent CommandFlow

#Scenario: Send Cloud event data to Command Ingester Topic
 
##Delete existing record in ms_reference_table

#  	Given Set the test backgound for PAYMENT_ORDER API
#  	Given Set the Testcase id CloudEventCommand for company GB0010001
#  	And Delete Record in the table ms_reference_data for the following criteria
#      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
#      | CloudEventCommand    | value    | eq       | string   | cloudref |
     
##Insert record to ms_reference_table  

#  	Given enter the tablename ms_reference_data
#  	And enter data for table
#  	| Fields   | type | data|
#  	| type | string |paymentref|
#  	| value | string |cloudref |
#  	| description | string |Payment ref|
   
#    When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/CloudEventCommand.json for Application PAYMENT_ORDER
    
#    And set timeout session for 30 seconds

#    Then Set the following data criteria
#      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
#      | CloudEventCommand| paymentOrderId    | eq       | string   | PO~101~102~USD~10 |

#    And Validate the below details from the db table ms_payment_order and check no of record is 1
#      | TestCaseID                        | ColumnName      | ColumnValue          |
#      | CloudEventCommand    | paymentOrderId  | PO~101~102~USD~10 |
      
#    #Check the entries in Inbox
#    Then Set the following data criteria
#      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
#      | CloudEventCommand| eventId    | eq       | string   | 4216e8-3ca-9-b-1001 |
#      | CloudEventCommand| eventType  | eq       | string   | PaymentOrder.CreateNewPaymentOrder |

#    And Validate the below details from the db table ms_inbox_events and check no of record is 1
#      | TestCaseID                    | ColumnName | ColumnValue |
#      | CloudEventCommand| status    | PROCESSED   |
        
# 	#Check the entries in Outbox
# 	#Following event types validated - CommandProcessed,UpdatePaymentOrder,POAccepted,Prehook,Posthook
		
#    #1.Check the entries in outbox for correlationId & eventType "Posthook"
#    Then Set the following data criteria 
#      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
#      | CloudEventCommand| correlationId    | eq       | string   | 4216e8-3ca-9-b-1001  |
#      | CloudEventCommand| eventType    | eq       | string   | PostHookEvent |
      
#		And Validate the below details from the db table ms_outbox_events and check no of record is 1
#      | TestCaseID            | ColumnName     | ColumnValue |
#      | CloudEventCommand| eventType    | PostHookEvent |
	
#		And Validate if the below columns contains values from the db table ms_outbox_events
#     	| TestCaseID                           | ColumnName     | ColumnValue |      
#      | CloudEventCommand       | status         | DELIVERED  |  
     
#   #2.Check the entries in outbox for correlationId & eventType "CommandProcessed"
#    Then Set the following data criteria 
#      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
#      | CloudEventCommand| correlationId    | eq       | string   | 4216e8-3ca-9-b-1001  |
#      | CloudEventCommand| eventType    | eq       | string   | CommandProcessed|

#    And Validate the below details from the db table ms_outbox_events and check no of record is 1
#      | TestCaseID            | ColumnName     | ColumnValue |
#      | CloudEventCommand| eventType    | CommandProcessed |
    
#   	And Validate if the below columns contains values from the db table ms_outbox_events
#     	| TestCaseID                           | ColumnName     | ColumnValue |      
#      | CloudEventCommand       | payload         | "status":200   |
#      | CloudEventCommand       | status         | DELIVERED  |
     
#   #3.Check the entries in outbox for correlationId & eventType "PaymentOrder.UpdatePaymentOrder"
#    Then Set the following data criteria 
#      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
#      | CloudEventCommand| correlationId    | eq       | string   | 4216e8-3ca-9-b-1001  |
#      | CloudEventCommand| eventType    | eq       | string   | PaymentOrder.UpdatePaymentOrder |
    
#    And Validate the below details from the db table ms_outbox_events and check no of record is 1
#      | TestCaseID            | ColumnName     | ColumnValue |
#      | CloudEventCommand| eventType    | PaymentOrder.UpdatePaymentOrder |
    
#   	And Validate if the below columns contains values from the db table ms_outbox_events
#     	| TestCaseID                           | ColumnName     | ColumnValue |      
#      | CloudEventCommand       | status         | DELIVERED  | 
      
#   #4.Check the entries in outbox for correlationId & eventType "POAccepted"
#    Then Set the following data criteria 
#      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
#      | CloudEventCommand| correlationId    | eq       | string   | 4216e8-3ca-9-b-1001  |
#      | CloudEventCommand| eventType    | eq       | string   | POAccepted |
    
#    And Validate the below details from the db table ms_outbox_events and check no of record is 1
#      | TestCaseID            | ColumnName     | ColumnValue |
#      | CloudEventCommand| eventType    | POAccepted |
   
#   	And Validate if the below columns contains values from the db table ms_outbox_events
#     	| TestCaseID                           | ColumnName     | ColumnValue |      
#      | CloudEventCommand       | status         | DELIVERED  |
   
#   #5.Check the entries in outbox for correlationId & eventType "PreHookEvent"
#    Then Set the following data criteria 
#      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
#      | CloudEventCommand| correlationId    | eq       | string   | 4216e8-3ca-9-b-1001  |
#      | CloudEventCommand| eventType    | eq       | string   | PreHookEvent |
    
#    And Validate the below details from the db table ms_outbox_events and check no of record is 1
#      | TestCaseID            | ColumnName     | ColumnValue |
#      | CloudEventCommand| eventType    | PreHookEvent |
    
#   	And Validate if the below columns contains values from the db table ms_outbox_events
#     	| TestCaseID                           | ColumnName     | ColumnValue |      
#      | CloudEventCommand       | status         | DELIVERED  | 