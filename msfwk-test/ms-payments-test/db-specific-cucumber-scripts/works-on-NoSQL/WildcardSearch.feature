Feature: WildcardSearch
Background: To set the preconfig for the scenarios 

	Given Set the test backgound for PAYMENT_ORDER API 
	Given create a new MS request with code using Restassured arguments "CREATE_PAYMENTORDER_AUTH_CODE" 
	And MS query parameter for Azure env is set to value "" 
	#And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And MS request header "Content-Type" is set to "application/json" 
	
	# prerequisite
	#data_1
 	Scenario Outline: create user by post method(to check the existing) 

	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "userId" should exist 
	And MS JSON response string property key "status" should equal value "Successful" 
	Then store the MS response data from restassured json response "user_Id" in keyvalue pair "userId" from file path "src/test/resources/reusable-test-data/KeyAndValues3.txt" 
	
	Examples: 
		|payload|
		|{"name":"Nithesh","email":"nithesh23@gmail.com"}|
		
	Scenario: To get the created userid using get method(to check the existing) 

	And fetch the MS response data for rest assured json response "user_Id" from file path "src/test/resources/reusable-test-data/KeyAndValues3.txt" 
	#Use the store user_Id in CreatePaymentOrder in the request URI
	And concat the MS request URI "v1.0.0/user" with Bundle Value "{user_Id}" 
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "userId" should exist 
	And MS JSON response string property key "name" should equal value "Nithesh" 
	And MS JSON response string property key "email" should equal value "nithesh23@gmail.com" 
	
	# wildcard search
	# data_2
	Scenario Outline: create user by post method 

	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "userId" should exist 
	And MS JSON response string property key "status" should equal value "Successful" 
	
	Examples: 
		|payload|
		|{"name":"Sathesh","email":"sathesh92@gmail.com"}|
		
		# data_3
	Scenario Outline: create user by post method
	 
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "userId" should exist 
	And MS JSON response string property key "status" should equal value "Successful" 
	
	Examples: 
		|payload|
		|{"name":"Logashwari","email":"logsh@yahoo.com"}|
		
		# data_4
	Scenario Outline: create user by post method 
	
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "userId" should exist 
	And MS JSON response string property key "status" should equal value "Successful" 
	
	Examples: 
		|payload|
		|{"name":"Aiswarya","email":"aish555@gmail.com"}|
		
		# data_5
	Scenario Outline: create user by post method 

	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "userId" should exist 
	And MS JSON response string property key "status" should equal value "Successful" 
	
	Examples: 
		|payload|
		|{"name":"Vinothkumar","email":"vinod@yahoo.com"}|
		
		# data_6
	Scenario Outline: create user by post method 
	
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "userId" should exist 
	And MS JSON response string property key "status" should equal value "Successful" 
	
	Examples: 
		|payload|
		|{"name":"ajithkumar","email":"ajith@tce.edu"}|
		
		# data_7
	Scenario Outline: create user by post method 
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "userId" should exist 
	And MS JSON response string property key "status" should equal value "Successful" 
	
	Examples: 
		|payload|
		|{"name":"Vinith","email":"vinvi@tce.edu"}|
		
		# data_8
	Scenario Outline: create user by post method 
	
	And MS request URI is "v1.0.0/user" 
	And post the static MS JSON as payload <payload> 
	When a "POST" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	And MS JSON property "userId" should exist 
	And MS JSON response string property key "status" should equal value "Successful" 
	
	Examples: 
		|payload|
		|{"name":"balaji","email":"balajil34@gmail.com"}|
		
	Scenario: wildcard search using user names_1 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "Esh" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	#And MS JSON response string property key "name[1]" should equal value "Sathesh" 
	#And MS JSON response string property key "email[1]" should equal value "sathesh92@gmail.com" 
	#And MS JSON response string property key "name[0]" should equal value "Nithesh" 
	#And MS JSON response string property key "email[0]" should equal value "nithesh23@gmail.com" 
	Then MS JSON property "" should contain at least 2 elements
	
	Scenario: wildcard search using user names_2 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "NiTH" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	#And MS JSON response string property key "name[0]" should equal value "Nithesh" 
	#And MS JSON response string property key "email[0]" should equal value "nithesh23@gmail.com" 
	#And MS JSON response string property key "name[1]" should equal value "Vinith" 
	#And MS JSON response string property key "email[1]" should equal value "vinvi@tce.edu" 
	Then MS JSON property "" should contain at least 2 elements
	
	Scenario: wildcard search using user names_3 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "thk" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	#And MS JSON response string property key "name[0]" should equal value "Vinothkumar" 
	#And MS JSON response string property key "email[0]" should equal value "vinod@yahoo.com" 
	#And MS JSON response string property key "name[1]" should equal value "ajithkumar" 
	#And MS JSON response string property key "email[1]" should equal value "ajith@tce.edu" 
	Then MS JSON property "" should contain at least 2 elements
	
	Scenario: wildcard search using user names_4 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "WAR" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	#And MS JSON response string property key "name[0]" should equal value "Logashwari" 
	#And MS JSON response string property key "email[0]" should equal value "logsh@yahoo.com" 
	#And MS JSON response string property key "name[1]" should equal value "Aiswarya" 
	#And MS JSON response string property key "email[1]" should equal value "aish555@gmail.com" 
	Then MS JSON property "" should contain at least 2 elements
	
	Scenario: wildcard search using user names_5 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "Aji" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	#And MS JSON response string property key "name[0]" should equal value "ajithkumar" 
	#And MS JSON response string property key "email[0]" should equal value "ajith@tce.edu" 
	#And MS JSON response string property key "name[1]" should equal value "balaji" 
	#And MS JSON response string property key "email[1]" should equal value "balajil34@gmail.com" 
	Then MS JSON property "" should contain at least 2 elements
	
	Scenario: wildcard search using user names_6 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "!@#$" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should contain value "No User found" 
	And MS JSON response string property key "code" should contain value "400" 
	
	Scenario: wildcard search using user names_7 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "null" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should contain value "No User found" 
	And MS JSON response string property key "code" should contain value "400" 
	
	Scenario: wildcard search using user names and mail id_8 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "Aji" 
	And MS query parameter "email" is set to value "tce" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	#And MS JSON response string property key "name[0]" should equal value "ajithkumar" 
	#And MS JSON response string property key "email[0]" should equal value "ajith@tce.edu" 
	Then MS JSON property "" should contain at least 1 elements
	
	Scenario: wildcard search using user names and mail id_9 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "thk" 
	And MS query parameter "email" is set to value "yah" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 200 
	#And MS JSON response string property key "name[0]" should equal value "Vinothkumar" 
	#And MS JSON response string property key "email[0]" should equal value "vinod@yahoo.com" 
	Then MS JSON property "" should contain at least 1 elements
	
	Scenario: wildcard search using  valid user names and invalid mail id_10 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "thk" 
	And MS query parameter "email" is set to value "tem" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400
	And MS JSON response string property key "message" should contain value "No User found" 
	And MS JSON response string property key "code" should contain value "400" 
		
	Scenario: wildcard search using invalid user names and valid mail id_11 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "name" is set to value "xyza" 
	And MS query parameter "email" is set to value "tce" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should contain value "No User found" 
	And MS JSON response string property key "code" should contain value "400" 
	
	Scenario: wildcard search only valid mail id_12 

	And MS request URI is "v1.0.0/users" 
	And MS query parameter "email" is set to value "tce" 
	
	When a "GET" request is sent to MS 
	And log all MS response in console 
	Then MS response code should be 400 
	And MS JSON response string property key "message" should contain value "Name Parameter is mandatory" 
	And MS JSON response string property key "code" should contain value "400" 
	
	
	
	
	
	
	
	
	
	