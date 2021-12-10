
   Feature: XacmlValidationFailureTest
  
   Background: To setup the preconfigs
   
    Given Set the test backgound for PAYMENT_ORDER API
    Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders"
    And MS query parameter for Azure env is set to value ""
  
  Scenario Outline: Create a new Payment Order for testing purpose
  
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |payxacm|
  | description | string |Payment ref|
  
    Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders"
    And MS query parameter for Azure env is set to value ""
    
    And MS request header "Content-Type" is set to "application/json"
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200   
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"201-XAC","paymentReference":"payxacm","paymentDetails":"Success","currency":"INR","amount":483,"expires":10,"fileContent":"dGVzdA==","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
  
    Scenario Outline: To get created PO by not passing a xacml header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter "currency" is set to value "INR"
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    #And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "serviceid" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "Content-Type" is set to "application/json"
    #And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed"}]|
    
    Scenario Outline: To get created PO by not passing value for a xacml header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    #And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "serviceid" is set to ""
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    And MS request header "Content-Type" is set to "application/json"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed"}]|
    
    Scenario Outline: To get created PO by passing upper case value for a header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "EYJHBGCIOIJSUZI1NIISINR5CCI6IKPXVCJ9.EYJHDWQIOIJOB2XKAW5NCYISIMLZCYI6IMH0DHBZOI8VBG9JYWXOB3N0OJK0NDMVB2F1DGGYL3RVA2VUIIWIC3VIIJOIMJKWMDA4NJQ3MZI4OSISINJVBGVJZCI6IKJHBGFUY2VWAWV3ZXIILCJPYXQIOJE1ODK1OTMXNDASIMV4CCI6MZYYMTEYOTE0MN0.YYALWJ7QOWWZNDD2MB5ZGTCWK3DGNVWCBBFEEKX7DBVIPILCNLSLYNWRO895LJSP6N-EC_RDEUPKYAUG400MG35SWEW35OJRQH8JSGOFI4LPLDK-XJC18RZ-IBJV_IRJNV97SICFOUJHLZBG64KLYCJKI4EFTAZEZIIXMPYHAW2NW-XREUYDDDQ7TOAJ_9CG-COOTJFRPRZYQKGQEHX20XOU-I-37XVQUHMJ9PRLQAZPS7KVXN-AASPPLUTD7EYQW30FBYQ4PMUSM1_524YFXMLZZV-VHHYUMK8PB1XSLDIZVN9QCBBDDUVSNPYLPTGHOBBFGZ9_GEGJFIKY6YJVZW"
    And MS request header "serviceid" is set to "CLIENT"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    And MS request header "Content-Type" is set to "application/json"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed"}]|
    
    
    Scenario Outline: To get created PO by passing upper case as value for a XACML header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJHBGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "serviceid" is set to "CLIENT"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    And MS request header "Content-Type" is set to "application/json"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed"}]|
    
    Scenario Outline: To get created PO by passing incorrect value for a header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJHbGciOighUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "serviceidd" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    And MS request header "Content-Type" is set to "application/json"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed"}]|
    
    Scenario Outline: To get created PO by passing incorrect value for a header
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTORDERSBYCURRENCY_AUTH_CODE"
    And MS request URI is "v1.0.0/payments/orders/PO~100-CBE~201-XAC~INR~483"
    And MS query parameter for Azure env is set to value ""
    And MS query parameter "currency" is set to value "INR"
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "EYJHBGCIOIJSUZI1NIISINR5CCI6IKPXVCJ9.EYJHDWQIOIJOB2XKAW5NCYISIMLZCYI6IMH0DHBZOI8VBG9JYWXOB3N0OJK0NDMVB2F1DGGYL3RVA2VUIIWIC3VIIJOIMJKWMDA4NJQ3MZI4OSISINJVBGVJZCI6IKJHBGFUY2VWAWV3ZXIILCJPYXQIOJE1ODK1OTMXNDASIMV4CCI6MZYYMTEYOTE0MN0.YYALWJ7QOWWZNDD2MB5ZGTCWK3DGNVWCBBFEEKX7DBVIPILCNLSLYNWRO895LJSP6N-EC_RDEUPKYAUG400MG35SWEW35OJRQH8JSGOFI4LPLDK-XJC18RZ-IBJV_IRJNV97SICFOUJHLZBG64KLYCJKI4EFTAZEZIIXMPYHAW2NW-XREUYDDDQ7TOAJ_9CG-COOTJFRPRZYQKGQEHX20XOU-I-37XVQUHMJ9PRLQAZPS7KVXN-AASPPLUTD7EYQW30FBYQ4PMUSM1_524YFXMLZZV-VHHYUMK8PB1XSLDIZVN9QCBBDDUVSNPYLPTGHOBBFGZ9_GEGJFIKY6YJVZW"
    And MS request header "serviceid" is set to "clientt"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    And MS request header "Content-Type" is set to "application/json"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |[{"message":"Authorization failed"}]|
    
    
  