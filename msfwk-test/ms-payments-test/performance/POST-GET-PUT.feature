   Feature: POST-GET-PUT 
  
   Background: To setup the preconfigs
  
   #Given Set the test backgound for PAYMENT_ORDER API
   #And MS query parameter for Azure env is set to value ""    
   #And MS request header "Content-Type" is set to "application/json"
   #And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
  
   Scenario Outline: Create a new Payment Order
   
  #To insert the Payment reference details into the DB for testing purpose
  #Given enter the tablename ms_reference_data
  #And enter data for table
  #| Fields   | type | data|
  #| type | string |paymentref|
  #| value | string |payperf|
  #| description | string |Payment ref|
  
   # Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE"
   # And MS request URI is "v1.0.0/payments/orders"    
   # And post the static MS JSON as payload <payload>
   # When a "POST" request is sent to MS
   # And log all MS response in console
    
   # Examples:
    
   # |payload|
	 #|{"fromAccount":"100-CBE","toAccount":"201-PERF","paymentReference":"payperf","paymentDetails":"Success","currency":"INR","amount":483,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
   # 
   # 
   # Scenario: To get created PO
   # Given create a new MS request with code using Restassured arguments "GET_PAYMENTODER_AUTH_CODE"
   # And MS request URI is "v1.0.0/payments/orders/PO~100-CBE~201-PERF~INR~483"    
   # When a "GET" request is sent to MS
   # And log all MS response in console
   # 
   # Scenario Outline: Update an existing Payment Order
   # Given create a new MS request with code using Restassured arguments "UPDATE_PAYMENTORDER_AUTH_CODE"
   # And MS request URI is "v1.0.0/payments/orders/PO~100-CBE~201-PERF~INR~483"
   # And post the static MS JSON as payload <payload> 
   # When a "PUT" request is sent to MS
   # And log all MS response in console
   # 
   #  Examples:
   # 
   # |payload|
   # |{ "debitAccount": "100-CBE", "paymentId": "PO~100-CBE~201-PERF~INR~483", "status": "changed", "details": "changed", "paymentMethod": { "id": 22, "name": "MSTester", "card": { "cardid": 11, "cardname": "Diners", "cardlimit": 11.11 } }, "exchangeRates": [ { "name": "INR", "value": 22.22 } ] }{ "debitAccount": "100-CBE", "paymentId": "PO~100-CBE~222-VVG~USD~433", "status": "changed", "details": "changed", "paymentMethod": { "id": 22, "name": "MSTester", "card": { "cardid": 11, "cardname": "Diners", "cardlimit": 11.11 } }, "exchangeRates": [ { "name": "INR", "value": 22.22 } ] }|