
  Feature: IOForInvalidRequests
  

  Scenario Outline: Create a new Payment Order for checking IO box entries for invalid requests

    Given Set the test backgound for PAYMENT_ORDER API
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders"
    And MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    And MS request header "UUID" is set to "fda5244e-a140-470e-83ad-768cb2257778"
    And Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS 
    
    
    
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
      | MS-Test-Payments-MS-001       | eventId    | eq       | string   | fda5244e-a140-470e-83ad-768cb2257778 |      
      | MS-Test-Payments-MS-001       | eventType  | eq       | string   | GetPaymentOrder |

    
    And Validate if below details not present in db table ms_inbox_events
    
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-Payments-MS-001       | status     | PROCESSED |
      
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-Payments-MS-001       | correlationId    | eq       | string   | fda5244e-a140-470e-83ad-768cb2257778 |      
      | MS-Test-Payments-MS-001       | eventType        | eq       | string   | CommandProcessed |

    
    And Validate if below details not present in db table ms_outbox_events
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-Payments-MS-001       | eventType  | CommandProcessed |
  
      
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"232-IOBC","paymentReference":"xxxx","paymentDetails":"Success","currency":"INR","amount":126,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    