#Author:Vinoth
  Feature: CreateBULKPaymentOrder
  
  Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    Given MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    

  
  Scenario: Create a new Bulk Payment Order
  
    And MS request URI is "v1.0.0/payments/allorders"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/BulkPaymentOrder.json"
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "paymentId" should exist
    
   Scenario: To get created PO1

    And MS request URI is "v1.0.0/payments/orders/PO~1002~10002~INR~200"
    And MS request header "serviceid" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And MS query parameter for Azure env is set to value ""
    And log all MS response in console
    Then MS response code should be 200
    
     Scenario: To get created PO2

    And MS request URI is "v1.0.0/payments/orders/PO~1001~10001~INR~100"
    And MS request header "serviceid" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    When a "GET" request is sent to MS
    And MS query parameter for Azure env is set to value ""
    And log all MS response in console
    Then MS response code should be 200
    
   Scenario: Update exisitng Bulk Payment Order
    
    
    Given MS request URI is "v1.0.0/payments/allorders/update"
    And create a new MS request with code using Restassured arguments "UPDATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/UpdateBulkPaymentOrder.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    
    Scenario Outline: To get Updated PO1

    And MS request header "serviceid" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    And MS request URI is "v1.0.0/payments/orders/PO~1001~10001~INR~100"
    When a "GET" request is sent to MS
    And MS query parameter for Azure env is set to value ""
    And log all MS response in console
    Then MS response code should be 200
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |{"paymentOrder":{"fromAccount":"1001","toAccount":"10001","paymentDetails":"Success","currency":"INR","fileOverWrite":false,"paymentDate":"2020-06-01","paymentMethod":{"id":100,"name":"paymentmethod","extensionData":{},"card":{"cardid":1,"cardname":"allwin"}},"exchangeRates":[{"name":"allwin"}],"extensionData":{}},"paymentStatus":{"paymentId":"PO~1001~10001~INR~100","details":"Success"}}|
    
    Scenario Outline: To get Updated PO2

    And MS request header "serviceid" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    And MS request URI is "v1.0.0/payments/orders/PO~1002~10002~INR~200"
    When a "GET" request is sent to MS
    And MS query parameter for Azure env is set to value ""
    And log all MS response in console
    Then MS response code should be 200
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |{"paymentOrder":{"fromAccount":"1002","toAccount":"10002","paymentDetails":"Success","currency":"INR","fileOverWrite":false,"extensionData":{},"paymentDate":"2020-06-01"},"paymentStatus":{"paymentId":"PO~1002~10002~INR~200","details":"Success"}}|
    
   Scenario: Delete exisitng Bulk Payment Order
    
    
    Given MS request URI is "v1.0.0/payments/allorders/delete/PO~1002~10002~INR~200,PO~1001~10001~INR~100"
    And create a new MS request with code using Restassured arguments "DELETE_PAYMENTORDER_AUTH_CODE"
    When a "DELETE" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    
    Scenario Outline: To get Deleted PO1

    And MS request header "serviceid" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    And MS request URI is "v1.0.0/payments/orders/PO~1002~10002~INR~200"
    When a "GET" request is sent to MS
    And MS query parameter for Azure env is set to value ""
    And log all MS response in console
    #Then MS response code should be 404
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |{}|
    
    Scenario Outline: To get Deleted PO2

    And MS request header "serviceid" is set to "client"
    And MS request header "channelid" is set to "web"
    And MS request header "customfilterid" is set to "test"
    And MS request URI is "v1.0.0/payments/orders/PO~1001~10001~INR~100"
    When a "GET" request is sent to MS
    And MS query parameter for Azure env is set to value ""
    And log all MS response in console
    #Then MS response code should be 404
    Then check if actual response matches the expected static response <response>
    
    Examples:
    |response|
    |{}|

    
    
  
    
  