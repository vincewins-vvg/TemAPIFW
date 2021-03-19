#Author:Vinoth (Unique index)
#Feature: PaymentCustomerFailure
#Background: to set the preconfig for the scenarios
#
#	Given Set the test backgound for PAYMENT_ORDER API 
#	And create a new MS request with code using Restassured arguments "" 
#	And MS request URI is "v1.0.0/payments/customers"
#	And MS query parameter for Azure env is set to value "" 
#	And MS request header "Authorization" is set to "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
#	And MS request header "Content-Type" is set to "application/json" 
#	
#	#POST API
#	#To check the Duplicate creation of unique index record
#	
#Scenario Outline: create customer using post method
#
#	When post the static MS JSON as payload <payload> 
#	When a "POST" request is sent to MS 
#	And log all MS response in console 
#	Then MS response code should be 200 
#	And MS JSON property "customerId" should exist 
#	And MS JSON response string property key "status" should equal value "Created"
#
#	
#	Examples: 
        #|payload|
#		|{"customerId":"Test2","customerName":"SAM","account":"Savings","loanTypes":["education loan"],"dateOfJoining":"2020-09-22"}|	
        #
#Scenario Outline: create customer of same unique ID
#
#	When post the static MS JSON as payload <payload> 
#	When a "POST" request is sent to MS 
#	And log all MS response in console 
#	Then MS response code should be 400 
#	And MS JSON response string property key "message" should contain value "duplicate key"
    #And MS JSON response string property key "code" should contain value "MSF-999"
#	
#	
#	Examples: 
        #|payload|
#		|{"customerId":"Test2","customerName":"SAM","account":"Savings","loanTypes":["education loan"],"dateOfJoining":"2020-08-26"}|
#		
#						