Feature: ListOfStringErasure_Validation
  
  Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    Given MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    		
#Validating the above list of strings with invalid datatype and without erasure options    		
  Scenario Outline: Validating the above list of strings with invalid datatype and without erasure options
   
    And Set the Testcase id MS-Test-LS-01 for company GB0010001
    And MS request URI is "v1.0.0/payments/customers"
	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 201 
	And MS JSON response string property key "customerId" should equal value "LS1"
	And MS JSON response string property key "status" should equal value "Created"
              

Examples: 
        |payload|
		|{"customerId":"LS1","customerName":"Riya","account":"352-LS1","loanTypes":["education loan","Personal loan","Car loan","Housing loan","Bike loan"],"dateOfJoining":"2020-08-26"}|
	
Scenario: to retrieve a customer using query param account to check the loan types

    And MS request URI is "v1.0.0/payments/customers"
    Then MS query parameter "account" is set to value "352-LS1" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "customerId" should equal value "[LS1]"
	And MS JSON response string property key "customerName" should equal value "[Riya]"
	And MS JSON response string property key "account" should equal value "[352-LS1]"
	And MS JSON response string property key "dateOfJoining" should equal value "[2020-08-26]"
	And MS JSON response string property key "loanTypes[0][0]" should equal value "education loan"
	And MS JSON response string property key "loanTypes[0][1]" should equal value "Personal loan"
	And MS JSON response string property key "loanTypes[0][2]" should equal value "Car loan"
	And MS JSON response string property key "loanTypes[0][3]" should equal value "Housing loan"
	And MS JSON response string property key "loanTypes[0][4]" should equal value "Bike loan"

    Scenario Outline: Erasing the above created entry
    
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/233.LSERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "LS1"

  Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LS1","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"string"}]}]}]}|
    
      
     # Retrieve after erasure_Validation
 Scenario: Retrieve the above erased entry
    
    And Set the Testcase id MS-Test-LS-21 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/111.LSERASURE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/NOSQL/Report8.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON response string property key "requestId" should equal value "111.LSERASURE"
    And MS JSON response string property key "reportType" should equal value "SAR"
    And MS JSON response string property key "partyId" should equal value "205761453936"
    And MS JSON response string property key "customerId" should equal value "LS1"
    And MS JSON response string property key "serviceId" should equal value "PARTY"
    And MS JSON response string property key "statusCode" should equal value "200"
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ReportResult8.json"
    
     #Validating the above list of strings with valid datatype and with erasure options (ALPHA)  		
  Scenario Outline: Validating the above list of strings with valid datatype and with erasure options (ALPHA)
   
    And Set the Testcase id MS-Test-LS-02 for company GB0010001
    And MS request URI is "v1.0.0/payments/customers"
	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 201 
	And MS JSON response string property key "customerId" should equal value "LS2"
	And MS JSON response string property key "status" should equal value "Created"

Examples: 
        |payload|
		|{"customerId":"LS2","customerName":"Riya","account":"352-LS2","loanTypes":["education loan","Personal loan","Car loan","Housing loan","Bike loan"],"dateOfJoining":"2020-08-26"}|
		

Scenario: to retrieve a customer using query param account to check the loan types

    And MS request URI is "v1.0.0/payments/customers"
    Then MS query parameter "account" is set to value "352-LS2" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "customerId" should equal value "[LS2]"
	And MS JSON response string property key "customerName" should equal value "[Riya]"
	And MS JSON response string property key "account" should equal value "[352-LS2]"
	And MS JSON response string property key "dateOfJoining" should equal value "[2020-08-26]"
	And MS JSON response string property key "loanTypes[0][0]" should equal value "education loan"
	And MS JSON response string property key "loanTypes[0][1]" should equal value "Personal loan"
	And MS JSON response string property key "loanTypes[0][2]" should equal value "Car loan"
	And MS JSON response string property key "loanTypes[0][3]" should equal value "Housing loan"
	And MS JSON response string property key "loanTypes[0][4]" should equal value "Bike loan"
	
    Scenario Outline: Erasing the above created entry
    
    And Set the Testcase id MS-Test-LS-01 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.LSERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "LS2"

  Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LS2","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"N"}},{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"string"}]}]}]}|
         
      # Retrieve after erasure_Validation
 Scenario: Retrieve the above erased entry
    
    And Set the Testcase id MS-Test-LS-21 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/112.LSERASURE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/NOSQL/Report9.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON response string property key "requestId" should equal value "112.LSERASURE"
    And MS JSON response string property key "reportType" should equal value "SAR"
    And MS JSON response string property key "partyId" should equal value "205761453936"
    And MS JSON response string property key "customerId" should equal value "LS2"
    And MS JSON response string property key "serviceId" should equal value "PARTY"
    And MS JSON response string property key "statusCode" should equal value "200"
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ReportResult9.json"
      
    #Validating the above list of strings with valid datatype and with erasure options (NULLIFY)  		
  Scenario Outline: Validating the above list of strings with valid datatype and with erasure options (NULLIFY)
   
    And Set the Testcase id MS-Test-LS-03 for company GB0010001
    And MS request URI is "v1.0.0/payments/customers"
	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 201 
	And MS JSON response string property key "customerId" should equal value "LS3"
	And MS JSON response string property key "status" should equal value "Created"
              
