
Feature: ToCheckPaginationGetApi

  Background: Set the test background for HOLDINGS API
  
    Given create a new MS request with code using Restassured arguments ""
    And MS query parameter for Azure env is set to value ""
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    
    And MS request header "Content-Type" is set to "application/json"
    
  Scenario: To check PO GET API is supporting pagination query parameters
  
    #Given enter the tablename ms_reference_data
    #And enter data for table
      #| Fields      | type   | data       |
      #| type        | string | paymentref|
      #| value       | string | paymentpag     |
      #| description | string | desc       |
      
    #Entry1
#
    #And MS request URI is "v1.0.0/payments/orders"
    #And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/popost1.json"
    #When a "POST" request is sent to MS
    #And log all MS response in console
    #Then MS response code should be 200
    #
    #
    #Entry2
    #
    #And MS request URI is "v1.0.0/payments/orders"
    #And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/popost2.json"
    #When a "POST" request is sent to MS
    #And log all MS response in console
    #Then MS response code should be 200
    #
    #Entry3
    #
    #And MS request URI is "v1.0.0/payments/orders"
    #And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/popost3.json"
    #When a "POST" request is sent to MS
    #And log all MS response in console
    #Then MS response code should be 200
    #
    #ActualValidation
    #And MS request URI is "v1.0.0/payments/orders"
    #And MS query parameter "pageNumber" is set to value "1"
    #And MS query parameter "pageSize" is set to value "1"
    #When a "GET" request is sent to MS
    #
    #And log all MS response in console
    #Then MS response code should be 200
    #Then MS JSON property "items" should contain 1 elements
    
  Scenario: To check if each page number contains the correct no of elements  
  
    #And MS request URI is "v1.0.0/payments/orders"
    #And MS query parameter "pageNumber" is set to value "2"
    #And MS query parameter "pageSize" is set to value "1"    
    #When a "GET" request is sent to MS
    #
    #And log all MS response in console
    #Then MS response code should be 200
    #Then MS JSON property "items" should contain 1 elements
    #
    #And MS request URI is "v1.0.0/payments/orders"
    #And MS query parameter "pageNumber" is set to value "3"
    #And MS query parameter "pageSize" is set to value "1"
    #When a "GET" request is sent to MS
    #
    #And log all MS response in console
    #Then MS response code should be 200
    #Then MS JSON property "items" should contain 1 elements
