
  Feature: CheckInboxOutboxEntriesForGET
  

  Scenario Outline: Create a new Payment Order for checking IO box entries
  
  #To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |payiobg|
  | description | string |Payment ref|
  
    Given Set the test backgound for PAYMENT_ORDER API
    And Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"    
    
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200
    
    
    
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders/PO~100-CBE~233-IOBC~INR~126"
    And MS query parameter for Azure env is set to value ""
    And create a new MS request with code using Restassured arguments "GET_PAYMENTODER_AUTH_CODE"
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "UUID" is set to "fda5244e-a140-470e-83ad-768cb225777"
    And MS request header "Content-Type" is set to "application/json"
    When a "GET" request is sent to MS
    Then MS response code should be 200
    
    
    
    And set timeout session for 30 seconds
    
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
      | MS-Test-Payments-MS-001       | eventId    | eq       | string   | fda5244e-a140-470e-83ad-768cb225777 |
      | MS-Test-Payments-MS-001       | eventType  | eq       | string   | GetPaymentOrder |
      
    And Validate the below details from the db table ms_inbox_events and check no of record is 1
        
      | TestCaseID                    | ColumnName | ColumnValue|
      | MS-Test-Payments-MS-001       | status     | PROCESSED |
  
   
   And set timeout session for 30 seconds
   And set timeout session for 30 seconds
     
  
    #Check the entries in outbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-Payments-MS-001       | correlationId    | eq       | string   | fda5244e-a140-470e-83ad-768cb225777 |
      | MS-Test-Payments-MS-001       | eventType        | eq       | string   | CommandProcessed |
      | MS-Test-Payments-MS-001       | status           | eq       | string   | DELIVERED |
      
    And Validate the below details from the db table ms_outbox_events and check no of record is 1
      | TestCaseID                    | ColumnName    | ColumnValue |
      | MS-Test-Payments-MS-001       | eventType     | CommandProcessed |
      
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"233-IOBC","paymentReference":"payiobg","paymentDetails":"Success","currency":"INR","amount":126,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    