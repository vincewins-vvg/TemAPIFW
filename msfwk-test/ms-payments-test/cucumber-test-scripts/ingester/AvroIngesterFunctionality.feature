
Feature: AvroIngesterFunctionality    

 Scenario: Send Data to topic and validate Payment Order functionality
  
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |paying|
  | description | string |Payment ref|

    Given Set the test backgound for PAYMENT_ORDER API
    Given Set the Testcase id MS-Test-PO-Ingester-001 for company GB0010001
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      #| MS-Test-PO-Ingester-001    | paymentOrderId    | eq       | string   | PO~10995~898789~USD~100 |

    When Send Data to Topic for following records
      | TestCaseID                 | AvroJson                                          | ApplicationName  |
      | MS-Test-PO-Ingester-001    | avro/ingester/PaymentOrderInputAvroData.avro           | PAYMENT_ORDER  |
      
    And set timeout session for 30 seconds
    
    Then Set the following data criteria
      | TestCaseID                 | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-PO-Ingester-001    | paymentOrderId    | eq       | string   | PO~10995~898789~USD~100 |

    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID                 | ColumnName      | ColumnValue |
      | MS-Test-PO-Ingester-001    | paymentOrderId  | PO~10995~898789~USD~100 |
      
      #To check API response for the record created above and the mapping
   
    Given create a new MS request with code using Restassured arguments "GET_PAYMENTODER_AUTH_CODE"
    And MS request URI is "payments/orders/PO~10995~898789~USD~100"
    And MS query parameter for Azure env is set to value ""
    And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    And MS request header "Content-Type" is set to "application/json"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    And MS JSON property "paymentOrder.exchangeRates[0].id" should exist
    And MS JSON property "paymentOrder.exchangeRates[1].id" should exist
    And check full response with expected json content from file path "src/test/resources/static-response/GetPOResponseForAvroIngester.json"
    