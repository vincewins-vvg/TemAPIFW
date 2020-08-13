 #BalajiLakshmiNarayanan
 
  Feature: 17_UploadWithoutFileAttached
  
  Background: To set the preconfig for the scenarios
    
    Given MS query parameter for Azure env is set to value ""
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
      
  
   Scenario: To upload a file without document file query param 
    
    Given MS request header "Content-Type" is set to "multipart/form-data"
    And create a new MS request with code using Restassured arguments "FILEUPLOAD"
    And MS request form-data "documentDetails" is set to "{"documentId":"19","documentName":"Text Doc"}"
    #And upload document with key "textDoc" from file path "src/test/resources/cucumber-json-payload/TextDoc1.txt"
    And MS request URI is "payments/upload"
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
          