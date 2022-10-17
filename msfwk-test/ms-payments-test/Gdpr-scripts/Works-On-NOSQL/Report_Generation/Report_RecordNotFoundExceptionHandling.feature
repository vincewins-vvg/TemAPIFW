Feature: Report_RecordNotFoundExceptionHandling

#(MFW-2949)
  
  Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    Given MS query parameter for Azure env is set to value ""
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    		
  Scenario Outline: create customer using post method
   
    And MS request URI is "v1.0.0/payments/customers"
	When post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON response string property key "customerId" should equal value "RH3"
	And MS JSON response string property key "status" should equal value "Created"

Examples: 
        |payload|
		|{"customerId":"RH3","customerName":"Sam","account":"346-RH3","loanTypes":["education loan"],"dateOfJoining":"2020-08-26"}|
		

  Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite)
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytestrecord2|
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
		|  {  "fromAccount": "346-RH4",  "toAccount": "123-ABC", "paymentReference": "paytestrecord2","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
		

 #Invalid customer id(customer id not present in db)
 #Invalid customer id(customer id not present in db) with valid PO(present in db)
    Scenario Outline: Invalid customer id(customer id not present in db)
    
    And Set the Testcase id MS-Test-RH-003 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/111.LSRECORD"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON response string property key "customerId" should equal value "RH34"
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "requestId" should equal value "111.LSRECORD"
    And MS JSON response string property key "reportType" should equal value "SAR"
    And MS JSON response string property key "partyId" should equal value "6789"
    And MS JSON response string property key "serviceId" should equal value "PARTY"
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ReportResult12.json"  
      
    Examples: 
         |payload|
         |{"partyId":"6789","customerId":"RH34","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname1","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"customerNames","dataEntityFieldDataType":"string"}]}]}|
                
  
 #Valid customer id(customer id is present in db) with invalid PO( not present in db)
   Scenario Outline: Valid customer id(customer id is present in db) with invalid PO( not present in db)
    
    And Set the Testcase id MS-Test-RH-003 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/112.LSRECORD"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON response string property key "customerId" should equal value "RH3"
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "requestId" should equal value "112.LSRECORD"
    And MS JSON response string property key "reportType" should equal value "SAR"
    And MS JSON response string property key "partyId" should equal value "6789"
    And MS JSON response string property key "serviceId" should equal value "PARTY"
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ReportResult13.json"  
      
    Examples: 
         |payload|
         |{"partyId":"6789","customerId":"RH3","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"value","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"status","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"debitAccount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"creditAccount","dataEntityFieldDataType":"string"}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"customerId","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list"}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"payeeType","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder.PaymentMethod","dataEntityFields":[{"dataEntityFieldName":"name7","dataEntityFieldDataType":"decimal"}]}]}|
               
 #Invalid PO that is not present in db with invalid entity name(to check the flow whether resolveimpl is called after validating entityname)
    Scenario Outline: Invalid PO  that is not present in db with invalid entity name in single level
    
    And Set the Testcase id MS-Test-RH-007 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/113.LSRECORD"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "customerId" should equal value "[RH3]"
    And MS JSON property "errorMessage" should exist 
    And MS JSON response string property key "errorCode" should equal value "[MSF-702]"
    And MS JSON response string property key "partyId" should equal value "[6789]"
    And MS JSON response string property key "serviceId" should equal value "[PARTY]"
    And MS JSON response string property key "statusCode" should equal value "[400]"
    And MS JSON response string property key "requestId" should equal value "[113.LSRECORD]"
    And MS JSON response string property key "reportType" should equal value "[SAR]"
    
      Examples: 
         |payload|
         |{"partyId":"6789","customerId":"RH3","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"value","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder23","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"status","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"debitAccount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"creditAccount","dataEntityFieldDataType":"string"}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"customerId","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list"}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"payeeType","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder.PaymentMethod12","dataEntityFields":[{"dataEntityFieldName":"name7","dataEntityFieldDataType":"decimal"}]}]}|
    
    #valid customer id that is present in db with invalid entityfield name for the respective customer(to check the flow with resolve impl)
    Scenario Outline: valid customer id that is present in db with invalid entityfield name for the respective customer(negtaive response flow)
    
    And Set the Testcase id MS-Test-RH-007 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/114.LSRECORD"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "customerId" should equal value "[RH3]"
    And MS JSON property "errorMessage" should exist 
    And MS JSON response string property key "errorCode" should equal value "[MSF-703]"
    And MS JSON response string property key "partyId" should equal value "[6789]"
    And MS JSON response string property key "serviceId" should equal value "[PARTY]"
    And MS JSON response string property key "statusCode" should equal value "[400]"
    And MS JSON response string property key "requestId" should equal value "[114.LSRECORD]"
    And MS JSON response string property key "reportType" should equal value "[SAR]"
    
      Examples: 
         |payload|
         |{"partyId":"6789","customerId":"RH3","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"value","dataEntityFieldDataType":"string"}]},{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"status","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"debitAccount","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"creditAccount","dataEntityFieldDataType":"string"}]},{"dataEntityName":"Customer","dataEntityFields":[{"dataEntityFieldName":"dateOfJoining","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"customerId223","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"loanTypes","dataEntityFieldDataType":"list"}]},{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"decimal"},{"dataEntityFieldName":"payeeType","dataEntityFieldDataType":"decimal"}]},{"dataEntityName":"PaymentOrder.PaymentMethod","dataEntityFields":[{"dataEntityFieldName":"name7","dataEntityFieldDataType":"decimal"}]}]}|
                              