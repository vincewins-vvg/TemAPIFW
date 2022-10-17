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
	And MS JSON response string property key "customerId" should equal value "LOER1"
	And MS JSON response string property key "status" should equal value "Created"

Examples: 
        |payload|
		|{"customerId":"LOER1","customerName":"Riya","account":"352-LOER1","loanTypes":["education loan","housing loan","car loan"],"dateOfJoining":"2020-08-26"}|
		

   Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite) data-1
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytestresponserg1|
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
		|  {  "fromAccount": "352-LOER1",  "toAccount": "100-ABC", "paymentReference": "paytestresponserg1","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|

 Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite) data-2
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytestresponserg2|
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
		|  {  "fromAccount": "352-LOER1",  "toAccount": "101-ABC", "paymentReference": "paytestresponserg2","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
		
  Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite) data-3
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytestresponserg3|
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
		|  {  "fromAccount": "352-LOER1",  "toAccount": "102-ABC", "paymentReference": "paytestresponserg3","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
					
  
 Scenario Outline: Input level consolidated error response validation along with impl errors in payload
    
    And Set the Testcase id MS-Test-LOE-060 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/200.RESPONSE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400 
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ConsolidatedResponse5.json" 
     
    Examples: 
         |payload|
         |{"customerId":"LOER1","serviceId":null,"customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":null,"dataEntityFields":[{"dataEntityFieldName":"paymentDatezz","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.paymentMethod.cardzz","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":null,"dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"status","dataEntityFieldDataType":"string21"},{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"debitAccount"},{"dataEntityFieldName":"creditAccount","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{},{}]},{"dataEntityName":"PaymentOrder.payeeDetails"},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"customerId","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list"}]}]}|

    
  Scenario Outline: Resolving input levels errors to check the impl error responses response
    
    And Set the Testcase id MS-Test-LOE-061 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/201.RESPONSE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400 
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ConsolidatedResponse6.json" 
     
    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LOER1","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrders","dataEntityFields":[{"dataEntityFieldName":"paymentDatezz","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.paymentMethod.cardzz","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"value","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"status","dataEntityFieldDataType":"string21"},{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"debitAccount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"creditAccount","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.payeeDetailss","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"payeeType21","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"customerId","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list"}]}]}|
         
         
     Scenario Outline: Resolving the above entity impl errors to view the error responses for entityfieldname
     
    And Set the Testcase id MS-Test-LOE-062 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/202.RESPONSE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ConsolidatedResponse7.json" 
     
    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LOER1","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDatezz","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"value","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"status","dataEntityFieldDataType":"string21"},{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"debitAccount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"creditAccount","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"payeeType21","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoiningz","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"customerId","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list"}]}]}|
         
    Scenario Outline: Resolving  entity field impl errors for positive response
     
    And Set the Testcase id MS-Test-LOE-063 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/203.RESPONSE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200 
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ConsolidatedResponse8.json" 
     
    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"LOER1","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"value","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"status","dataEntityFieldDataType":"string21"},{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"debitAccount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"creditAccount","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"payeeType","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"customerId","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list"}]}]}|
             
             
       
   