Examples: 
        |payload|
		|{"customerId":"LS3","customerName":"Riya","account":"352-LS3","loanTypes":["education loan","Personal loan","Car loan","Housing loan","Bike loan"],"dateOfJoining":"2020-08-26"}|
		

Scenario: to retrieve a customer using query param account to check the loan types

    And MS request URI is "v1.0.0/payments/customers"
    Then MS query parameter "account" is set to value "352-LS3" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "customerId" should equal value "[LS3]"
	And MS JSON response string property key "customerName" should equal value "[Riya]"
	And MS JSON response string property key "account" should equal value "[352-LS3]"
	And MS JSON response string property key "dateOfJoining" should equal value "[2020-08-26]"
	And MS JSON response string property key "loanTypes[0][0]" should equal value "education loan"
	And MS JSON response string property key "loanTypes[0][1]" should equal value "Personal loan"
	And MS JSON response string property key "loanTypes[0][2]" should equal value "Car loan"
	And MS JSON response string property key "loanTypes[0][3]" should equal value "Housing loan"
	And MS JSON response string property key "loanTypes[0][4]" should equal value "Bike loan"
	
Scenario Outline: Nullifying the above created entry with option value for nullify(here it doesnt consider the erasure options for list of string)
    
    And Set the Testcase id MS-Test-LS-01 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/235.LSERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "LS3"

  Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LS3","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"N"}},{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"string"}]}]}]}|
      
     # Retrieve after erasure_Validation
    Scenario: Retrieve the above nullified entry
  
    And Set the Testcase id MS-Test-LS-03 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/113.LSERASURE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/NOSQL/Report10.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON response string property key "requestId" should equal value "113.LSERASURE"
    And MS JSON response string property key "reportType" should equal value "SAR"
    And MS JSON response string property key "partyId" should equal value "205761453936"
    And MS JSON response string property key "customerId" should equal value "LS3"
    And MS JSON response string property key "serviceId" should equal value "PARTY"
    And MS JSON response string property key "statusCode" should equal value "200"
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ReportResult10.json"   
      
   #Validating the above list of strings with 10 strings and without erasure options    		
  Scenario Outline: Validating the above list of strings with 10 strings and without erasure options 
   
   And Set the Testcase id MS-Test-LS-04 for company GB0010001
    And MS request URI is "v1.0.0/payments/customers"
	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 201 
	And MS JSON response string property key "customerId" should equal value "LS4"
	And MS JSON response string property key "status" should equal value "Created"
	

Examples: 
        |payload|
		|{"customerId":"LS4","customerName":"Riya","account":"352-LS4","loanTypes":["education loan","Personal loan","Car loan","Housing loan","Bike loan","LS1 loan","LS2 loan","LS3 loan","LS4 loan","LS5 loan"],"dateOfJoining":"2020-08-26"}|
		
Scenario: to retrieve a customer using query param account to check the loan types

    And MS request URI is "v1.0.0/payments/customers"
    Then MS query parameter "account" is set to value "352-LS4" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "customerId" should equal value "[LS4]"
	And MS JSON response string property key "customerName" should equal value "[Riya]"
	And MS JSON response string property key "account" should equal value "[352-LS4]"
	And MS JSON response string property key "dateOfJoining" should equal value "[2020-08-26]"
	And MS JSON response string property key "loanTypes[0][0]" should equal value "education loan"
	And MS JSON response string property key "loanTypes[0][1]" should equal value "Personal loan"
	And MS JSON response string property key "loanTypes[0][2]" should equal value "Car loan"
	And MS JSON response string property key "loanTypes[0][3]" should equal value "Housing loan"
	And MS JSON response string property key "loanTypes[0][4]" should equal value "Bike loan"
	And MS JSON response string property key "loanTypes[0][5]" should equal value "LS1 loan"
	And MS JSON response string property key "loanTypes[0][6]" should equal value "LS2 loan"
	And MS JSON response string property key "loanTypes[0][7]" should equal value "LS3 loan"
	And MS JSON response string property key "loanTypes[0][8]" should equal value "LS4 loan"
	And MS JSON response string property key "loanTypes[0][9]" should equal value "LS5 loan"
	
    Scenario Outline: Erasing the above created entry
    
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/237.LSERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "LS4"

  Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LS4","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"string"}]}]}]}|
    
      
     # Retrieve after erasure_Validation
    Scenario: Retrieve the above erased entry
    
    And Set the Testcase id MS-Test-ER-21 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/111.LSERASURE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/NOSQL/Report11.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON response string property key "customerId" should equal value "LS4"
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "requestId" should equal value "111.LSERASURE"
    And MS JSON response string property key "reportType" should equal value "SAR"
    And MS JSON response string property key "partyId" should equal value "205761453936"
    And MS JSON response string property key "serviceId" should equal value "PARTY"
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ReportResult11.json"  
   
        