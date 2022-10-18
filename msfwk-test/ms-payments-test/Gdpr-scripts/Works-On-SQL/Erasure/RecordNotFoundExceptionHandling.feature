Feature: RecordNotFoundExceptionHandling

#(MFW-2949)
  
  Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    Given MS query parameter for Azure env is set to value ""
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"

  Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite)
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytestrecord7|
  | description | string |Payment ref|
    
    And MS request URI is "v1.0.0/payments/orders" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 201 
	And MS JSON property "paymentId" should exist 
	And MS JSON response string property key "status" should equal value "INITIATED" 
	
	Examples: 
		|payload|
		|  {  "fromAccount": "346-RH7",  "toAccount": "123-ABC", "paymentReference": "paytestrecord7","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
		

 #Invalid PO id that is not present in db
    Scenario Outline: Invalid PO id that is not present in db
    
    And Set the Testcase id MS-Test-RH-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/127.record"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON response string property key "partyId" should equal value "test"
    And MS JSON response string property key "customerId" should equal value "PO~346-RH7777~123-ABC~USD~485"
    And MS JSON response string property key "erasureRequestId" should equal value "127.record"
    And MS JSON response string property key "serviceId" should equal value "PARTY"
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "data" should equal value "[:]" 
     
      
    Examples: 
         |payload|
         |{"partyId":"test","customerId":"PO~346-RH7777~123-ABC~USD~485","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency1","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"P"}}]}]},{"purpose":"tax1","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"A1"}}]}]}]}|
         
     #Invalid PO id that is not present in db with invalid entity name(to check the flow whether resolveimpl is called after validating entityname)
    Scenario Outline: Invalid PO id that is not present in db with invalid entity name in single level
    
    And Set the Testcase id MS-Test-RH-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/128.record"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON property "errorMessage" should exist 
    And MS JSON response string property key "errorCode" should equal value "[MSF-702]"
    And MS JSON response string property key "partyId" should equal value "[test]"
    And MS JSON response string property key "customerId" should equal value "[PO~346-RH7777~123-ABC~USD~485]"
    And MS JSON response string property key "serviceId" should equal value "[PARTY]"
    And MS JSON response string property key "statusCode" should equal value "[400]"
    And MS JSON response string property key "erasureRequestId" should equal value "[128.record]"
      
    Examples: 
         |payload|
         |{"partyId":"test","customerId":"PO~346-RH7777~123-ABC~USD~485","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder1","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"P"}}]}]},{"purpose":"tax1","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"decimal","erasureOptions":{"optionsId":"NULLIFY","optionsValue":" "}}]}]}]}|
         
            
     