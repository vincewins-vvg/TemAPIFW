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
      
    #And Validate the below details from the db table ms_outbox_events
    And Validate the below details from the db table ms_outbox_events and check no of record is 1
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
      
    #And Validate the below details from the db table ms_outbox_events
    And Validate the below details from the db table ms_outbox_events and check no of record is 1
    | TestCaseID                           | ColumnName     | ColumnValue |
    | MS-Test-PO-CommandIngester-001       | correlationId  | 4316e8-3ca-9-cicur-87200 |
    
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | MS-Test-PO-CommandIngester-001       | status         | DELIVERED   |
      | MS-Test-PO-CommandIngester-001       | payload        | "status":400 |
      | MS-Test-PO-CommandIngester-001       | payload        | "failureMessages":[{"message":"Cannot deserialize value of type|
     
   
   
   Scenario: Send duplicate entry and validate Payment Order functionality (Record already exist)
 

    Given Set the test backgound for PAYMENT_ORDER API
    Given Set the Testcase id MS-Test-PO-CommandIngester-001 for company GB0010001
   
    When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/CreatePOBinaryIngesterDuplicate.json for Application PAYMENT_ORDER
    
   And set timeout session for 30 seconds
      
       Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | MS-Test-PO-CommandIngester-001| paymentOrderId    | eq       | string   | PO~1733~3621~USD~901 |

    
    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | MS-Test-PO-CommandIngester-001    | paymentOrderId  | PO~1733~3621~USD~901 |
    
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
      | MS-Test-PO-CommandIngester-001| eventId    | eq       | string   | 4316e8-3ca-9-ab-8728 |
      | MS-Test-PO-CommandIngester-001| eventType  | eq       | string   | PaymentOrder.CreateNewPaymentOrder |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-PO-CommandIngester-001| status    | PROCESSED   |
    
    
      #To check outbox entries
      Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-CommandIngester-001| correlationId    | eq       | string   | 4316e8-3ca-9-ab-8728 |
      | MS-Test-PO-CommandIngester-001| eventType        | eq       | string   | CommandFailed |
      
      
    #And Validate the below details from the db table ms_outbox_events
   #And Validate the below details from the db table ms_outbox_events
   # | TestCaseID                           | ColumnName     | ColumnValue |
   # | MS-Test-PO-CommandIngester-001       | correlationId  | 4316e8-3ca-9-cicur-87200 |
    
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | MS-Test-PO-CommandIngester-001       | status         | DELIVERED   |
      | MS-Test-PO-CommandIngester-001       | payload        | "status":400 |
      #| MS-Test-PO-CommandIngester-001       | payload        | "failureMessages":[{"message":"Record already exists","code":"MSF-002"}]|
   
   
   Scenario: Send duplicate entry and validate Payment Order functionality (Duplicate)
 

    Given Set the test backgound for PAYMENT_ORDER API
    Given Set the Testcase id MS-Test-PO-CommandIngester-001 for company GB0010001
   
    When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/CreatePOBinaryIngester.json for Application PAYMENT_ORDER
    
   And set timeout session for 30 seconds
      
       Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | MS-Test-PO-CommandIngester-001| paymentOrderId    | eq       | string   | PO~1733~3621~USD~901 |

    
    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | MS-Test-PO-CommandIngester-001    | paymentOrderId  | PO~1733~3621~USD~901 |
     
      #To check outbox entries
      Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-CommandIngester-001| correlationId    | eq       | string   | 4316e8-3ca-9-b-8728 |
      | MS-Test-PO-CommandIngester-001| eventType        | eq       | string   | CommandFailed |
      
      
    #And Validate the below details from the db table ms_outbox_events
   #And Validate the below details from the db table ms_outbox_events
   # | TestCaseID                           | ColumnName     | ColumnValue |
   # | MS-Test-PO-CommandIngester-001       | correlationId  | 4316e8-3ca-9-cicur-87200 |
    
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | MS-Test-PO-CommandIngester-001       | status         | DELIVERED   |
      | MS-Test-PO-CommandIngester-001       | payload        | "status":404 |
      | MS-Test-PO-CommandIngester-001       | payload        | "failureMessages":[{"message":"Duplicate record found","code":"MSF-999"}]|
   
  # Author: Sabapathy
  # MSF-2213 
  Scenario: Validate Command Event without JWT token as header
 
	#Delete existing record in ms_reference_table
	Given Set the test backgound for PAYMENT_ORDER API
  Given Set the Testcase id WithoutJWTToken for company GB0010001
  And Delete Record in the table ms_reference_data for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | WithoutJWTToken    | value    | eq       | string   | PayRef |
  
  #Insert record in ms_reference_table
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |PayRef |
  | description | string |Payment ref|
  
	#Delete existing record in Outbox table
   And Delete Record in the table ms_outbox_events for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | WithoutJWTToken    | correlationId    | eq       | string   | 1a316d88-3c7-4-ad7e-1001 |

   #Send Command Event data without JWT Token as header to topic 
   When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/CreatePOBinaryIngesterWithoutJWT.json for Application PAYMENT_ORDER
    
    And set timeout session for 30 seconds
    
    #Check for no entries in PO table 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | WithoutJWTToken| paymentOrderId    | eq       | string   | PO~101~102~USD~10 |
    
     And Validate if below details not present in db table ms_payment_order 
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | WithoutJWTToken    | paymentOrderId  | PO~101~102~USD~10 |
    
    And set timeout session for 30 seconds
 
    #Check the entries in outbox for correlationId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | WithoutJWTToken| correlationId    | eq       | string   | 1a316d88-3c7-4-ad7e-1001 |
      
    #And Validate the below details from the db table ms_outbox_events
    And Validate the below details from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | WithoutJWTToken       | correlationId    | 1a316d88-3c7-4-ad7e-1001 |
      | WithoutJWTToken       | eventType    | CommandFailed |
      
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | WithoutJWTToken       | status         | DELIVERED   |
      | WithoutJWTToken       | payload        | "status":401 |
      | WithoutJWTToken      | payload        | "failureMessages":[{"message":"Authorization failed","code":"MSF-003"}]|
   
     
      
      
      
      