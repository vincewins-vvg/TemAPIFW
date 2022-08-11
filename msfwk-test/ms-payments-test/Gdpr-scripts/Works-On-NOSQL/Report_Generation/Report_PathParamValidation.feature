Feature: Report_PathParamValidation
  
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
	And MS JSON response string property key "customerId" should equal value "RG1"
	And MS JSON response string property key "status" should equal value "Created"

Examples: 
        |payload|
		|{"customerId":"RG1","customerName":"Riya","account":"345-RG1","loanTypes":["education loan"],"dateOfJoining":"2020-08-26"}|
		

  Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite)
  
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytestreport1|
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
		|  {  "fromAccount": "345-RG1",  "toAccount": "123-ABC", "paymentReference": "paytestreport1","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
		
   
   #Path param validation for request id
    Scenario Outline: Path param validation with invalid request id
    
    And Set the Testcase id MS-Test-RG-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/**@@@"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "requestId" should equal value "**@@@"
    And MS JSON response string property key "customerId" should equal value "RG1"
    And MS JSON response string property key "reportType" should equal value "SAR"
    
     Examples: 
    |payload||repsonse|
    |{"partyId":"2057614539311","customerId":"RG1","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]}]}||{"partyId":"2057614539311","customerId":"RG1","serviceId":"PARTY","requestId":"**@@@","reportType":"SAR","personalData":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"attributeName":"cardname","attributeValue":"allwin"},{"attributeName":"cardlimit","attributeValue":"1.11"}]}]}|
    

    Scenario Outline: Path param validation without request id
    
    And Set the Testcase id MS-Test-RG-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 404
    
    Examples: 
    |payload|
    |{"partyId":"2057614539311","customerId":"RG1","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]}]}|
   

    Scenario Outline: Path param validation with invalid report type
    
    And Set the Testcase id MS-Test-RG-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/**@@@/requests/143.REPORT"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "requestId" should equal value "143.REPORT"
    And MS JSON response string property key "customerId" should equal value "RG1"
    And MS JSON response string property key "reportType" should equal value "**@@@"
    
     Examples: 
    |payload||response|
    |{"partyId":"2057614539311","customerId":"RG1","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]}]}||{"partyId":"2057614539311","customerId":"RG1","serviceId":"PARTY","requestId":"**@@@","reportType":"SAR","personalData":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"attributeName":"cardname","attributeValue":"allwin"},{"attributeName":"cardlimit","attributeValue":"1.11"}]}]}|
   

    Scenario Outline: Path param validation without report type
    
    And Set the Testcase id MS-Test-RG-001 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/requests/143.REPORT"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 404
    
    Examples: 
    |payload|
    |{"partyId":"2057614539311","customerId":"RG1","serviceId":"PARTY","customEntityidentifier":{"fromAccount":"150-IOB","toAccount":"334-IOB","paymentDetails":"doc","currency":"INR"},"personalData":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"cardlimit","dataEntityFieldDataType":"string"}]}]}|