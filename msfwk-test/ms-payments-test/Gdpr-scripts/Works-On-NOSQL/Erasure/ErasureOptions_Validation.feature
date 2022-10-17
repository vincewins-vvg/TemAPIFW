Feature: ErasureOptions_Validation
  
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
	And MS JSON response string property key "customerId" should equal value "ER6"
	And MS JSON response string property key "status" should equal value "Created"

Examples: 
        |payload|
		|{"customerId":"ER6","customerName":"Riya","account":"350-ER6","loanTypes":["education loan"],"dateOfJoining":"2020-08-26"}|
		

  Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite)
  
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytesterasure6|
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
		|  {  "fromAccount": "350-ER6",  "toAccount": "123-ABC", "paymentReference": "paytesterasure6","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
		
   
   #ErasureOptions validation 
    Scenario Outline: Erasure option validation within same purpose and entityname
    
    And Set the Testcase id MS-Test-ER-002 for company GB0010001
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
    And MS JSON response string property key "customerId" should equal value "ER6"
    #And set timeout session for 60 seconds
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-002    | paymentOrderId    | eq                | string   | PO~350-ER6~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-002    | paymentOrderId                     | PO~350-ER6~123-ABC~USD~485 |
      | MS-Test-ER-002    | status                             | ********* |


    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER6","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"status","dataEntityFieldDataType":"string"},{"dataEntityFieldName":"status","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]}]}]}|
    

    Scenario Outline: Erasure option validation within different purpose 
    
    And Set the Testcase id MS-Test-ER-003 for company GB0010001
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
    And MS JSON response string property key "customerId" should equal value "ER6"
    #And set timeout session for 60 seconds
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-003    | paymentOrderId    | eq                | string   | PO~350-ER6~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-003    | paymentOrderId                     | PO~350-ER6~123-ABC~USD~485 |

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER6","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}}]}]},{"purpose":"payment","dataDefinitions":[{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"string"}]}]}]}|
   
   Scenario Outline: Erasure option array validation with null option value
    
    And Set the Testcase id MS-Test-ER-004 for company GB0010001
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
    And MS JSON response string property key "customerId" should equal value "ER6"
    #And set timeout session for 60 seconds
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-004    | paymentOrderId    | eq                | string   | PO~350-ER6~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-004    | paymentOrderId                     | PO~350-ER6~123-ABC~USD~485 |

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER6","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeName","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":null}}]}]}]}|
  
   Scenario Outline: Erasure option array validation without option value
    
    And Set the Testcase id MS-Test-ER-005 for company GB0010001
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
    And MS JSON response string property key "customerId" should equal value "ER6"
    #And set timeout session for 60 seconds
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-005    | paymentOrderId    | eq                | string   | PO~350-ER6~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-005    | paymentOrderId                     | PO~350-ER6~123-ABC~USD~485 |

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER6","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder.payeeDetails","dataEntityFields":[{"dataEntityFieldName":"payeeType","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA"}}]}]}]}|
         
    Scenario Outline: Erasure option array validation with null value as optionid
    
    And Set the Testcase id MS-Test-ER-006 for company GB0010001
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
    And MS JSON response string property key "customerId" should equal value "ER6"
    #And set timeout session for 60 seconds
    
     Then Set the following data criteria
      | TestCaseID        | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-006    | paymentOrderId    | eq                | string   | PO~350-ER6~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-006    | paymentOrderId                     | PO~350-ER6~123-ABC~USD~485 |
      | MS-Test-ER-006    | status                             | eeeeeeeee |

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER6","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"status","dataEntityFieldDataType":"string","erasureOptions":{"optionsValue":"e"}}]}]}]}|
      
    Scenario Outline: Erasure option array validation without optionid
    
    And Set the Testcase id MS-Test-ER-007 for company GB0010001
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
    And MS JSON response string property key "customerId" should equal value "ER6"
    #And set timeout session for 60 seconds
    
     Then Set the following data criteria
      | TestCaseID        | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-007    | paymentOrderId    | eq                | string   | PO~350-ER6~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-007    | paymentOrderId                     | PO~350-ER6~123-ABC~USD~485 |

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER6","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder.paymentMethod","dataEntityFields":[{"dataEntityFieldName":"name","dataEntityFieldDataType":"string","erasureOptions":{"optionsValue":"k"}}]}]}]}|
  
   Scenario Outline: Erasure option  empty array validation 
    
    And Set the Testcase id MS-Test-ER-008 for company GB0010001
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
    And MS JSON response string property key "customerId" should equal value "ER6"
    #And set timeout session for 60 seconds
    
     Then Set the following data criteria
      | TestCaseID        | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-008    | paymentOrderId    | eq                | string   | PO~350-ER6~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-008    | paymentOrderId                     | PO~350-ER6~123-ABC~USD~485 |

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER6","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder.paymentMethod.card","dataEntityFields":[{"dataEntityFieldName":"cardname","dataEntityFieldDataType":"string","erasureOptions":{}}]}]}]}|
         
 Scenario Outline: Erasure option array validation with empty value with("") as optionvalue with whitespace
    
    And Set the Testcase id MS-Test-ER-016 for company GB0010001
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
    And MS JSON response string property key "customerId" should equal value "ER6"
    #And set timeout session for 60 seconds
    
     Then Set the following data criteria
      | TestCaseID        | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-016    | paymentOrderId    | eq                | string   | PO~350-ER6~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-016    | paymentOrderId                     | PO~350-ER6~123-ABC~USD~485 |
      | MS-Test-ER-016    | paymentDetails                     | XXXXXXX |

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER6","serviceId":"PARTY","customEntityidentifier":{"amount":"111"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"*"}},{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALPHA","optionsValue":"  "}}]}]}]}| 
         
     Scenario: Overall Rretrieve for the above erased entries
    
    And Set the Testcase id MS-Test-ER-25 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/143.ERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/NOSQL/Report4.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ReportResult4.json"      