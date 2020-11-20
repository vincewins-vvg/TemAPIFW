Feature: 01_jwt-postapi
  
  Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    And MS query parameter for Azure env is set to value ""
    Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
   
  Scenario: To verify the responses when a valid jwt token is passed in PO POST Api
  
  #To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytestcheck1|
  | description | string |Payment ref|
  
    
    #Valid Token is passed in authorization
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    And MS request URI is "v1.0.0/payments/orders"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/CreatePaymentOrderjwt.json"
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "paymentId" should exist
    And MS JSON response string property key "status" should equal value "INITIATED"
    And MS JSON response string property key "details" should equal value "Success"
    
    
  Scenario: To verify the responses when authorization header is not passed in PO POST Api
  
  
    #Authorization is not sent in header
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    And MS request URI is "v1.0.0/payments/orders"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/CreatePaymentOrderjwt.json"
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    And MS JSON response string property key "message" should equal value "[Authorization failed]"
    
 Scenario: To verify the responses when token passed in expired in PO POST Api
  
  
  
    #Token passed below is expired
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkFETUlOIiwiaWF0IjoxNTg5NTkzMTQwLCJleHAiOjExMjExMjkxNDJ9.Vhzn-zmltzUTeuTnZHRK_bduZdKEJilnobjahHh2AdDA5bOQ9_De-VuDmDYz68KzqCP25J6PEFRh1LK8z5146J9TMLRXOQvj3hhKR-vT7pGiLufYjKzdVOME-DNmb4aIAgA3AQ5kz5ke3aUmRX-EzSnk_GIt7cJcc246p8Kzzkgz6iXowHDrDC7dlOSKY-OO064KeOYglOYUG4NnUXjVJYoKl_lM4JF7_5cZ3TDp-1i2v5jT-AS-pc0oG8ibqfLzF_FlCYk3jedrnZwT4Gig4cEMMHEX1AEdLH6vPL93jjcgaz0ivzc_CjpGx7OQZtstoJBGivNk5mjX1yFEX8wNMA"
    And MS request header "Content-Type" is set to "application/json"
    And MS request URI is "v1.0.0/payments/orders"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/CreatePaymentOrderjwt.json"
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    And MS JSON response string property key "message" should equal value "[Authorization failed]"
       
 
 Scenario: To verify the responses when token passed in invalid in PO POST Api
  
  
    #Token passed below is invalid
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4ascvNjQ3MzI4OSIsInJvbGVJZCI6IkFETUlOIiwiaWF0IjoxNTg5NTkzMTQwLCJleHAiOjExMjExMjkxNDJ9.Vhzn-zmltzUTeuTnZHRK_bduZdKEJilnobjahHh2AdDA5bOQ9_D e-VuDmDYz68KzqCP25J6PEFasvd Rh1LK8z5146J9TMLRXOQvj3hhKR-vT7pGiLufYjKzdVOME-DNmb4aIAgA3AQ5kz5ke3aUmRX-EzSnk_GIt7cJcc246p8Kzzkgz6iXowHDrDC7dlOSKY-OO064KeOYglOYUG4NnUXjVJYoKl_lM4JF7_5cZ3TDp-1i2v5jT-AS-pc0oG8ibqfLzF_FlCYk3jedrnZwT4Gig4cEMMHEX1AEdLH6vPL93jjcgaz0ivzc_CjpGx7OQZtstoJBGivNk5mjX1yFEX8wNMA"
    And MS request header "Content-Type" is set to "application/json"
    And MS request URI is "v1.0.0/payments/orders"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/CreatePaymentOrderjwt.json"
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    And MS JSON response string property key "message" should equal value "[Authorization failed]"   
    
 Scenario: To verify the responses when null is passed as part of authorization header in PO POST Api
  
    
    #Authorization header is passed as null
    And MS request header "Authorization" is set to "null"
    And MS request header "Content-Type" is set to "application/json"
    And MS request URI is "v1.0.0/payments/orders"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/CreatePaymentOrderjwt.json"
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    And MS JSON response string property key "message" should equal value "[Authorization failed]"   
    
 