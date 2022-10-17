Feature: ReportGeneration   
  
#  Background: To set the preconfig for the scenarios
#  
#    Given Set the test backgound for PAYMENT_ORDER API
#    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
#    Given MS query parameter for Azure env is set to value ""
#    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
#    And MS request header "Content-Type" is set to "application/json"
#    		
#  Scenario: Create a new Payment Order with Extension Data in Payload(Prerequisite)
#  
#  
#  To insert the Payment reference details into the DB for testing purpose
#  Given enter the tablename ms_reference_data
#  And enter data for table
#  | Fields   | type | data|
#  | type | string |paymentref|
#  | value | string |paytesterigsql2|
#  | description | string |Payment ref|
#    
#    And MS request URI is "v1.0.0/payments/orders" 
#	And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/SQL/CreatePOWithExtensionData_IngesterErasure4.json"
#	When a "POST" request is sent to MS 
#	And log all MS response in console 
#	Then MS response code should be 200 
#	And MS JSON property "paymentId" should exist 
#	And MS JSON response string property key "status" should equal value "INITIATED" 
#	
# Scenario: Send Data to topic and validate Report generation functionality
# 
#    Given Set the test backgound for PAYMENT_ORDER API
#    Given Set the Testcase id MS-Test-PO-ReportIngestersql-001 for company GB0010001
#  
#    When Send Data to Topic ms-paymentorder-inbox-topic from file cucumber-json-payload/GDPR/SQL/IngesterReport.json and authorizationFieldName headers.Authorization for Application PAYMENT_ORDER
#    
#    And set timeout session for 30 seconds
#    
#    Then check if json data with event id 9dc99a2c-c3ee-4393-8e58-c4ef920ef02711REPORT and type ms-paymentorder.ExecuteSubjectAccessRequest is present in topic ms-paymentorder-inbox-topic with count should be equal to 1
#
#
#      
#    Then Set the following data criteria
#      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
#      | MS-Test-PO-ReportIngestersql-001| eventId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920ef02711REPORT |
#      | MS-Test-PO-ReportIngestersql-001| eventType  | eq       | string   | ms-paymentorder.ExecuteSubjectAccessRequest |
#
#    And Validate the below details from the db table ms_inbox_events and check no of record is 1
#      | TestCaseID                    | ColumnName | ColumnValue |
#      | MS-Test-PO-ReportIngestersql-001| status    | PROCESSED   |