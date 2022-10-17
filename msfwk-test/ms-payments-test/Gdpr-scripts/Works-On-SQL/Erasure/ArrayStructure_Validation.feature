Feature: ArrayStructure_Validation
  
  Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    Given MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    		
  Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite)
  
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytesterasure7|
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
		|  {  "fromAccount": "351-ER7",  "toAccount": "123-ABC", "paymentReference": "paytesterasure7","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
		
   
   #DataEntity field array  validation 
    Scenario Outline: DataEntity field array validation with empty array element
    
    And Set the Testcase id MS-Test-ER-002 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "errorMessage[0]" should equal value "Entity Field Name should not be null or empty"
    And MS JSON response string property key "errorCode[0]" should equal value "MSF-701"
    And MS JSON response string property key "partyId[0]" should equal value "PO~DATEST~CADEST~USD~100"
    And MS JSON response string property key "customerId[0]" should equal value "PO~351-ER7~123-ABC~USD~485"
    And MS JSON response string property key "serviceId[0]" should equal value "PARTY"
    And MS JSON response string property key "statusCode[0]" should equal value "400"
    And MS JSON response string property key "erasureRequestId[0]" should equal value "234.erasure"
    And MS JSON response string property key "errorMessage[1]" should equal value "Entity Field Type should not be null or empty"
    And MS JSON response string property key "errorCode[1]" should equal value "MSF-701"
    And MS JSON response string property key "partyId[1]" should equal value "PO~DATEST~CADEST~USD~100"
    And MS JSON response string property key "customerId[1]" should equal value "PO~351-ER7~123-ABC~USD~485"
    And MS JSON response string property key "serviceId[1]" should equal value "PARTY"
    And MS JSON response string property key "statusCode[1]" should equal value "400"
    And MS JSON response string property key "erasureRequestId[1]" should equal value "234.erasure"
    
    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"PO~351-ER7~123-ABC~USD~485","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder.paymentMethod","dataEntityFields":[{}]}]}]}|

    Scenario Outline: DataEntity field array validation with empty array
    
    And Set the Testcase id MS-Test-ER-009 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "errorMessage[0]" should equal value "Entity Field Name or Field Type should not be null or empty"
    And MS JSON response string property key "errorCode[0]" should equal value "MSF-701"
    And MS JSON response string property key "partyId[0]" should equal value "PO~DATEST~CADEST~USD~100"
    And MS JSON response string property key "customerId[0]" should equal value "PO~351-ER7~123-ABC~USD~485"
    And MS JSON response string property key "serviceId[0]" should equal value "PARTY"
    And MS JSON response string property key "statusCode[0]" should equal value "400"
    And MS JSON response string property key "erasureRequestId[0]" should equal value "234.erasure"

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"PO~351-ER7~123-ABC~USD~485","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[]}]}]}|

         
 Scenario Outline: Without DataEntity field array validation in payload
    
    And Set the Testcase id MS-Test-ER-0010 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "errorMessage[0]" should equal value "Entity Field Name or Field Type should not be null or empty"
    And MS JSON response string property key "errorCode[0]" should equal value "MSF-701"
    And MS JSON response string property key "partyId[0]" should equal value "PO~DATEST~CADEST~USD~100"
    And MS JSON response string property key "customerId[0]" should equal value "PO~351-ER7~123-ABC~USD~485"
    And MS JSON response string property key "serviceId[0]" should equal value "PARTY"
    And MS JSON response string property key "statusCode[0]" should equal value "400"
    And MS JSON response string property key "erasureRequestId[0]" should equal value "234.erasure"

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"PO~351-ER7~123-ABC~USD~485","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder.exchangeRates"}]}]}|
 
 Scenario Outline: DataDefinition array validation with empty array element
    
   And Set the Testcase id MS-Test-ER-011 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "errorMessage[0]" should equal value "Entity Name should not be null or empty"
    And MS JSON response string property key "errorCode[0]" should equal value "MSF-701"
    And MS JSON response string property key "partyId[0]" should equal value "PO~DATEST~CADEST~USD~100"
    And MS JSON response string property key "customerId[0]" should equal value "PO~351-ER7~123-ABC~USD~485"
    And MS JSON response string property key "serviceId[0]" should equal value "PARTY"
    And MS JSON response string property key "statusCode[0]" should equal value "400"
    And MS JSON response string property key "erasureRequestId[0]" should equal value "234.erasure"
    And MS JSON response string property key "errorMessage[1]" should equal value "Entity Field Name or Field Type should not be null or empty"
    And MS JSON response string property key "errorCode[1]" should equal value "MSF-701"
    And MS JSON response string property key "partyId[1]" should equal value "PO~DATEST~CADEST~USD~100"
    And MS JSON response string property key "customerId[1]" should equal value "PO~351-ER7~123-ABC~USD~485"
    And MS JSON response string property key "serviceId[1]" should equal value "PARTY"
    And MS JSON response string property key "statusCode[1]" should equal value "400"
    And MS JSON response string property key "erasureRequestId[1]" should equal value "234.erasure"
    
    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"PO~351-ER7~123-ABC~USD~485","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{}]}]}]}|
         
 Scenario Outline: DataDefinition validation with empty array
    
    And Set the Testcase id MS-Test-ER-012 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "PO~351-ER7~123-ABC~USD~485"
    #And set timeout session for 60 seconds
    

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"PO~351-ER7~123-ABC~USD~485","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[]}]}|

 Scenario Outline: Personal data array validation with empty array element
    
   And Set the Testcase id MS-Test-ER-013 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "errorMessage[0]" should equal value "DataDefinitions should not be null"
    And MS JSON response string property key "errorCode[0]" should equal value "MSF-701"
    And MS JSON response string property key "partyId[0]" should equal value "PO~DATEST~CADEST~USD~100"
    And MS JSON response string property key "customerId[0]" should equal value "PO~351-ER7~123-ABC~USD~485"
    And MS JSON response string property key "serviceId[0]" should equal value "PARTY"
    And MS JSON response string property key "statusCode[0]" should equal value "400"
    And MS JSON response string property key "erasureRequestId[0]" should equal value "234.erasure"
    #And set timeout session for 60 seconds
    
    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"PO~351-ER7~123-ABC~USD~485","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{}]}|
 
Scenario Outline: Personal data array validation with empty array
    
    And Set the Testcase id MS-Test-ER-014 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "PO~351-ER7~123-ABC~USD~485"
    #And set timeout session for 60 seconds
    

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"PO~351-ER7~123-ABC~USD~485","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[]}|

 Scenario Outline: Without Personal data array in payload
    
    And Set the Testcase id MS-Test-ER-015 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "PO~351-ER7~123-ABC~USD~485"
    #And set timeout session for 60 seconds
    

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"PO~351-ER7~123-ABC~USD~485","serviceId":"PARTY","customEntityidentifier":{"amount":"111"}}|
 