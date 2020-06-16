
Feature: UpdatePaymentOrder

#Update scenario is not appplicable for extension data input payload

Background: To set the preconfig for the scenarios

    Given Set the test backgound for PAYMENT_ORDER API
    Given create a new MS request with code using Restassured arguments ""
    #Use the store Payment Id in CreatePaymentOrder in the request URI
    
    And MS query parameter for Azure env is set to value ""
    And MS request header "roleId" is set to "[ADMIN,BANKER]"
    And MS request header "Content-Type" is set to "application/json"
    
    Scenario Outline: Create a new Payment Order with one Role Id
    Given MS request URI is "payments/orders"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200  
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"222-VVG","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":433,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    Scenario Outline: Create a new Payment Order with incorrect second Role Id
    And MS request header "roleId" is set to "[ADMIN,XXNKER]"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200

   Scenario: Update an existing Payment Order
    
    Given MS request URI is "payments/orders/PO~100-CBE~222-VVG~USD~433"
    
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/UpdatePaymentOrder.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
  
    #And MS JSON response string property key "paymentId" should equal value "PO~100-CBE~123-ABC~USD~483"

    Scenario: Update an existing Payment Order with incorrect Debit Account
    
    Given MS request URI is "payments/orders/PO~100-CBE~222-VVG~USD~433"
    And MS request header "Content-Type" is set to "application/json"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/UpdatePOWrongPaymentId.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    
    Scenario: Update an existing Payment Order with incorrect Payment Id in payload 
    Given MS request URI is "payments/orders/PO~100-CBE~222-VVG~USD~433"
    And MS request header "Content-Type" is set to "application/json"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/UpdatePOWrongPaymentId.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    
    Scenario: Update an existing Payment Order with incorrect Payment Id in URI 
    Given MS request URI is "payments/orders/PO~100-CBE~123-ABC~USD~43211"
    And MS request header "Content-Type" is set to "application/json"
    And the MS request body is set to the contents of "src/test/resources/cucumber-json-payload/UpdatePaymentOrder.json"
    When a "PUT" request is sent to MS
    And log all MS response in console
    Then MS response code should be 400
    
    
    Scenario: To get updated PO
    Given MS request URI is "payments/orders/PO~100-CBE~222-VVG~USD~433"
    
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    
    #Incorrect behaviour on SQL
    #And check full response with expected json content from file path "src/test/resources/static-response/UpdatedPaymentOrderResponse.json"
    
    Scenario: To delete the created POs
    #To delete the values inserted into the DB
    #Given enter tablename to delete ms_payment_order
    #And enter value to be deleted
    #| Fields   | type | data|condition|
    #| paymentOrderId | string |PO~100-CBE~222-VVG~USD~433|eq|
    #| debitAccount | string |100-CBE|eq|
    
    #Given Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001
    #To delete the values inserted into the DB
    #And Delete Record in the table ms_payment_order_ExchangeRate for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~100-CBE~222-VVG~USD~433 |
    #
     #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~100-CBE~222-VVG~USD~433 |
      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 100-CBE |
    