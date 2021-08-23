Feature: 03_Transact to MS E2E 

Background: To set the preconfig for the scenarios 

	Given Set the test backgound for PAYMENT_ORDER API 
	Given Set the Testcase id MS-Test-PO-TransactE2E for company GB0010001 
	
Scenario: Create a new Payment Order 
#To insert the Payment reference details into the DB for testing purpose
	Given enter the tablename ms_reference_data 
	And enter data for table 
		| Fields   | type | data|
		| type | string |paymentref|
		| value | string |paytesttransact|
		| description | string |Payment ref|
		
		#To create a RR PARAM entry for PAYMENT.ORDER application
	And I post an OFS Message "RR.PARAM,/I/PROCESS//0,INPUTT/123456,PAYMENT.ORDER" 
	And set wait time of 10 seconds 
	
	#To check if entry created for PAYMENT.ORDER Group in RR PARAM table
	Then verify if entry for "PAYMENT.ORDER" is present in t24 table "F_RR_PARAM" 
	And set wait time of 10 seconds 
	
	#To create customer
	#To create a Party/Customer via OFS string and store the Record Id in a bundle
	And I post an OFS Message and store record id in "CustomerId1" and message "CUSTOMER,/I/PROCESS//0,INPUTT/123456,,MNEMONIC::=mnemonicvalue,SHORT.NAME::=INFINITY,NAME.1::=TIM,NAME.2::=HARRY,TOWN.COUNTRY:1:1=CHENNAI,ACCOUNT.OFFICER::=1,NATIONALITY::=IN,RESIDENCE::=IN,LANGUAGE::=1,SECTOR::=1001,INDUSTRY::=1000,TARGET::=999,CUSTOMER.STATUS::=1,STREET:1:1=SR" 
	
	And set wait time of 10 seconds 
	#To check entry in FBNK_CUSTOMER table for the created Customer/Part
	Then verify if entry for "CustomerId1" is present in t24 table "FBNK_CUSTOMER" 
	
	#To create debit account
	And I post an OFS Message and store record id in "debitAccount" and pass a bundle value in message "ACCOUNT,/I/PROCESS//0,INPUTT/123456/,,CUSTOMER::=" "CustomerId1" ",CATEGORY::=1001,CURRENCY::=USD" 
	
	And set wait time of 10 seconds 
	
	#	#To check entry in FBNK_ACCOUNT table for the created ACCOUNT
	Then verify if entry for "debitAccount" is present in t24 table "FBNK_ACCOUNT" 
	
	#To create credit account
	And I post an OFS Message and store record id in "creditAccount" and pass a bundle value in message "ACCOUNT,/I/PROCESS//0,INPUTT/123456/,,CUSTOMER::=" "CustomerId1" ",CATEGORY::=1001,CURRENCY::=USD" 
	
	And set wait time of 10 seconds 
	#To check entry in FBNK_ACCOUNT table for the created ACCOUNT
	Then verify if entry for "creditAccount" is present in t24 table "FBNK_ACCOUNT" 
	
	
	#	## To create a PO via OFS string and store the Record Id in a bundle
	And I post an OFS Message and store record id in "PaymentOrderId" and pass 3 bundle values in message "PAYMENT.ORDER,/I/PROCESS//0,INPUTT/123456/,,PAYMENT.ORDER.PRODUCT:1:1=ACCLM,ORDERING.CUST.NAME:1:1=" "CustomerId1" ",DEBIT.ACCOUNT:1:1=" "debitAccount" ",CREDIT.ACCOUNT:1:1=" "creditAccount" ",PAYMENT.EXECUTION.DATE:1:1=20200416,CREDIT.CURRENCY:1:1=USD,DEBIT.CCY:1:1=USD,PAYMENT.AMOUNT:1:1=10,ORDERING.REFERENCE:1:1=paytesttransact" 
	And set wait time of 10 seconds 
	
	#To check entry in FBNK_PAYMENT_ORDER table for the created PO
	Then  verify if entry for "PaymentOrderId" is present in t24 table "FBNK_PAYMENT_ORDER" 
	
	#  To check entry in F_DATA_EVENTS table for the created PO
	Then  verify if entry for "PaymentOrderId" is present in t24 table "F_DATA_EVENTS" 
	
	#   To check entry in F_DATA_EVENTS table for the created PO is processed
	Then  check if the "PaymentOrderId" in t24 table "F_DATA_EVENTS" has been processed 
	#	
	#	#Scenario: To validate whether the created payment order is available in the ms_payment_order database	
	Then Set the following data criteria with bundle value 
		| TestCaseID     	| ColumnName  	| Operator  | DataType 	| ColumnValue        |
		| MS-Test-PO-TransactE2E	|paymentOrderId   	| eq       	| string   	| PaymentOrderId	 		 |
		
	And Validate the below details and bundle value from the db table ms_payment_order and check no of record is 1 
		| TestCaseID                    | ColumnName | ColumnValue |
		| MS-Test-PO-TransactE2E       | status     | INITIATED |
		| MS-Test-PO-TransactE2E       | creditAccount     | creditAccount |
		| MS-Test-PO-TransactE2E       | debitAccount    | debitAccount |
		| MS-Test-PO-TransactE2E       | paymentReference    | paytesttransact |
		| MS-Test-PO-TransactE2E       | paymentDetails    | paytesttransact |
		
		#Scenario: To get the created paymentorder
		
	Given MS request header "Content-Type" is set to "application/json" 
	Given create a new MS request with code "" 
	And set the request path as "v1.0.0/payments/orders/{PaymentOrderId}" 
	And set request header key "Authorization" with value "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw" 
	And set request header key "roleId" with value "ADMIN" 
	And set request header key "serviceid" with value "client" 
	And set request header key "channelid" with value "web" 
	And set request header key "customfilterid" with value "test" 
	When a 'GET' request is sent 
	Then the response code should be 200 
	Then property "paymentOrder(0)/fromAccount" should be equal to bundle value "" "debitAccount" "" 
	#And property "accountReservations(1)/accountKey" should be equal to bundle value "GB0010001-" "LegacyIdOfAA1" ""
	Then property "paymentOrder(0)/toAccount" should be equal to bundle value "" "creditAccount" "" 
	Then property "paymentOrder(0)/paymentReference" should be equal to string "paytesttransact" 
	Then property "paymentOrder(0)/amount" should be equal to string "10" 
	Then property "paymentOrder(0)/currency" should be equal to string "USD" 
	Then property "paymentStatus(0)/paymentId" should be equal to bundle value "" "PaymentOrderId" "" 
	Then property "paymentStatus(0)/status" should be equal to string "INITIATED" 
	
	#To delete the values inserted into the DB
	And Delete Record in the table ms_reference_data for the following criteria 
		| TestCaseID              | ColumnName    | Operator | DataType | ColumnValue |
		| MS-Test-PO-TransactE2E | type | eq       | string   | paymentref |    
		| MS-Test-PO-TransactE2E | value | eq       | string   | paytesttransact |
    