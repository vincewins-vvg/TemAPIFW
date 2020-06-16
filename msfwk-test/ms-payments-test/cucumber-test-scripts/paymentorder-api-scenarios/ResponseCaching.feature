
    Feature: ResponseCaching
    
    Background: To set preconfigs   
    Given Set the test backgound for PAYMENT_ORDER API
    
    Scenario Outline: Create new Payment Order for testing purpose
   
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
    And MS request header "roleId" is set to "ADMIN"
    And MS request header "Content-Type" is set to "application/json"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"337-VVV","paymentReference":"paytest","paymentDetails":"Success","currency":"USD","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|

    
    
    
    Scenario: To get created PO continously and then pass an incorrect PO ID
    
    Given create a new MS request with code using Restassured arguments ""
    
    And MS request URI is "payments/orders/PO~100-CBE~337-VVV~USD~483"
    And MS request header "roleId" is set to "[ADMIN,BANKER]"
    And MS query parameter for Azure env is set to value ""
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200    
    
    
    Given create a new MS request with code using Restassured arguments ""
    
    And MS request URI is "payments/orders/PO~100-CBE~337-VVV~USD~483"
    And MS request header "roleId" is set to "[ADMIN,BANKER]"
    And MS query parameter for Azure env is set to value ""
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200 
    
    #To pass incorrect PO ID in URL
    Given create a new MS request with code using Restassured arguments ""
    #Use the store Payment Id in CreatePaymentOrder in the request URI
    And MS request URI is "payments/orders/PO~100-CBE~337-VVV~USD~"
    And MS request header "roleId" is set to "[ADMIN,BANKER]"
    And MS query parameter for Azure env is set to value ""
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200 
    
    #To delete the values inserted into the DB
    #Given enter tablename to delete ms_payment_order
    #And enter value to be deleted
    #| Fields   | type | data|condition|
    #| paymentOrderId | string |PO~100-CBE~337-VVV~USD~483|eq|
    #| debitAccount | string |100-CBE|eq|
    
    #Given Set the Testcase id MS-Test-Payments-MS-001 for company GB0010001
    #To delete the values inserted into the DB
    #And Delete Record in the table ms_payment_order_ExchangeRate for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | PaymentOrder_paymentOrderId | eq       | string   | PO~100-CBE~337-VVV~USD~483 |
    #
     #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
      #| MS-Test-Payments-MS-001 | paymentOrderId | eq       | string   | PO~100-CBE~337-VVV~USD~483 |
      #| MS-Test-Payments-MS-001 | debitAccount | eq       | string   | 100-CBE |
   #
    #Scenario: To get created PO after deleting the PO record
    #
    #Given create a new MS request with code using Restassured arguments ""
   #
    #And MS request URI is "payments/orders/PO~100-CBE~337-VVV~USD~483"
    #And MS request header "roleId" is set to "[ADMIN,BANKER]"
    #And MS query parameter for Azure env is set to value ""
    #When a "GET" request is sent to MS
    #And log all MS response in console
    #Then MS response code should be 200
   