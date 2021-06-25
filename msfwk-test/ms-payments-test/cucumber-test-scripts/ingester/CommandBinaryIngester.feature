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

    
    When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/CreatePOBinaryIngester.json for Application PAYMENT_ORDER
    
    And set timeout session for 30 seconds
 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | MS-Test-PO-CommandIngester-001| paymentOrderId    | eq       | string   | PO~1733~3621~USD~901 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | MS-Test-PO-CommandIngester-001    | paymentOrderId  | PO~1733~3621~USD~901 |


    #And set timeout session for 30 seconds
      
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
      | MS-Test-PO-CommandIngester-001| eventId    | eq       | string   | 4316e8-3ca-9-b-8728 |
      | MS-Test-PO-CommandIngester-001| eventType  | eq       | string   | PaymentOrder.CreateNewPaymentOrder |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-PO-CommandIngester-001| status    | PROCESSED   |
      
   #And set timeout session for 30 seconds
   #And set timeout session for 30 seconds
   
    #Check the entries in outbox for correlationId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-CommandIngester-001| correlationId    | eq       | string   | 4316e8-3ca-9-b-8728 |
      
    #And Validate the below details from the db table ms_outbox_events
    And Validate the below details from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | MS-Test-PO-CommandIngester-001       | correlationId    | 4316e8-3ca-9-b-8728 |
      
    #Check the entries in outbox for status and event type values
    Then Set the following data criteria
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-CommandIngester-001| correlationId    | eq       | string   | 4316e8-3ca-9-b-8728 |
      | MS-Test-PO-CommandIngester-001| status           | eq       | string   | DELIVERED |
      | MS-Test-PO-CommandIngester-001| eventType        | eq       | string   | CommandProcessed |
      
    #And Validate the below details from the db table ms_outbox_events and check no of record is 2
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | MS-Test-PO-CommandIngester-001       | eventType      | CommandProcessed | 
      | MS-Test-PO-CommandIngester-001       | payload        | "status":200 |   

      
   #To check API response for the record created above
   
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "v1.0.0/payments/orders/PO~1733~3621~USD~901"
    And MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    And MS request header "serviceid" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/static-response/GetPOResponseForBinaryIngester.json"
    
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
      | MS-Test-PO-CommandIngester-001| status    | FAILED   |
    
    
      #To check outbox entries
     Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-CommandIngester-001| correlationId    | eq       | string   | 4316e8-3ca-9-ab-8728 |
      | MS-Test-PO-CommandIngester-001| eventType        | eq       | string   | CommandFailed |
      
      
    #And Validate the below details from the db table ms_outbox_events
   And Validate the below details from the db table ms_outbox_events and check no of record is 1
    | TestCaseID                           | ColumnName     | ColumnValue |
    | MS-Test-PO-CommandIngester-001       | correlationId  | 4316e8-3ca-9-ab-8728 |
    
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | MS-Test-PO-CommandIngester-001       | status         | DELIVERED   |
      | MS-Test-PO-CommandIngester-001       | payload        | "status":400 |
      #| MS-Test-PO-CommandIngester-001       | payload        | "failureMessages":[{"message":"Record already exists","code":"MSF-002"}]|