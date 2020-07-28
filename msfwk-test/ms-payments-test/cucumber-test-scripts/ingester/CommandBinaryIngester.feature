
Feature: CommandBinaryIngester    

 Scenario: Send Data to topic and validate Payment Order functionality
  
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paycmd |
  | description | string |Payment ref|

    Given Set the test backgound for PAYMENT_ORDER API
    Given Set the Testcase id MS-Test-PO-CommandIngester-001 for company GB0010001
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      #| MS-Test-PO-CommandIngester-001    | paymentOrderId    | eq       | string   | PO~10995~898789~USD~100 |

    
    When Send Data to Topic ms-paymentorder-inbox-topic from file avro/Ingester/CreatePOBinaryIngester.json for Application PAYMENT_ORDER
 
 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | MS-Test-PO-CommandIngester-001| paymentOrderId    | eq       | string   | PO~1733~3621~USD~901 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | MS-Test-PO-CommandIngester-001    | paymentOrderId  | PO~1733~3621~USD~901 |


    And set timeout session for 30 seconds
      
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
      | MS-Test-PO-CommandIngester-001| eventId    | eq       | string   | 4316e8-3ca-9-b-8728 |
      | MS-Test-PO-CommandIngester-001| eventType  | eq       | string   | PaymentOrder.createNewPaymentOrder |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1    
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-PO-CommandIngester-001| status    | PROCESSED   |
    
    #Check the entries in outbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-CommandIngester-001| correlationId    | eq       | string   | 4316e8-3ca-9-b-8728 |
      | MS-Test-PO-CommandIngester-001| eventType        | eq       | string   | CommandProcessed |
      
    #And Validate the below details from the db table ms_outbox_events and check no of record is 2
    And Validate the below details from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | MS-Test-PO-CommandIngester-001       | status         | DELIVERED |  
#
      #
    #Then Set the following data criteria
      #| TestCaseID                           | ColumnName       | Operator | DataType | ColumnValue |
      #| MS-Test-PO-CommandIngester-001       | correlationid    | eq       | string   | 4316e8-3ca-9-b-8728 |
      #| MS-Test-PO-CommandIngester-001       | eventtype        | eq       | string   | CommandProcessed |
      #
    #And Validate the below details from the db table ms_outbox_events
      #| TestCaseID                            | ColumnName    | ColumnValue |
      #| MS-Test-PO-CommandIngester-001       | correlationid  | 4316e8-3ca-9-b-8728 |
      #| MS-Test-PO-CommandIngester-001       | eventtype      | CommandProcessed |
      #| MS-Test-PO-CommandIngester-001       | status         | DELIVERED |  
      
   #To check API response for the record created above
   
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders/PO~1733~3621~USD~901"
    And MS query parameter for Azure env is set to value ""
    And MS request header "roleId" is set to "ADMIN"
    And MS request header "Content-Type" is set to "application/json"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/static-response/GetPOResponseForBinaryIngester.json"
      