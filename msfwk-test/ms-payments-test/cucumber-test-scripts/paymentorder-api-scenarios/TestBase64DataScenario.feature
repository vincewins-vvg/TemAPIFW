
  Feature: TestBase64DataScenario
  
  Background: To setup the preconfigs
    
       
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
    And MS request header "roleId" is set to "ADMIN"
    And MS request header "Content-Type" is set to "application/json"
  
   Scenario Outline: Create a new Payment Order with invalid file content field value
    #fileContent":"tester"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 400
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"333-ENUA","paymentReference":"paytest","paymentDetails":"Success","currency":"INR","amount":483,"expires":10,"fileContent":"tester","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
 
   Scenario Outline: Create a new Payment Order with invalid padding position
   #fileContent":"test==
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 400
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"333-ENUB","paymentReference":"paytest","paymentDetails":"Success","currency":"INR","amount":483,"expires":10,"fileContent":"test==","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
   Scenario Outline: Create a new Payment Order with valid padding char position
    #fileContent":"tes="
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200
    
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"333-ENUS","paymentReference":"paytest","paymentDetails":"Success","currency":"INR","amount":483,"expires":10,"fileContent":"tes=","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}| 