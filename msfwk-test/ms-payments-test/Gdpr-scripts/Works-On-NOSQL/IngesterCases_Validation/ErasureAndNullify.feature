Feature: ErasureAndNullify   
  
  Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    Given MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    		
  Scenario Outline: create customer using post method
   
    And MS request URI is "v1.0.0/payments/customers"
	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "customerId" should equal value "IG1"
	And MS JSON response string property key "status" should equal value "Created"

Examples: 
        |payload|
		|{"customerId":"IG1","customerName":"Riya","account":"311-IG1","loanTypes":["education loan","housing loan","car loan"],"dateOfJoining":"2020-08-26"}|
		

  Scenario: Create a new Payment Order with Extension Data in Payload(Prerequisite)
  
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytesterig1|
  | description | string |Payment ref|
    
    And MS request URI is "v1.0.0/payments/orders" 
	And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/NOSQL/CreatePOWithExtensionData_IngesterErasure3.json"
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "paymentId" should exist 
	And MS JSON response string property key "status" should equal value "INITIATED" 
	
 Scenario: Send Data to topic and validate Erasure functionality
 
    Given Set the test backgound for PAYMENT_ORDER API
    Given Set the Testcase id MS-Test-PO-ErasureIngester-001 for company GB0010001
  
    When Send Data to Topic ms-paymentorder-inbox-topic from file cucumber-json-payload/GDPR/NOSQL/IngesterErasure3.json and authorizationFieldName headers.Authorization for Application PAYMENT_ORDER
    
    And set timeout session for 30 seconds
    
    Then check if json data with event id 9dc99a2c-c3ee-4393-8e58-c4ef920ef025ERASURE and type ms-paymentorder.ExecuteCDPErasureRequest is present in topic ms-paymentorder-inbox-topic with count should be equal to 1


    #And set timeout session for 60 seconds
      
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
      | MS-Test-PO-ErasureIngester-001| eventId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920ef025ERASURE |
      | MS-Test-PO-ErasureIngester-001| eventType  | eq       | string   | ms-paymentorder.ExecuteCDPErasureRequest |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-PO-ErasureIngester-001| status    | PROCESSED   |
      
     # Then check if json data with correlation id 9dc99a2c-c3ee-4393-8e58-c4ef920ef025abc and subject commandprocessed is present in topic ms-eventstore-inbox-topic with count should be equal to 1
     
     # Then check if json data with correlation id 9dc99a2c-c3ee-4393-8e58-c4ef920ef025abc and subject event is present in topic ms-eventstore-inbox-topic with count should be equal to 1
      
    Then Set the following data criteria
      | TestCaseID       | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-PO-ErasureIngester-001    | paymentOrderId    | eq       | string   | PO~311-IG1~321-ZXC~INR~125 |

    
    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID                        | ColumnName       | ColumnValue |
      | MS-Test-PO-ErasureIngester-001    | paymentOrderId   | PO~311-IG1~321-ZXC~INR~125 |
      | MS-Test-PO-ErasureIngester-001    | amount           | 999 |
      | MS-Test-PO-ErasureIngester-001    | status           | SSSSSSSSS | 
      | MS-Test-PO-ErasureIngester-001    | amount           | 999 |
     # | MS-Test-PO-ErasureIngester-001    | currency         | NNN |
      | MS-Test-PO-ErasureIngester-001    | paymentDetails   | XXXXXXXXX |
      | MS-Test-PO-ErasureIngester-001    | paymentReference | QQQQQQQQQQQQ | 
     
    
    Scenario: Retrieve the above erased entry
    
    And Set the Testcase id MS-Test-PO-ErasureIngester-002 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/444.INGESTERASURE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/NOSQL/Report6.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ReportResult6.json"
    
    Scenario: Send Data to topic and validate Nullify functionality
 
    Given Set the test backgound for PAYMENT_ORDER API
    Given Set the Testcase id MS-Test-PO-ErasureIngester-003 for company GB0010001
  
    When Send Data to Topic ms-paymentorder-inbox-topic from file cucumber-json-payload/GDPR/NOSQL/IngesterNullify2.json and authorizationFieldName headers.Authorization for Application PAYMENT_ORDER
    
    And set timeout session for 30 seconds
    
    Then check if json data with event id 9dc99a2c-c3ee-4393-8e58-c4ef920ef025NULLIFY and type ms-paymentorder.ExecuteCDPErasureRequest is present in topic ms-paymentorder-inbox-topic with count should be equal to 1


    #And set timeout session for 60 seconds
      
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
      | MS-Test-PO-ErasureIngester-003| eventId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920ef025NULLIFY |
      | MS-Test-PO-ErasureIngester-003| eventType  | eq       | string   | ms-paymentorder.ExecuteCDPErasureRequest |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-PO-ErasureIngester-003| status    | PROCESSED   |
      
     # Then check if json data with correlation id 9dc99a2c-c3ee-4393-8e58-c4ef920ef025abc and subject commandprocessed is present in topic ms-eventstore-inbox-topic with count should be equal to 1
     
     # Then check if json data with correlation id 9dc99a2c-c3ee-4393-8e58-c4ef920ef025abc and subject event is present in topic ms-eventstore-inbox-topic with count should be equal to 1
     
    Scenario: Retrieve the above nullified entry
    
    And Set the Testcase id MS-Test-PO-ErasureIngester-004 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/444.INGESTNULLIFY"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/NOSQL/Report7.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ReportResult7.json"
      