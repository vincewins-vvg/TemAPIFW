
  Feature: CheckDuplicateEntryOfUUID
  
  Background: To set the preconfigs
  
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
    And MS request header "roleId" is set to "[ADMIN,BANKER]"
    And MS request header "UUID" is set to "fda5244e-a140-470e-83ad-768cb2257lkjs"
    And MS request header "Content-Type" is set to "application/json"
  

  Scenario Outline: Send a valid request for PO creation with a UUID
  
  #To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |payuuid|
  | description | string |Payment ref|
  
    

    And post the static MS JSON as payload <payload>    
    When a "POST" request is sent to MS
       
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"232-IOBX","paymentReference":"payuuid","paymentDetails":"Success","currency":"INR","amount":126,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    Scenario Outline: Send a valid request with same UUID
    
    When post the static MS JSON as payload <payload>    
    And a "POST" request is sent to MS
    #Then MS response code should be 404
   
   Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"232-IOBXC","paymentReference":"payuuid","paymentDetails":"Success","currency":"INR","amount":126,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|