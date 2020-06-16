
  Feature: EnumDataValidation
  
  Background: To setup the preconfigs
    
    Given Set the test backgound for PAYMENT_ORDER API    
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
    And MS request header "roleId" is set to "ADMIN"
    And MS request header "Content-Type" is set to "application/json"
  
   Scenario Outline: Create a new Payment Order with Currency as INR

    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"333-ENU","paymentReference":"paytest","paymentDetails":"Success","currency":"INR","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
  
 
   Scenario Outline: Create a new Payment Order with Currency not part of Enum

    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 400
    And MS JSON response string property key "message" should contain value "EnumCurrency"
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"222-ENU","paymentReference":"paytest","paymentDetails":"Success","currency":"EUR","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    Scenario Outline: Create a new Payment Order with Enum value as null
  
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 400
     And MS JSON response string property key "message" should contain value "EnumCurrency"
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"1233-ENU","paymentReference":"paytest","paymentDetails":"Success","currency":"","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
   
    Scenario: To delete created record
    
    #To delete the values inserted into the DB
    #Given enter tablename to delete ms_payment_order_ExchangeRate
    #And enter value to be deleted
    #| Fields   | type | data|condition|
    #| PaymentOrder_paymentOrderId | string |PO~100-CBE~333-ENU~INR~483|eq|
    #| exchangeRates_id | string |91|eq|
    
    #To delete the values inserted into the DB
    #Given enter tablename to delete ms_payment_order
    #And enter value to be deleted
    #| Fields   | type | data|condition|
    #| paymentOrderId | string |PO~100-CBE~333-ENU~INR~483|eq|
    #| debitAccount | string |100-CBE|eq|
    #Given Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001
    #
    #To delete the values inserted into the DB
    #And Delete Record in the table ms_payment_order_ExchangeRate for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~100-CBE~333-ENU~INR~483 |
      #
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~100-CBE~333-ENU~INR~483 |
      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 100-CBE |
