
  Feature: InvalidPaymentReference
  
  Background: To setup the preconfigs
  
    Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders"
    And MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
  
   Scenario Outline: Create a new Payment Order with incorrect value as references

    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 400
    #And MS JSON response string property key "message" should contain value "Invalid reference type data"
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"123-PAY","paymentReference":"paytetxcv","paymentDetails":"Success","currency":"USD","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
  
   Scenario Outline: Create a new Payment Order with proceeding space

    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    #Then MS response code should be 400
    #And MS JSON response string property key "message" should contain value "Invalid reference type data"
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"123-SPC","paymentReference":"paytest ","paymentDetails":"Success","currency":"USD","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    Scenario Outline: Create a new Payment Order with reference value as null
  
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 400
    #And MS JSON response string property key "message" should contain value "Invalid reference type data"
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"123-INVP","paymentReference":"","paymentDetails":"Success","currency":"USD","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|