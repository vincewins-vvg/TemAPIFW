
Feature: CommandBinaryIngesterFailure 

 Scenario: Send error prone data to topic and validate Payment Order functionality (incorrect PayRef)


    Given Set the test backgound for PAYMENT_ORDER API
    Given Set the Testcase id MS-Test-PO-CommandIngester-001 for company GB0010001
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      #| MS-Test-PO-CommandIngester-001    | paymentOrderId    | eq       | string   | PO~10995~898789~USD~100 |

    
    When send JSON data to topic ms-paymentorder-inbox-topic from file avro/ingester/CommandIngesterInvalidJSON.json for Application PAYMENT_ORDER
    
    And set timeout session for 30 seconds
 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | MS-Test-PO-CommandIngester-001| paymentOrderId    | eq       | string   | PO~1739~3621~USD~901 |

    
    And Validate if below details not present in db table ms_payment_order 
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | MS-Test-PO-CommandIngester-001    | paymentOrderId  | PO~1739~3621~USD~901 |
      
    
    And set timeout session for 30 seconds

    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
      | MS-Test-PO-CommandIngester-001| eventId    | eq       | string   | 4316e8-3ca-9-cifs-87200 |
      | MS-Test-PO-CommandIngester-001| eventType  | eq       | string   | PaymentOrder.CreateNewPaymentOrder |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-PO-CommandIngester-001| status    | PROCESSED   |
      
      
      #To check outbox entries
      Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-CommandIngester-001| correlationId    | eq       | string   | 4316e8-3ca-9-cifs-87200 |
      | MS-Test-PO-CommandIngester-001| eventType        | eq       | string   | CommandFailed |
      
    And Validate the below details from the db table ms_outbox_events
    #And Validate the below details from the db table ms_outbox_events and check no of record is 1
    | TestCaseID                           | ColumnName     | ColumnValue |
    | MS-Test-PO-CommandIngester-001       | correlationId  | 4316e8-3ca-9-cifs-87200 |
    
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | MS-Test-PO-CommandIngester-001       | status         | DELIVERED   |
      | MS-Test-PO-CommandIngester-001       | payload        | "status":400 |
      | MS-Test-PO-CommandIngester-001       | payload        | "failureMessages":[{"message":"Invalid reference type data: bgvggk"|
  
  
   
  Scenario: Send error prone data to topic and validate Payment Order functionality (invalid Enum Currency)
  
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |cmdcur |
  | description | string |Payment ref|

    Given Set the test backgound for PAYMENT_ORDER API
    Given Set the Testcase id MS-Test-PO-CommandIngester-001 for company GB0010001
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      #| MS-Test-PO-CommandIngester-001    | paymentOrderId    | eq       | string   | PO~10995~898789~USD~100 |

    
    When send JSON data to topic ms-paymentorder-inbox-topic from file avro/ingester/CommandIngesterInvalidCurrencyJSON.json for Application PAYMENT_ORDER
    
    And set timeout session for 30 seconds
 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | MS-Test-PO-CommandIngester-001| paymentOrderId    | eq       | string   | PO~173922~3621~USD~901 |

    
    And Validate if below details not present in db table ms_payment_order 
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | MS-Test-PO-CommandIngester-001    | paymentOrderId  | PO~173922~3621~USD~901 |
      
    
    And set timeout session for 30 seconds

    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
      | MS-Test-PO-CommandIngester-001| eventId    | eq       | string   | 4316e8-3ca-9-cicur-87200 |
      | MS-Test-PO-CommandIngester-001| eventType  | eq       | string   | PaymentOrder.CreateNewPaymentOrder |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-PO-CommandIngester-001| status    | PROCESSED   |
      
      
      #To check outbox entries
      Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-CommandIngester-001| correlationId    | eq       | string   | 4316e8-3ca-9-cicur-87200 |
      | MS-Test-PO-CommandIngester-001| eventType        | eq       | string   | CommandFailed |
      
    And Validate the below details from the db table ms_outbox_events
    #And Validate the below details from the db table ms_outbox_events and check no of record is 1
    | TestCaseID                           | ColumnName     | ColumnValue |
    | MS-Test-PO-CommandIngester-001       | correlationId  | 4316e8-3ca-9-cicur-87200 |
    
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | MS-Test-PO-CommandIngester-001       | status         | DELIVERED   |
      | MS-Test-PO-CommandIngester-001       | payload        | "status": |
      #| MS-Test-PO-CommandIngester-001       | payload        | "failureMessages":[{"message":"Invalid reference type data: bgvggk"|
      
      
      
      