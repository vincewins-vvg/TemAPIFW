#Author: Sabapathy
#Feature: Commmand Ingester - XACML Validation
#MSF-2213 
#Scenario: Validate Command Event with amount exceeding XACML policy condition
# 
#  #Delete existing record in ms_reference_table
#  Given Set the test backgound for PAYMENT_ORDER API
#  Given Set the Testcase id XACMLValidation for company GB0010001
#  And Delete Record in the table ms_reference_data for the following criteria
#      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
#      | XACMLValidation    | value    | eq       | string   | PayRef |
#  
#  #Insert record in ms_reference_table
#  Given enter the tablename ms_reference_data
#  And enter data for table
#  | Fields   | type | data|
#  | type | string |paymentref|
#  | value | string |PayRef |
#  | description | string |Payment ref|
#    
#    #Delete existing record in both Inbox & Outbox tables
#    And Delete Record in the table ms_inbox_events for the following criteria
#      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
#      | XACMLValidation    | eventId    | eq       | string   | 4316e8-3ca-9-b-1002 |
#     
#    And Delete Record in the table ms_outbox_events for the following criteria
#      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
#      | XACMLValidation    | correlationId    | eq       | string   | 4316e8-3ca-9-b-1002 |
#
#    #Send Command Event data with amount exceeding XACML policy condition to topic 
#    When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/CreatePOBinaryIngesterXACMLValidation.json for Application PAYMENT_ORDER
#     
#    And set timeout session for 30 seconds
#       
#    #Check for no entries in PO table 
#    Then Set the following data criteria
#      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
#      | WithoutJWTToken| paymentOrderId    | eq       | string   | PO~101~102~USD~501 |
#    
#     And Validate if below details not present in db table ms_payment_order 
#      | TestCaseID                        | ColumnName      | ColumnValue          |
#      | WithoutJWTToken    | paymentOrderId  | PO~101~102~USD~501 |
#    
#    
#    And set timeout session for 30 seconds
# 
#    #Check the entries in Inbox for eventId
#    Then Set the following data criteria 
#      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
#      | XACMLValidation| eventId    | eq       | string   | 4316e8-3ca-9-b-1002 |
#      
#    #And Validate the below details from the db table ms_inbox_events
#    And Validate the below details from the db table ms_inbox_events
#      | TestCaseID                           | ColumnName     | ColumnValue |
#      | XACMLValidation       | eventId    | 4316e8-3ca-9-b-1002 |
#      | XACMLValidation       | eventType    | PaymentOrder.CreateNewPaymentOrder |
#      | XACMLValidation       | status    | PROCESSED |
#    
#    
#    And set timeout session for 30 seconds
# 
#    #Check the entries in outbox for correlationId
#    Then Set the following data criteria 
#      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
#      | XACMLValidation| correlationId    | eq       | string   | 4316e8-3ca-9-b-1002 |
#      
#    #And Validate the below details from the db table ms_outbox_events
#    And Validate the below details from the db table ms_outbox_events
#      | TestCaseID                           | ColumnName     | ColumnValue |
#      | XACMLValidation       | correlationId    | 4316e8-3ca-9-b-1002 |
#      | XACMLValidation       | eventType    | CommandFailed |
#      
#      
#     And Validate if the below columns contains values from the db table ms_outbox_events
#      | TestCaseID                           | ColumnName     | ColumnValue |      
#      | WithoutJWTToken       | status         | DELIVERED   |
#      | WithoutJWTToken       | payload        | "status":401 |
#      | WithoutJWTToken      | payload        | "failureMessages":[{"message":"Authorization failed","code":"MSF-003"}]|