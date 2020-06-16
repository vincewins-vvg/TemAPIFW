 
  Feature: XacmlFunctionality
  
  Background: To setup the preconfigs
  
    Given Set the test backgound for PAYMENT_ORDER API
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
    
    And MS request header "Content-Type" is set to "application/json"
  
   Scenario Outline: Create a new Payment Order with one Role Id
    And MS request header "roleId" is set to "ADMIN"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200
    And MS JSON response string property key "status" should equal value "INITIATED"
    And MS JSON response string property key "details" should equal value "Success"
    
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-111","toAccount":"222-333","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":433,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    Scenario Outline: Create a new Payment Order with incorrect second Role Id
    And MS request header "roleId" is set to "[ADMIN,XXNKER]"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-122","toAccount":"223-322","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    Scenario Outline: Create a new Payment Order with incorrect first Role Id
    And MS request header "roleId" is set to "[xxMIN,BANKER]"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 401
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"222-ASD","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
   
    Scenario Outline: Create a new Payment Order with value as lower case 
    And MS request header "roleId" is set to "[admin,banker]"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 401
    
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"123-ZZZ","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    Scenario Outline: Create a new Payment Order with amount greater than and equal configured amount 
    And MS request header "roleId" is set to "[ADMIN,BANKER]"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 401
    
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"123-500","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":500,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    |{"fromAccount":"100-CBE","toAccount":"123-501","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":501,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    
    Scenario Outline: Create a new Payment Order with amount less than and equal configured amount 
    And MS request header "roleId" is set to "[ADMIN,BANKER]"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200
    
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"123-499","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":499,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    
    Scenario: To delete created records
    #To delete the values inserted into the DB
    #Given enter tablename to delete ms_payment_order
    #And enter value to be deleted
    #| Fields   | type | data|condition|
    #| paymentOrderId | string |PO~100-111~222-333~USD~433|eq|
    #| debitAccount | string |100-111|eq|
    #
      #To delete the values inserted into the DB
    #Given enter tablename to delete ms_payment_order
    #And enter value to be deleted
    #| Fields   | type | data|condition|
    #| paymentOrderId | string |PO~100-122~223-322~USD~483|eq|
    #| debitAccount | string |100-122|eq|
    
    #Given Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001
    #To delete the values inserted into the DB
    #And Delete Record in the table ms_payment_order_ExchangeRate for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~100-111~222-333~USD~433 |
    #
    #And Delete Record in the table ms_payment_order_ExchangeRate for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~100-122~223-322~USD~483 |
      #
    #And Delete Record in the table ms_payment_order_ExchangeRate for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~100-122~499-322~USD~499 | 
      #
    #And Delete Record in the table ms_payment_order_ExchangeRate for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~100-CBE~123-499~USD~499 |    
      #
      #
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~100-CBE~123-499~USD~499 |
      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 100-CBE |
      #
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~100-111~222-333~USD~433 |
      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 100-111 |
      #
      #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~100-122~223-322~USD~483 |
      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 100-122 |
      #
      #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~100-122~499-322~USD~499 |
      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 100-122 |