#Sabapathy
#MFW-2101

Feature: Query param split enable (Azure)

#temn.msf.requestparam.comma.split.enable : false (By default true)


Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    Given MS query parameter for Azure env is set to value "" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
  
  Scenario: To get Multicurrency values using query param
   And MS request URI is "v1.0.0/payments/orders/currencymulti"
   And MS query parameter "currency" is set to value "INR,USD"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And MS query parameter for Azure env is set to value ""
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200