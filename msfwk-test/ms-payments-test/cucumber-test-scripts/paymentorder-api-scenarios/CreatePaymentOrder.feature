
Feature: CreatePaymentOrder
  
  Background: To set the preconfig for the scenarios
  
    Given Set the test backgound for PAYMENT_ORDER API
    Given MS query parameter for Azure env is set to value ""
    #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    

  
  Scenario: Create a new Payment Order
#  
#  #To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paytest|
  | description | string |Payment ref|
#  
#    And MS request URI is "v1.0.0/payments/orders"
#    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
#    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/CreatePaymentOrder.json"
#    When a "POST" request is sent to MS
#    And log all MS response in console
#    Then MS response code should be 200
#    And MS JSON property "paymentId" should exist
#    And MS JSON response string property key "status" should equal value "INITIATED"
#    And MS JSON response string property key "details" should equal value "Success"
#    
#    #Store the value of paymentid field to the keu PaymentId_1 in the file path
#    Then store the MS response data from restassured json response "PaymentId_1" in keyvalue pair "paymentId" from file path "src/test/resources/reusable-test-data/KeyAndValues.txt"
#
#  Scenario: Create a new Payment Order with Extension Data in Payload 
#    
#    And MS request URI is "v1.0.0/payments/orders"
#    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
#    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/CreatePOWithExtensionData.json"
#    When a "POST" request is sent to MS
#    And log all MS response in console
#    Then MS response code should be 200
#    And MS JSON property "paymentId" should exist
#    And MS JSON response string property key "status" should equal value "INITIATED"
#    And MS JSON response string property key "details" should equal value "extension"
#    
#    
#    #Store the value of paymentid field to the key PaymentId_1 in the file path
#    Then store the MS response data from restassured json response "PaymentId_Extension" in keyvalue pair "paymentId" from file path "src/test/resources/reusable-test-data/KeyAndValues.txt"
#    
#    
#    Scenario Outline: Create a Payment Order with same Account and Currency Details
#    Given MS request URI is "v1.0.0/payments/orders"
#    And create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
#    And post the static MS JSON as payload <payload>
#    When a "POST" request is sent to MS
#    #Then MS response code should be 400
#    #And MS JSON response string property key "message" should contain value "already exists"
#    
#    Examples:
#    |payload|
#    |  {  "fromAccount": "100-CBE",  "toAccount": "123-ABC",  "paymentReference": "paytest",  "paymentDetails": "Success",  "currency": "USD",  "amount": 485,  "expires": 10,  "fileContent": "test",  "paymentDate":"2024-05-05",     "paymentMethod": {    "id": 100111,    "name": "HDFC",    "card": {      "cardid": 723,      "cardname": "Diners",      "cardlimit": 120000.11    }  },  "exchangeRates": [    {      "id": 30,      "name": "USD",      "value": 78.12    }          ],  "payeeDetails": {    "payeeName": "MSTester",    "payeeType": "temp"  },  "descriptions": [    "Tester"  ]}|
#    
#    
#    Scenario: To get created PO
#    Given create a new MS request with code using Restassured arguments ""
#    #Fetch the stored paymentid from the mentioned file path
#    And fetch the MS response data for rest assured json response "PaymentId_1" from file path "src/test/resources/reusable-test-data/KeyAndValues.txt"
#    #Use the store Payment Id in CreatePaymentOrder in the request URI
#    And concat the MS request URI "v1.0.0/payments/orders" with Bundle Value "{PaymentId_1}"
#
#    And create a new MS request with code using Restassured arguments "GET_PAYMENTORDERS_AUTH_CODE"
#    And MS request header "serviceid" is set to "client"
#    And MS request header "channelid" is set to "web"
#    And MS request header "customfilterid" is set to "test"
#    
#    When a "GET" request is sent to MS
#    And log all MS response in console
#    Then MS response code should be 200
#    And check full response with expected json content from file path "src/test/resources/static-response/GetPaymentOrderResponse.json"
#    
#    
#    Scenario: To get created PO with Extension Data
#    Given create a new MS request with code using Restassured arguments ""
#    #Fetch the stored paymentid from the mentioned file path
#    And fetch the MS response data for rest assured json response "PaymentId_Extension" from file path "src/test/resources/reusable-test-data/KeyAndValues.txt"
#    #Use the store Payment Id in CreatePaymentOrder in the request URI
#    And concat the MS request URI "v1.0.0/payments/orders" with Bundle Value "{PaymentId_Extension}"
#
#    And create a new MS request with code using Restassured arguments "GET_PAYMENTORDERS_AUTH_CODE"
#    And MS request header "serviceid" is set to "client"
#    And MS request header "channelid" is set to "web"
#    And MS request header "customfilterid" is set to "test"
#
#    
#    When a "GET" request is sent to MS
#    And log all MS response in console
#    Then MS response code should be 200
#    And check full response with expected json content from file path "src/test/resources/static-response/GetPaymentOrderResponseExt.json"
#    #And check full response with expected json content from file path "src/test/resources/static-response/UpdatedPaymentOrderResponse.json"
#    
#    Scenario: To delete the created PO
#    
#    #Given enter tablename to delete ms_payment_order
#    #And enter value to be deleted
#    #| Fields   | type | data|condition|
#    #| paymentOrderId | string |PO~100-CBE~123-ABC~USD~485|eq|
#    #| debitAccount | string |100-CBE|eq|
#    
#    #To delete the values inserted into the DB
#    #Given enter tablename to delete ms_payment_order
#    #And enter value to be deleted
#    #| Fields   | type | data|condition|
#    #| paymentOrderId | string |PO~111-ACD~321-ZXC~INR~125|eq|
#    #| debitAccount | string |111-ACD|eq|
#    
#    Given Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001
#    
#    #To delete the values inserted into the DB
#    #And Delete Record in the table ExchangeRate for the following criteria
#      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
#      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~100-CBE~123-ABC~USD~485 |
#      #
#    #To delete the values inserted into the DB
#    #And Delete Record in the table ExchangeRate for the following criteria
#      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
#      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~111-ACD~321-ZXC~INR~125 |  
#      #
#    #To delete the values inserted into the DB
#    #And Delete Record in the table PaymentOrder_extension for the following criteria
#      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
#      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~111-ACD~321-ZXC~INR~125 | 
#      #
#    #To delete the values inserted into the DB
#    #And Delete Record in the table ms_payment_order for the following criteria
#      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
#      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~100-CBE~123-ABC~USD~485 |
#      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 100-CBE |
#      #
#    #To delete the values inserted into the DB
#    #And Delete Record in the table ms_payment_order for the following criteria
#      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
#      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~111-ACD~321-ZXC~INR~125 |    
#      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 111-ACD |
