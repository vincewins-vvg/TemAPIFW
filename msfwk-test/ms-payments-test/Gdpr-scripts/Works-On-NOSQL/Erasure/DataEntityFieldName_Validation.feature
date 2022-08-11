Feature: DataEntityFieldName_Validation
  
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
	And MS JSON response string property key "customerId" should equal value "ER4"
	And MS JSON response string property key "status" should equal value "Created"

Examples: 
        |payload|
		|{"customerId":"ER4","customerName":"Riya","account":"348-ER4","loanTypes":["education loan"],"dateOfJoining":"2020-08-26"}|
		

  Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite)
  
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytesterasure4|
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
		|  {  "fromAccount": "348-ER4",  "toAccount": "123-ABC", "paymentReference": "paytesterasure4","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
		
   
   #DataEntityFieldName validation 
    Scenario Outline: DataEntityFieldName validation with invalid name in 1st element
    
    And Set the Testcase id MS-Test-PO-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "code" should equal value "[MSF-703]"
    And MS JSON response string property key "message" should contain value "[Method not foundcom.temenos.microservice.paymentorder.entity.ExchangeRate.getCurrency-com.temenos.microservice.paymentorder.entity.ExchangeRate.getCurrency()]"
    
    #And set timeout session for 60 seconds

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER4","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder.exchangeRates","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"P"}}]}]}]}|
    
    
      
  Scenario Outline: DataEntityFieldName validation with invalid name in last element
    
    And Set the Testcase id MS-Test-PO-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "message" should contain value "[Method not foundcom.temenos.microservice.paymentorder.entity.Card.getAmount-com.temenos.microservice.paymentorder.entity.Card.getAmount()]" 
    And MS JSON response string property key "code" should equal value "[MSF-703]"
    
    #And set timeout session for 60 seconds

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER4","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"decimal"}]}]},{"purpose":"payment","dataDefinitions":[{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]}]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"9"}}]}]}]}|
    
   Scenario Outline: DataEntityFieldName validation with null as value
   
    And Set the Testcase id MS-Test-PO-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "message" should contain value "[Entity Field Name should not be null]" 
    And MS JSON response string property key "code" should equal value "[MSF-701]"
    
    #And set timeout session for 60 seconds

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER4","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":null,"dataEntityFieldDataType":"decimal"}]}]},{"purpose":"payment","dataDefinitions":[{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]}]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"9"}}]}]}]}|
    
   Scenario Outline: Without DataEntityFieldName validation  
   
    And Set the Testcase id MS-Test-PO-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/234.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "message" should contain value "[Entity Field Name should not be null]" 
    And MS JSON response string property key "code" should equal value "[MSF-701]"
    
    #And set timeout session for 60 seconds

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER4","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldDataType":"decimal"}]}]},{"purpose":"payment","dataDefinitions":[{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]}]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"9"}}]}]}]}|
    
   