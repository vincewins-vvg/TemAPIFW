  
  #BalajiLakshmiNarayanan
  
  Feature: 03_jwt-getapi
  
  Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    And MS query parameter for Azure env is set to value ""
    
   
  Scenario: To verify the responses when a valid jwt token is passed in PO GET Api
  
    #Creating a PO entry for retrieving it in GET Api 
    
    Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    And MS request URI is "payments/orders"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/CreatePaymentOrderjwt3.json"
    When a "POST" request is sent to MS
    And log all MS response in console
    #Then MS response code should be 200
    Then MS response code should be 200
   
   #Actual retrieving via PO GET Api   
    And create a new MS request with code using Restassured arguments "GET_PAYMENTODER_AUTH_CODE"
    #Valid Token is passed in authorization
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    
    Given MS request URI is "payments/orders/PO~112~222~USD~121"
    When a "GET" request is sent to MS
    And log all MS response in console
    #Then MS response code should be 200
    Then MS response code should be 200
    #Then MS JSON property "items" should contain at least 1 elements 
    
       
    
  Scenario: To verify the responses when authorization header is not passed in PO GET Api
  
  
    And create a new MS request with code using Restassured arguments "GET_PAYMENTODER_AUTH_CODE"
    #Authorization is not sent in header
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    
    Given MS request URI is "payments/orders/PO~112~222~USD~121"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    And MS JSON response string property key "message" should equal value "[Token authentication failed]"
    
 Scenario: To verify the responses when token passed in expired in PO GET Api
  
  
  
    And create a new MS request with code using Restassured arguments "GET_PAYMENTODER_AUTH_CODE"
    #Token passed below is expired
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkFETUlOIiwiaWF0IjoxNTg5NTkzMTQwLCJleHAiOjExMjExMjkxNDJ9.Vhzn-zmltzUTeuTnZHRK_bduZdKEJilnobjahHh2AdDA5bOQ9_De-VuDmDYz68KzqCP25J6PEFRh1LK8z5146J9TMLRXOQvj3hhKR-vT7pGiLufYjKzdVOME-DNmb4aIAgA3AQ5kz5ke3aUmRX-EzSnk_GIt7cJcc246p8Kzzkgz6iXowHDrDC7dlOSKY-OO064KeOYglOYUG4NnUXjVJYoKl_lM4JF7_5cZ3TDp-1i2v5jT-AS-pc0oG8ibqfLzF_FlCYk3jedrnZwT4Gig4cEMMHEX1AEdLH6vPL93jjcgaz0ivzc_CjpGx7OQZtstoJBGivNk5mjX1yFEX8wNMA"
    And MS request header "Content-Type" is set to "application/json"
    Given MS request URI is "payments/orders/PO~112~222~USD~121"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    And MS JSON response string property key "message" should equal value "[Token authentication failed]"
       
 
 Scenario: To verify the responses when token passed in invalid in PO GET Api
  
  
    And create a new MS request with code using Restassured arguments "GET_PAYMENTODER_AUTH_CODE"
    #Token passed below is invalid
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4ascvNjQ3MzI4OSIsInJvbGVJZCI6IkFETUlOIiwiaWF0IjoxNTg5NTkzMTQwLCJleHAiOjExMjExMjkxNDJ9.Vhzn-zmltzUTeuTnZHRK_bduZdKEJilnobjahHh2AdDA5bOQ9_D e-VuDmDYz68KzqCP25J6PEFasvd Rh1LK8z5146J9TMLRXOQvj3hhKR-vT7pGiLufYjKzdVOME-DNmb4aIAgA3AQ5kz5ke3aUmRX-EzSnk_GIt7cJcc246p8Kzzkgz6iXowHDrDC7dlOSKY-OO064KeOYglOYUG4NnUXjVJYoKl_lM4JF7_5cZ3TDp-1i2v5jT-AS-pc0oG8ibqfLzF_FlCYk3jedrnZwT4Gig4cEMMHEX1AEdLH6vPL93jjcgaz0ivzc_CjpGx7OQZtstoJBGivNk5mjX1yFEX8wNMA"
    And MS request header "Content-Type" is set to "application/json"
    Given MS request URI is "payments/orders/PO~112~222~USD~121"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    And MS JSON response string property key "message" should equal value "[Token authentication failed]"
    
 Scenario: To verify the responses when null is passed as part of authorization header in PO GET Api
      
    And create a new MS request with code using Restassured arguments "GET_PAYMENTODER_AUTH_CODE"
    #Authorization header is passed as null
    And MS request header "Authorization" is set to "null"
    And MS request header "Content-Type" is set to "application/json"
    Given MS request URI is "payments/orders/PO~112~222~USD~121"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 401
    And MS JSON response string property key "message" should equal value "[Token authentication failed]"  
    
 