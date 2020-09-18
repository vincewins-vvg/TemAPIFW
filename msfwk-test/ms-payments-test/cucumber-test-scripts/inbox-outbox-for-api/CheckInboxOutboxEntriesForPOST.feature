
  Feature: CheckInboxOutboxEntriesForPOST
  

  Scenario Outline: Create a new Payment Order for checking IO box entries
  
  #To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |payiop|
  | description | string |Payment ref|
  
    Given Set the test backgound for PAYMENT_ORDER API
    And Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders"
    And MS query parameter for Azure env is set to value ""
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    And MS request header "UUID" is set to "fda5244e-a140-470e-83ad-768cb225510" 
    
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    
    
    And set timeout session for 30 seconds
    
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
      | MS-Test-Payments-MS-001       | eventId    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510 |
      | MS-Test-Payments-MS-001       | eventType    | eq       | string   | CreateNewPaymentOrder |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1
    
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-Payments-MS-001       | status     | PROCESSED |


    And set timeout session for 30 seconds
    And set timeout session for 30 seconds
    
     #Check the entries in outbox for Correlation Id
    Then Set the following data criteria
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-Payments-MS-001       | correlationId    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510 |  
      
    #And Validate the below details from the db table ms_outbox_events and check no of record is 3
    And Validate the below details from the db table ms_outbox_events
      | TestCaseID                    | ColumnName    | ColumnValue |
      | MS-Test-Payments-MS-001       | correlationid | fda5244e-a140-470e-83ad-768cb225510 |
  
    #Check the entries in outbox for eventtype and status value
    Then Set the following data criteria
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-Payments-MS-001       | correlationId    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510 |
      | MS-Test-Payments-MS-001       | eventType        | eq       | string   | CommandProcessed |
      | MS-Test-Payments-MS-001       | status           | eq       | string   | DELIVERED |
    
      
    #And Validate the below details from the db table ms_outbox_events and check no of record is 3
    And Validate the below details from the db table ms_outbox_events
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-Payments-MS-001       | eventType  | CommandProcessed |
      
    #Check the entries in outbox
    #Then Set the following data criteria
      #| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001       | correlationid    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510 |
      #| MS-Test-Payments-MS-001       | eventtype      | eq       | string   | POAccepted |
      #
    #And Validate the below details from the db table ms_outbox_events
      #| TestCaseID                    | ColumnName | ColumnValue |
      #| MS-Test-Payments-MS-001       | correlationid | fda5244e-a140-470e-83ad-768cb225510 |
      #| MS-Test-Payments-MS-001       | eventtype    | POAccepted |
      #| MS-Test-Payments-MS-001       | status    | DELIVERED |   
 
 

      
     #Check the entries in outbox
    #Then Set the following data criteria
      #| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001       | correlationid    | eq       | string   | fda5244e-a140-470e-83ad-768cb225510 |
      #| MS-Test-Payments-MS-001       | eventtype    | eq       | string   | PaymentOrder.UpdatePaymentOrder  |  
      #
    #And Validate the below details from the db table ms_outbox_events
      #| TestCaseID                    | ColumnName | ColumnValue |
      #| MS-Test-Payments-MS-001       | correlationid | fda5244e-a140-470e-83ad-768cb225510 |
      #| MS-Test-Payments-MS-001       | eventtype    | PaymentOrder.UpdatePaymentOrder |
      #| MS-Test-Payments-MS-001       | status    | DELIVERED |
      
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"232-IOBC","paymentReference":"payiop","paymentDetails":"Success","currency":"INR","amount":125,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    