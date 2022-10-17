Feature: ListOfErrorResponses
  
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
	And MS JSON response string property key "customerId" should equal value "LOE1"
	And MS JSON response string property key "status" should equal value "Created"

Examples: 
        |payload|
		|{"customerId":"LOE1","customerName":"Riya","account":"352-LOE1","loanTypes":["education loan","housing loan","car loan"],"dateOfJoining":"2020-08-26"}|
		

   Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite) data-1
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytestresponse1|
  | description | string |Payment ref|
    
    And MS request URI is "v1.0.0/payments/orders" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "paymentId" should exist 
	And MS JSON response string property key "status" should equal value "INITIATED" 
	
	Examples: 
		|payload|
		|  {  "fromAccount": "352-LOE1",  "toAccount": "123-ABC", "paymentReference": "paytestresponse1","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|

 Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite) data-2
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytestresponse2|
  | description | string |Payment ref|
    
    And MS request URI is "v1.0.0/payments/orders" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "paymentId" should exist 
	And MS JSON response string property key "status" should equal value "INITIATED" 
	
	Examples: 
		|payload|
		|  {  "fromAccount": "352-LOE1",  "toAccount": "124-ABC", "paymentReference": "paytestresponse2","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
		
  Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite) data-3
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytestresponse3|
  | description | string |Payment ref|
    
    And MS request URI is "v1.0.0/payments/orders" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "paymentId" should exist 
	And MS JSON response string property key "status" should equal value "INITIATED" 
	
	Examples: 
		|payload|
		|  {  "fromAccount": "352-LOE1",  "toAccount": "125-ABC", "paymentReference": "paytestresponse3","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
			
 Scenario Outline: Input level consolidated error response validation along with impl errors in payload
    
    And Set the Testcase id MS-Test-RH-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/123.response"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400 
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ConsolidatedResponse1.json" 
     
    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":null,"customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":null,"dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrders2","dataEntityFields":[{"dataEntityFieldName":"paymentDates","dataEntityFieldDataType":"decimal"}]},{"dataEntityFields":[{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"AL","optionsValue":"^"}}]}]},{"purpose":"tax1","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"","erasureOptions":{"optionsId":"ALPHA","optionsValue":""}},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"Q"}}]},{"dataEntityName":"PaymentOrder.PaymentMethod","dataEntityFields":[{"dataEntityFieldName":null,"dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"status","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":""}}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"N"}},{"dataEntityFieldName":"value","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":"N"}}]}]},{"purpose":"payment","dataDefinitions":[{}]},{"purpose":"payment22","dataDefinitions":[]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"T"}},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"p"}}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[]},{"dataEntityName":"PaymentOrder.exchangeRates22","dataEntityFields":[{}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoiningzz","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]}]}]}|
  
     Scenario Outline: Resolving input levels errors to check the impl error responses response
    
    And Set the Testcase id MS-Test-RH-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/124.response"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400 
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ConsolidatedResponse2.json" 
     
    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LOE1","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder2","dataEntityFields":[{"dataEntityFieldName":"paymentDates","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"AL","optionsValue":"^"}}]}]},{"purpose":"tax1","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":""}},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"Q"}}]},{"dataEntityName":"PaymentOrder.PaymentMethod","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"status","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":""}}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"N"}},{"dataEntityFieldName":"value1","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":"N"}}]}]},{"purpose":"payment","dataDefinitions":[]},{"purpose":"payment22","dataDefinitions":[]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"T"}},{"dataEntityFieldName":"cardlimit21","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"p"}}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]},{"dataEntityName":"PaymentOrder.exchangeRateszz","dataEntityFields":[{"dataEntityFieldName":"payeeName22","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoiningzz","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]}]}]}|
    
 Scenario Outline: Resolving the above entity impl errors to view the error responses for entityfieldname
    
    And Set the Testcase id MS-Test-RH-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/125.response"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400 
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ConsolidatedResponse3.json" 
     
    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LOE1","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDates","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"AL","optionsValue":"^"}}]}]},{"purpose":"tax1","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":""}},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"Q"}}]},{"dataEntityName":"PaymentOrder.PaymentMethod","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"status","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":""}}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"N"}},{"dataEntityFieldName":"value1","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":"N"}}]}]},{"purpose":"payment","dataDefinitions":[]},{"purpose":"payment22","dataDefinitions":[]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"T"}},{"dataEntityFieldName":"cardlimit21","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"p"}}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"payeeName22","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoiningzz","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]}]}]}|
         
  Scenario Outline: Resolving  entity field impl errors for positive response
    
    And Set the Testcase id MS-Test-RH-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/126.response"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON response string property key "partyId" should equal value "PO~DATEST~CADEST~USD~100"
    And MS JSON response string property key "customerId" should equal value "LOE1"
    And MS JSON response string property key "erasureRequestId" should equal value "126.response"
    And MS JSON response string property key "serviceId" should equal value "PARTY"
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "data" should equal value "[:]"
     
    Examples: 
       |payload|
       |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LOE1","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"AL","optionsValue":"^"}}]}]},{"purpose":"tax1","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":""}},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"Q"}}]},{"dataEntityName":"PaymentOrder.PaymentMethod","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"status","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":""}}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"NULLIFY","optionsValue":""}},{"dataEntityFieldName":"value","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"ALPHA","optionsValue":"N"}}]}]},{"purpose":"payment","dataDefinitions":[]},{"purpose":"payment22","dataDefinitions":[]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"T"}},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"p"}}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]}]}]}|
   
    # Retrieve after erasure_Validation
    Scenario Outline: Retrieve the above erased entry
    
    And Set the Testcase id MS-Test-RH-011 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/127.RESPONSE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ConsolidatedResponse4.json"        
    
     Examples: 
       |payload|
       |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LOE1","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"value","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"status","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"debitAccount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"creditAccount","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"payeeType","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder.PaymentMethod","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"customerId","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list"}]}]}|
       