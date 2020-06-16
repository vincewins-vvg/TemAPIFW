
   Feature: GetPaymentOrders-AllPO
   
   Background: To set preconfigs
   
    Given Set the test backgound for PAYMENT_ORDER API
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
    
    And MS request header "Content-Type" is set to "application/json"
    
   Scenario Outline: Create  new Payment Orders
    Given MS request header "roleId" is set to "ADMIN"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"337-ENU","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    |{"fromAccount":"100-CBE","toAccount":"340-ENU","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    Scenario: To get created PO

    Given MS request header "roleId" is set to "[ADMIN,BANKER]"    
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200
    #Then MS JSON property "items" should contain at least 1 elements
    
    #To delete the values inserted into the DB
    #Given enter tablename to delete ms_payment_order
    #And enter value to be deleted
    #| Fields   | type | data|condition|
    #| paymentOrderId | string |PO~100-CBE~340-ENU~USD~483|eq|
    #| debitAccount | string |100-CBE|eq|
    #
    #Given enter tablename to delete ms_payment_order
    #And enter value to be deleted
    #| Fields   | type | data|condition|
    #| paymentOrderId | string |PO~100-CBE~337-ENU~USD~483|eq|
    #| debitAccount | string |100-CBE|eq|
    
    #Given Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001
    #To delete the values inserted into the DB
    #And Delete Record in the table ms_payment_order_ExchangeRate for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~100-CBE~340-ENU~USD~483 |
      #
    #And Delete Record in the table ms_payment_order_ExchangeRate for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~100-CBE~337-ENU~USD~483 |    
      #
    #To delete the values inserted into the DB
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~100-CBE~340-ENU~USD~483 |
      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 100-CBE |
      #
        #To delete the values inserted into the DB
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~100-CBE~337-ENU~USD~483 |
      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 100-CBE |   