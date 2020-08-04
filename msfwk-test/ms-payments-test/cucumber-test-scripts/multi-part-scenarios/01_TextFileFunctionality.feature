 #BalajiLakshmiNarayanan
 
  Feature: 01_FileUploadTextFileFunctionality
  
  Background: To set the preconfig for the scenarios
    
    Given create a new MS request with code using Restassured arguments ""
    And MS query parameter for Azure env is set to value ""
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    Given Set the test backgound for HOLDINGS API
      
  Scenario: To upload a text file
    
    Given MS request header "Content-Type" is set to "multipart/form-data"
    And MS request header "UUID" is set to "fda5244e-a140-470e-83ad-fileupload"
    And MS request form-data "documentDetails" is set to "{"documentId":"11","documentName":"Text Doc"}"
    And upload document with key "textDoc" from file path "src/test/resources/cucumber-json-payload/TextDoc1.txt"
    And MS request URI is "payments/upload"
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
      
  #Scenario: To validate the ms_file_upload enty in database post uploading the document
    #Given Set the Testcase id MS-Test-MultiPart-MS-010 for company TRANSACT
    #And set timeout session for 30 seconds
    #Then Set the following data criteria
      #| TestCaseID              | ColumnName | Operator | DataType | ColumnValue    |
      #| MS-Test-MultiPart-MS-010 | documentDetails_id      | eq       | string   | 11 |
    #And Validate the below details from the db table ms_file_upload
      #| TestCaseID              | ColumnName         | ColumnValue                    |
      #| MS-Test-MultiPart-MS-010 | name         | TextDoc1.txt                    |
          
    Scenario: To validate the ms_inbox enty in database post uploading the document
    Given Set the Testcase id MS-Test-MultiPart-MS-011 for company TRANSACT
    And set timeout session for 30 seconds
    Then Set the following data criteria
      | TestCaseID              | ColumnName | Operator | DataType | ColumnValue     |
      | MS-Test-MultiPart-MS-011 | eventType      | eq       | string   | FileUpload |
      | MS-Test-Payments-MS-0011       | eventId    | eq       | string   | fda5244e-a140-470e-83ad-fileupload |
    And Validate the below details from the db table ms_inbox_events
      | TestCaseID               | ColumnName         | ColumnValue                  |
      | MS-Test-MultiPart-MS-011 | status             | PROCESSED                    |
          
   Scenario: To validate the ms_outbox enty in database post uploading the document
    Given Set the Testcase id MS-Test-MultiPart-MS-012 for company TRANSACT
    And set timeout session for 30 seconds
    Then Set the following data criteria
      | TestCaseID               | ColumnName     | Operator | DataType | ColumnValue                         |
      | MS-Test-MultiPart-MS-012 | eventType      | eq       | string   | CommandProcessed                    |
      | MS-Test-Payments-MS-0012 | correlationId | eq        | string   | fda5244e-a140-470e-83ad-fileupload  |
      | MS-Test-MultiPart-MS-012 | status         | eq       | string   | DELIVERED                           |
      
    And Validate the below details from the db table ms_outbox_events
      | TestCaseID               | ColumnName        | ColumnValue                  |
      | MS-Test-MultiPart-MS-012 | status            | DELIVERED                    |
            
    
    Scenario: To download a text file and check its size
    
    And MS request URI is "payments/download/TextDoc1.txt"
    When a "GET" request is sent to MS
    Then MS response code should be 200
    Then check if file download is successful and size is equal to file uploaded from file path "src/test/resources/cucumber-json-payload/TextDoc1.txt"
    And log all MS response in console
    
