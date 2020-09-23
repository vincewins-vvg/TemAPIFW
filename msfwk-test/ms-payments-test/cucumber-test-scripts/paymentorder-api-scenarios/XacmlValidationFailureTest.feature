   Feature: XacmlValidationFailureTest
  
   Background: To setup the preconfigs
   
    Given Set the test backgound for PAYMENT_ORDER API
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
  
  Scenario Outline: Create a new Payment Order for testing purpose
  
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |payxacm|
  | description | string |Payment ref|
  
    Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
    
    And MS request header "Content-Type" is set to "application/json"
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200   
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"201-XAC","paymentReference":"payxacm","paymentDetails":"Success","currency":"INR","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
  
    Scenario Outline: To get created PO by not passing a xacml header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "serviceid" is set to "client"
    And MS request header "channelid" is set to "web"
    #And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed","code":""}]|
    
    Scenario Outline: To get created PO by not passing value for a xacml header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "serviceid" is set to ""
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed","code":""}]|
    
    Scenario Outline: To get created PO by passing upper case value for a header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "serviceid" is set to "CLIENT"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed","code":""}]|
    
    
    Scenario Outline: To get created PO by passing upper case as value for a XACML header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "serviceid" is set to "CLIENT"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed","code":""}]|
    
    Scenario Outline: To get created PO by passing incorrect value for a header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "serviceidd" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed","code":""}]|
    
    Scenario Outline: To get created PO by passing incorrect value for a header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "serviceid" is set to "clientt"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed","code":""}]|
    
  