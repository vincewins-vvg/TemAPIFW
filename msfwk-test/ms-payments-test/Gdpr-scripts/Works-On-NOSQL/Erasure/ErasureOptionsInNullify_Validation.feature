Feature: ErasureOptionsInNullify_Validation
  
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
	And MS JSON response string property key "customerId" should equal value "ER10"
	And MS JSON response string property key "status" should equal value "Created"

Examples: 
        |payload|
		|{"customerId":"ER10","customerName":"Riya","account":"354-ER10","loanTypes":["education loan"],"dateOfJoining":"2020-08-26"}|
		

  Scenario Outline: Create a new Payment Order with Extension Data in Payload(Prerequisite)
  
  
  To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytesterasure10|
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
		|  {  "fromAccount": "354-ER10",  "toAccount": "123-ABC", "paymentReference": "paytesterasure10","paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
		
   
   #Nullify with option value validation 
    Scenario Outline: Nullify with option value to check the error response
    
    And Set the Testcase id MS-Test-ER-030 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/300.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
     And MS JSON response string property key "errorMessage" should equal value "[If optionId is NULLIFY, Optionvalue should be an empty string]"
    And MS JSON response string property key "errorCode" should equal value "[MSF-701]"
    And MS JSON response string property key "partyId" should equal value "[PO~DATEST~CADEST~USD~100]"
    And MS JSON response string property key "customerId" should equal value "[ER10]"
    And MS JSON response string property key "serviceId" should equal value "[PARTY]"
    And MS JSON response string property key "statusCode" should equal value "[400]"
    And MS JSON response string property key "erasureRequestId" should equal value "[300.erasure]"
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-030    | paymentOrderId    | eq                | string   | PO~354-ER10~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-030    | paymentOrderId                     | PO~354-ER10~123-ABC~USD~485 |
      | MS-Test-ER-030    | currency                           | USD |


    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER10","serviceId":"PARTY","customEntityidentifier":{"currency":"100"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"P"}}]}]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"  "}}]}]}]}|
         
    #Nullify with no option value validation 
    Scenario Outline: Nullify with no option value to check the error response
    
    And Set the Testcase id MS-Test-ER-031 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/301.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
     And MS JSON response string property key "errorMessage" should equal value "[If optionId is NULLIFY, Optionvalue should be an empty string]"
    And MS JSON response string property key "errorCode" should equal value "[MSF-701]"
    And MS JSON response string property key "partyId" should equal value "[PO~DATEST~CADEST~USD~100]"
    And MS JSON response string property key "customerId" should equal value "[ER10]"
    And MS JSON response string property key "serviceId" should equal value "[PARTY]"
    And MS JSON response string property key "statusCode" should equal value "[400]"
    And MS JSON response string property key "erasureRequestId" should equal value "[301.erasure]"
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-031    | paymentOrderId    | eq                | string   | PO~354-ER10~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-031    | paymentOrderId                     | PO~354-ER10~123-ABC~USD~485 |
      | MS-Test-ER-031    | currency                           | USD |


    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER10","serviceId":"PARTY","customEntityidentifier":{"currency":"100"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY"}}]}]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"currency","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"  "}}]}]}]}|
  
   #Nullify with white space and empty string option value validation 
    Scenario Outline: Nullify with white space and empty string option value validation
    
    And Set the Testcase id MS-Test-ER-032 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/302.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "ER10"
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-032    | paymentOrderId    | eq                | string   | PO~354-ER10~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-032    | paymentOrderId                     | PO~354-ER10~123-ABC~USD~485 |

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER10","serviceId":"PARTY","customEntityidentifier":{"currency":"100"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY","optionsValue":""}}]}]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"  "}}]}]}]}|
         
  #after nullify,retry with option value with any char(it should not throw error response because of field not available)
  
    Scenario Outline: After nullify,retry with option value with any character
    
    And Set the Testcase id MS-Test-ER-033 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/303.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "ER10"
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-033    | paymentOrderId    | eq                | string   | PO~354-ER10~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-033    | paymentOrderId                     | PO~354-ER10~123-ABC~USD~485 |


    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER10","serviceId":"PARTY","customEntityidentifier":{"currency":"100"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDate","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"Party1223"}}]}]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"amount","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY","optionsValue":"MASK"}}]}]}]}|
         
    Scenario Outline: OptionId as asl other than NULLIFY
    
    And Set the Testcase id MS-Test-ER-034 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/304.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "partyId" should exist
    And MS JSON property "erasureRequestId" should exist
    And MS JSON property "serviceId" should exist
    And MS JSON response string property key "statusCode" should equal value "200"
    And MS JSON response string property key "customerId" should equal value "ER10"
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-034    | paymentOrderId    | eq                | string   | PO~354-ER10~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-034    | paymentOrderId                     | PO~354-ER10~123-ABC~USD~485 |
      | MS-Test-ER-034    | status                             | XXXXXXXXX |
      | MS-Test-ER-034    | paymentDetails                     | MMMMMMM |


    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER10","serviceId":"PARTY","customEntityidentifier":{"currency":"100"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"status","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALS","optionsValue":""}}]}]},{"purpose":"card","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"nullifys","optionsValue":"M"}}]}]}]}|
         
    Scenario Outline: Invalid nullify followed by erasure within same purpose
    
    And Set the Testcase id MS-Test-ER-035 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/305.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    And log all MS response in console
    Then MS response code should be 400
    And MS JSON response string property key "errorMessage" should equal value "[If optionId is NULLIFY, Optionvalue should be an empty string]"
    And MS JSON response string property key "errorCode" should equal value "[MSF-701]"
    And MS JSON response string property key "partyId" should equal value "[PO~DATEST~CADEST~USD~100]"
    And MS JSON response string property key "customerId" should equal value "[ER10]"
    And MS JSON response string property key "serviceId" should equal value "[PARTY]"
    And MS JSON response string property key "statusCode" should equal value "[400]"
    And MS JSON response string property key "erasureRequestId" should equal value "[305.erasure]"
    #And set timeout session for 60 seconds
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-035    | paymentOrderId    | eq                | string   | PO~354-ER10~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-035    | paymentOrderId                     | PO~354-ER10~123-ABC~USD~485 |
      | MS-Test-ER-035    | paymentReference                   |  paytesterasure10 |

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER10","serviceId":"PARTY","customEntityidentifier":{"currency":"100"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY"}},{"dataEntityFieldName":"paymentReference","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"ALS","optionsValue":"P"}}]}]}]}|
         
   Scenario Outline: Valid nullify followed by erasure within same purpose(it will work as sequencial streaming)
    
    And Set the Testcase id MS-Test-ER-036 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/erasureRequests/306.erasure"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And post the static MS JSON as payload <payload> 
    When a "PUT" request is sent to MS
    And log all MS response in console
    And log all MS response in console
    Then MS response code should be 200
    
     Then Set the following data criteria
      | TestCaseID                            | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-ER-036    | paymentOrderId    | eq                | string   | PO~354-ER10~123-ABC~USD~485 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID        | ColumnName                         | ColumnValue |
      | MS-Test-ER-036    | paymentOrderId                     | PO~354-ER10~123-ABC~USD~485 |
        | MS-Test-ER-036   | paymentDetails                     |  ppppppp |

    Examples: 
         |payload|
         |{"partyId":"PO~DATEST~CADEST~USD~100","customerId":"ER10","serviceId":"PARTY","customEntityidentifier":{"currency":"100"},"personalData":[{"purpose":"tax","dataDefinitions":[{"dataEntityName":"PaymentOrder","dataEntityFields":[{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"NULLIFY","optionsValue":""}},{"dataEntityFieldName":"paymentDetails","dataEntityFieldDataType":"string","erasureOptions":{"optionsId":"als","optionsValue":"p"}}]}]}]}|
         
   Scenario: Overall Rretrieve for the above nullified entries
    
    And Set the Testcase id MS-Test-ER-25 for company GB0010001
    And MS request URI is "v1.0.0/party/personalData/reports/SAR/requests/144.ERASURE"
    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/GDPR/NOSQL/Report5.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And check full response with expected json content from file path "src/test/resources/cucumber-json-payload/GDPR/NOSQL/ReportResult5.json"        