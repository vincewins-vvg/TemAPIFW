Feature: EventIngester    

 Scenario Outline: Send Data to topic for an existing Payment Order
  

  #To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |payeven|
  | description | string |Payment ref|
  
        
    Given Set the test backgound for PAYMENT_ORDER API
    And Set the Testcase id MS-Test-PO-EventIngester-001 for company GB0010001
    Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders"
    And MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200

    When Send Data to Topic paymentorder-event-topic from file avro/ingester/CreatePOEventIngester.json for Application PAYMENT_ORDER
   
    And set timeout session for 30 seconds

    Then Set the following data criteria
      | TestCaseID                      | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-PO-EventIngester-001    | paymentOrderId    | eq       | string   | PO~100-CBE~232-EVEN~INR~125 |
      | MS-Test-PO-EventIngester-001    | status            | eq       | string   | Completed |

    
    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID                      | ColumnName      | ColumnValue |
      | MS-Test-PO-EventIngester-001    | paymentOrderId  | PO~100-CBE~232-EVEN~INR~125 |  
    
    And set timeout session for 30 seconds
    
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
      | MS-Test-PO-EventIngester-001  | eventId    | eq       | string   | 6f7cd466-2dea-45ac-999b-c61eb54ae81d11 |
      | MS-Test-PO-EventIngester-001  | eventType  | eq       | string   | ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1    
      | TestCaseID                   | ColumnName | ColumnValue |
      | MS-Test-PO-EventIngester-001 | eventId    | 6f7cd466-2dea-45ac-999b-c61eb54ae81d11 |
      

    #Outbox entries removed as part of MSF-2442
    #to check if no entry for the event in Outbox
      Then Set the following data criteria
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-EventIngester-001  | correlationId    | eq       | string   | 6f7cd466-2dea-45ac-999b-c61eb54ae81d11 |

    
      And Validate if below details not present in db table ms_outbox_events 
      | TestCaseID                   | ColumnName       | ColumnValue |
      | MS-Test-PO-EventIngester-001 | correlationId    | 6f7cd466-2dea-45ac-999b-c61eb54ae81d11 |
    
    
   #To check API response for the PO record created above
   
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "v1.0.0/payments/orders/PO~100-CBE~232-EVEN~INR~125"
    And MS query parameter for Azure env is set to value ""
    And MS request header "Content-Type" is set to "application/json"
    And MS request header "serviceid" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "paymentOrder.amount" should exist
    And check full response with expected json content from file path "src/test/resources/static-response/GetPaymentOrderResponseForEventIngester.json" 
      
    Examples:    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"232-EVEN","paymentReference":"payeven","paymentDetails":"Success","currency":"INR","amount":125,"expires":10,"fileContent":"dGVzdA==","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
  #Author: Sabapathy
  #MSF-2472
  Scenario Outline: Business failure in Prehook/Posthook/Process 
  
  #To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |payfail|
  | description | string |Payment ref|
  
        
    Given Set the test backgound for PAYMENT_ORDER API
    And Set the Testcase id BusinessFailure for company GB0010001
    Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders"
    And MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    #And log all MS response in console
    Then MS response code should be 200
	
	#1.SequenceCompleted with prehook failure
	
	#Delete existing record in Inbox
	And Delete Record in the table ms_inbox_events for the following criteria
    | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
    | BusinessFailure    | eventId    | eq       | string   | 148313a7-ff3a-45d3-b34b-169adbd62001 | 
    
  #SequenceCompleted with prehook failure event inserted to topic  
   When Send Data to Topic paymentorder-event-topic from file avro/ingester/SequenceCompletedPrehookFailure.json for Application PAYMENT_ORDER
   
   And set timeout session for 30 seconds
   
   #Check PO's status as "Initiated" for paymentorderId with count as 1
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure    | paymentOrderId    | eq       | string   | PO~101~102~INR~200 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID                      | ColumnName      | ColumnValue |
      | BusinessFailure    | paymentOrderId  | PO~101~102~INR~200 |  
      
    And Validate if the below columns contains values from the db table ms_payment_order
      | TestCaseID            | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | INITIATED   |
    
    #Check the entries in inbox for eventId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| eventId    | eq       | string   | 148313a7-ff3a-45d3-b34b-169adbd62001 |
      
    And Validate the below details from the db table ms_inbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | BusinessFailure       | eventId    | 148313a7-ff3a-45d3-b34b-169adbd62001 |
      | BusinessFailure       | eventType    | ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted |
      
    And Validate if the below columns contains values from the db table ms_inbox_events
      | TestCaseID            | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | PROCESSED   |
      | BusinessFailure       | payload        | "descriptions":"preHookBusinessFailure"|
      
   #check for no entry in outbox
   Then Set the following data criteria
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure  | correlationId    | eq       | string   | 148313a7-ff3a-45d3-b34b-169adbd62001 |

    
      And Validate if below details not present in db table ms_outbox_events 
      | TestCaseID                   | ColumnName       | ColumnValue |
      | BusinessFailure | correlationId    | 148313a7-ff3a-45d3-b34b-169adbd62001 |
      
   #2.SequenceCompleted with posthook failure 
   
   #Delete existing record in Inbox
	And Delete Record in the table ms_inbox_events for the following criteria
    | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
    | BusinessFailure    | eventId    | eq       | string   | 148313a7-ff3a-45d3-b34b-169adbd62002 | 
    
  #SequenceCompleted with posthook failure event inserted to topic  
   When Send Data to Topic paymentorder-event-topic from file avro/ingester/SequenceCompletedPosthookFailure.json for Application PAYMENT_ORDER
   
   And set timeout session for 30 seconds
   
    #Check the entries in inbox for eventId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| eventId    | eq       | string   | 148313a7-ff3a-45d3-b34b-169adbd62002 |
      
    And Validate the below details from the db table ms_inbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | BusinessFailure       | eventId    | 148313a7-ff3a-45d3-b34b-169adbd62002 |
      | BusinessFailure       | eventType    | ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted |
      
    And Validate if the below columns contains values from the db table ms_inbox_events
      | TestCaseID            | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | PROCESSED   |
      | BusinessFailure       | payload        | "descriptions":"postHookBusinessFailure"|
      
   #check for no entry in outbox
   Then Set the following data criteria
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure  | correlationId    | eq       | string   | 148313a7-ff3a-45d3-b34b-169adbd62002 |

    
      And Validate if below details not present in db table ms_outbox_events 
      | TestCaseID                   | ColumnName       | ColumnValue |
      | BusinessFailure | correlationId    | 148313a7-ff3a-45d3-b34b-169adbd62002 |  
      
  #3.SequenceCompleted with process failure 
      
      #Delete existing record in Inbox
	And Delete Record in the table ms_inbox_events for the following criteria
    | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
    | BusinessFailure    | eventId    | eq       | string   | 148313a7-ff3a-45d3-b34b-169adbd62003 | 
    
  #SequenceCompleted with process failure event inserted to topic  
   When Send Data to Topic paymentorder-event-topic from file avro/ingester/SequenceCompletedProcesshookFailure.json for Application PAYMENT_ORDER
   
   And set timeout session for 30 seconds
   
    #Check the entries in inbox for eventId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| eventId    | eq       | string   | 148313a7-ff3a-45d3-b34b-169adbd62003 |
      
    And Validate the below details from the db table ms_inbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | BusinessFailure       | eventId    | 148313a7-ff3a-45d3-b34b-169adbd62003 |
      | BusinessFailure       | eventType    | ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted |
      
    And Validate if the below columns contains values from the db table ms_inbox_events
      | TestCaseID            | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | PROCESSED   |
      | BusinessFailure       | payload        | "descriptions":"processBusinessFailure"|
      
   #check for no entry in outbox
   Then Set the following data criteria
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure  | correlationId    | eq       | string   | 148313a7-ff3a-45d3-b34b-169adbd62003 |

    
      And Validate if below details not present in db table ms_outbox_events 
      | TestCaseID                   | ColumnName       | ColumnValue |
      | BusinessFailure | correlationId    | 148313a7-ff3a-45d3-b34b-169adbd62003 |
      
    Examples:    
    |payload|
    |{"fromAccount":"101","toAccount":"102","paymentReference":"payfail","paymentDetails":"Success","currency":"INR","amount":200,"expires":10,"fileContent":"dGVzdA==","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Test"]}|
    
    