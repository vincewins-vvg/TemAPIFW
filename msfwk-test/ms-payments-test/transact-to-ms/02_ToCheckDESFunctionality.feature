Feature: 02_ToCheckDESFunctionality 

Scenario: To create RR Param for Payment Order and check DES Functionality

#To create a RR PARAM entry for PAYMENT.ORDER application
	Given I post an OFS Message "RR.PARAM,/I/PROCESS//0,INPUTT/123456,FBNK.PAYMENT.ORDER" 
	And set wait time of 10 seconds 
	
	#To check if entry created for PAYMENT.ORDER Group in RR PARAM table
	Then verify if entry for "FBNK.PAYMENT.ORDER" is present in t24 table "F_RR_PARAM" 
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
	Then  verify if entry for "PaymentOrderId" is present in t24 table "FBNK_DATA_EVENTS"
	
	#   To check entry in F_DATA_EVENTS table for the created PO is processed
	Then  check if the "PaymentOrderId" in t24 table "FBNK_DATA_EVENTS" has been processed