#Author: sabapathy

Feature: PayloadKeyNull MSF-2181
  
  Background: To setup the preconfigs
    
    Given Set the test backgound for PAYMENT_ORDER API    
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
    And MS request header "roleId" is set to "ADMIN"
    And MS request header "Content-Type" is set to "application/json"
  
   Scenario Outline: Create a new Payment Order with Null value for JSON-Data,Object,Nested-Object and Array 

    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 200
    
    Examples:
    
    |payload|
    |{"fromAccount":"101","toAccount":"102","paymentReference":"paytest","paymentDetails":null,"currency":"USD","amount":10,"expires":0,"fileContent":"TEST","paymentMethod":{"id":1,"name":"ONLINE_TXN","card":{"cardid":1,"cardname":null,"cardlimit":10}},"exchangeRates":[{"id":11,"name":null,"value":10},{"id":12,"name":"WesternUnion","value":10}],"payeeDetails":{"payeeName":"bsnl","payeeType":null},"descriptions":[null]}|
    
    
    Scenario Outline: Create a new Payment Order with Null value for Amount (i.e XACML Policy-Validation Applicable) 

    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    Then MS response code should be 401
    
    Examples:
    
    |payload|
    |{"fromAccount":"201","toAccount":"202","paymentReference":"paytest","paymentDetails":"paymentDetails_TEST","currency":"USD","amount":null,"expires":0,"fileContent":"TEST","paymentMethod":{"id":1,"name":"ONLINE_TXN","card":{"cardid":1,"cardname":"HDFC","cardlimit":10}},"exchangeRates":[{"id":1,"name":"MoneyExchange","value":10}],"payeeDetails":{"payeeName":"bsnl","payeeType":"ONLINE"},"descriptions":[]}|
    
		
		Scenario: To get PO with Null value for JSON-Data,Object,Nested-Object and Array 
		
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders/PO~101~102~USD~10"

    And MS query parameter for Azure env is set to value ""
    And MS request header "roleId" is set to "ADMIN"
    
    When a "GET" request is sent to MS
    Then MS response code should be 200
    
    