Feature: 02_OnlyPageNumber

    Background: To set the preconfig for the scenarios
  
    Given create a new MS request with code using Restassured arguments ""    
    And MS query parameter for Azure env is set to value ""
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    
    And MS request header "Content-Type" is set to "application/json"
    And MS request URI is "payments/orders"

  Scenario: To check PO GET API for pagination with only page number query parameter
    
    And MS query parameter "pageNumber" is set to value "1" 
    
    When a "GET" request is sent to MS
    Then MS response code should be 200
    Then MS JSON property "items" should contain at most 100 elements

   
   
   Scenario: To check PO GET API for pagination with only page number query parameter with page number 2[Data less than 100]
    
    And MS query parameter "pageNumber" is set to value "2" 
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    Then MS JSON property "items" should contain at most 100 elements
   
       