Feature: ErasureAndNullify_Validation
  
  Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    Given MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    		

  Scenario: Create a new Payment Order with Extension Data in Payload(Prerequisite)
  
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytesterasure9|
  | description | string |Payment ref|
    
    And MS request URI is "v1.0.0/payments/orders" 
	And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/SQL/CreatePOWithExtensionData_Erasure2.json"
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "paymentId" should exist 
	And MS JSON response string property key "status" should equal value "INITIATED" 
	

   # Erasing the data before nullify
    Scenario: Erasing the data before nullify
    
    And Set the Testcase id MS-Test-ER-20 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/457.ERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/SQL/Erasure2.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "erasureRequestId" should equal value "457.ERASURE"
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "PO~353-ER9~321-ZXC~INR~125"
    
    #And set timeout session for 60 seconds

    Then Set the following data criteria
      | TestCaseID        | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-20    | paymentOrderId    | eq       | string   | PO~353-ER9~321-ZXC~INR~125 |

    
    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID       | ColumnName       | ColumnValue |
      | MS-Test-ER-20    | paymentOrderId   | PO~353-ER9~321-ZXC~INR~125 |
      | MS-Test-ER-20    | status           | SSSSSSSSS | 
      | MS-Test-ER-20    | amount           | 999.99 |
     # | MS-Test-ER-20    | currency         | NNN |
      #| MS-Test-ER-20    | paymentDate      | 9999-12-31 |
      | MS-Test-ER-20    | paymentDetails   | XXXXXXXXX |
      | MS-Test-ER-20    | paymentReference | QQQQQQQQQQQQQQQ | 
     
    
 #And Validate the below details from the db table payeedetails and check no of record is 1
 
  #   | MS-Test-ER-20    | payeeDetails.payeeName  | ********* |
  #   | MS-Test-ER-20    | payeeDetails.payeeType  | 1111 |
  #   | MS-Test-ER-20   | PaymentOrder.PayeeDetails.payeeId| 99 |
      
  #And Validate the below details from the db table exchangerate and check no of record is 1
  
 #    | MS-Test-ER-20    | PaymentOrder.exchangeRates.id| 9 |
 #   | MS-Test-ER-20    | PaymentOrder.exchangeRates.name| NNNNNN |
 #   | MS-Test-ER-20    | PaymentOrder.exchangeRates.value| 99.0 |
      
 #And Validate the below details from the db table paymentmethod and check no of record is 1
 
  #    | MS-Test-ER-20    | PaymentOrder.PaymentMethod.name| XXXXXXXXXXXXX |
  #   | MS-Test-ER-20    | PaymentOrder.PaymentMethod.id| 9 |
      
#And Validate the below details from the db table card and check no of record is 1

    #  | MS-Test-ER-20    | PaymentOrder.PaymentMethod.card.cardname| TTTTTT |
    # | MS-Test-ER-20    | PaymentOrder.PaymentMethod.card.cardid| 9 |
    #| MS-Test-ER-20    | PaymentOrder.PaymentMethod.card.cardlimit| 9.99 |
      
     # Retrieve after erasure_Validation
    Scenario: Retrieve the above erased entry
    
    And Set the Testcase id MS-Test-ER-21 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/141.ERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/SQL/Report2.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/SQL/ReportResult2.json"
    
     #Nullifying the above erased data
     Scenario: Nullifying the above erased data
    
    And Set the Testcase id MS-Test-ER-20 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/456.ERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/SQL/Nullify1.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "erasureRequestId" should equal value "456.ERASURE"
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "PO~353-ER9~321-ZXC~INR~125"
    
    Scenario: Retrieve the above nullified entry
    
    And Set the Testcase id MS-Test-ER-21 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/142.ERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/SQL/Report3.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/SQL/ReportResult3.json"
    
     #Nullifying the same nullified entry to check duplication response
     Scenario: Nullifying the same nullified entry to check duplication response
    
    And Set the Testcase id MS-Test-ER-20 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/456.ERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/SQL/Nullify1.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "erasureRequestId" should equal value "456.ERASURE"
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "PO~353-ER9~321-ZXC~INR~125"
    
    Scenario: Retrieve the above nullified entry for duplicate validation
    
    And Set the Testcase id MS-Test-ER-21 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/142.ERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/SQL/Report3.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/SQL/ReportResult3.json"
    
    # Erasing the above nullified data again to check the reponse
    
    Scenario: Erasing the above nullified data again to check the reponse
    
    And Set the Testcase id MS-Test-ER-20 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/459.ERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/SQL/Erasure2.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "erasureRequestId" should equal value "459.ERASURE"
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "PO~353-ER9~321-ZXC~INR~125"
    
    #And set timeout session for 60 seconds

    Then Set the following data criteria
      | TestCaseID        | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-20    | paymentOrderId    | eq       | string   | PO~353-ER9~321-ZXC~INR~125 |

    
    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID       | ColumnName       | ColumnValue |
      | MS-Test-ER-20    | paymentOrderId   | PO~353-ER9~321-ZXC~INR~125 |
     
      
     # Retrieve after erasure_Validation
   Scenario: Retrieving the above erasure  after nullified data to check any update takes place
    
    And Set the Testcase id MS-Test-ER-21 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/142.ERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/SQL/Report3.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/SQL/ReportResult3.json"
   