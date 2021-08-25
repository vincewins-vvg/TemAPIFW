Feature: CommandBinaryIngesterFailure 

 Scenario: Send error prone data to topic and validate Payment Order functionality (incorrect PayRef)


    Given Set the test backgound for PAYMENT_ORDER API
    Given Set the Testcase id MS-Test-PO-CommandIngester-001 for company GB0010001
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      #| MS-Test-PO-CommandIngester-001    | paymentOrderId    | eq       | string   | PO~10995~898789~USD~100 |

    
    When send JSON data to topic ms-paymentorder-inbox-topic from file avro/ingester/CommandIngesterInvalidJSON.json for Application PAYMENT_ORDER
    
    And set timeout session for 30 seconds
 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | MS-Test-PO-CommandIngester-001| paymentOrderId    | eq       | string   | PO~1739~3621~USD~901 |

    
    And Validate if below details not present in db table ms_payment_order 
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | MS-Test-PO-CommandIngester-001    | paymentOrderId  | PO~1739~3621~USD~901 |
      
    
    And set timeout session for 30 seconds

    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
      | MS-Test-PO-CommandIngester-001| eventId    | eq       | string   | 4316e8-3ca-9-cifs-87200 |
      | MS-Test-PO-CommandIngester-001| eventType  | eq       | string   | ms-paymentorder.CreateNewPaymentOrder |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1
      | TestCaseID                    | ColumnName | ColumnValue |
      | MS-Test-PO-CommandIngester-001| status    | FAILED   |
      
      
      #To check outbox entries
      Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-CommandIngester-001| correlationId    | eq       | string   | 4316e8-3ca-9-cifs-87200 |
      | MS-Test-PO-CommandIngester-001| eventType        | eq       | string   | CommandFailed |
      
    #And Validate the below details from the db table ms_outbox_events
    And Validate the below details from the db table ms_outbox_events and check no of record is 1
    | TestCaseID                           | ColumnName     | ColumnValue |
    | MS-Test-PO-CommandIngester-001       | correlationId  | 4316e8-3ca-9-cifs-87200 |
    
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | MS-Test-PO-CommandIngester-001       | status         | DELIVERED   |
      | MS-Test-PO-CommandIngester-001       | payload        | "status":400 |
      | MS-Test-PO-CommandIngester-001       | payload        | "failureMessages":[{"message":"Invalid reference type data: bgvggk"|
  
  
   
  Scenario: Send error prone data to topic and validate Payment Order functionality (invalid Enum Currency)
  
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |cmdcur |
  | description | string |Payment ref|

    Given Set the test backgound for PAYMENT_ORDER API
    Given Set the Testcase id MS-Test-PO-CommandIngester-001 for company GB0010001
    #And Delete Record in the table ms_payment_order for the following criteria
      #| TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      #| MS-Test-PO-CommandIngester-001    | paymentOrderId    | eq       | string   | PO~10995~898789~USD~100 |

    
    When send JSON data to topic ms-paymentorder-inbox-topic from file avro/ingester/CommandIngesterInvalidCurrencyJSON.json for Application PAYMENT_ORDER
    
    And set timeout session for 30 seconds
 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | MS-Test-PO-CommandIngester-001| paymentOrderId    | eq       | string   | PO~173922~3621~USD~901 |

    
    And Validate if below details not present in db table ms_payment_order 
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | MS-Test-PO-CommandIngester-001    | paymentOrderId  | PO~173922~3621~USD~901 |
      
    
    And set timeout session for 30 seconds

    #Check the entries in Inbox
    Then Set the following data criteria
     | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue         |
     | MS-Test-PO-CommandIngester-001| eventId    | eq       | string   | 4316e8-3ca-9-cicur-87200 |
     | MS-Test-PO-CommandIngester-001| eventType  | eq       | string   | ms-paymentorder.CreateNewPaymentOrder |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1
     | TestCaseID                    | ColumnName | ColumnValue |
     | MS-Test-PO-CommandIngester-001| status    | FAILED   |
      
      
      #To check outbox entries
      Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | MS-Test-PO-CommandIngester-001| correlationId    | eq       | string   | 4316e8-3ca-9-cicur-87200 |
      | MS-Test-PO-CommandIngester-001| eventType        | eq       | string   | CommandFailed |
      
    #And Validate the below details from the db table ms_outbox_events
    And Validate the below details from the db table ms_outbox_events and check no of record is 1
    | TestCaseID                           | ColumnName     | ColumnValue |
    | MS-Test-PO-CommandIngester-001       | correlationId  | 4316e8-3ca-9-cicur-87200 |
    
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | MS-Test-PO-CommandIngester-001       | status         | DELIVERED   |
      | MS-Test-PO-CommandIngester-001       | payload        | "status":400 |
      | MS-Test-PO-CommandIngester-001       | payload        | "failureMessages":[{"message":"Cannot deserialize value of type|
     
   
   
  # Author: Sabapathy
  # MSF-2213 
  Scenario: Validate Command Event without JWT token as header
 
	#Delete existing record in ms_reference_table
	Given Set the test backgound for PAYMENT_ORDER API
  Given Set the Testcase id WithoutJWTToken for company GB0010001
  And Delete Record in the table ms_reference_data for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | WithoutJWTToken    | value    | eq       | string   | PayRefJWT |
  
  #Insert record in ms_reference_table
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |PayRefJWT |
  | description | string |Payment ref|
  
	#Delete existing record in Inbox & Outbox table
   And Delete Record in the table ms_outbox_events for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | WithoutJWTToken    | correlationId    | eq       | string   | 1a316d88-3c7-4-ad7e-1001 |
      
	And Delete Record in the table ms_inbox_events for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | WithoutJWTToken    | eventId    | eq       | string   | 1a316d88-3c7-4-ad7e-1001 |      

   #Send Command Event data without JWT Token as header to topic 
   When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/CreatePOBinaryIngesterWithoutJWT.json for Application PAYMENT_ORDER
   
   And set timeout session for 30 seconds
 
    #Check the entries in inbox for eventId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | WithoutJWTToken| eventId    | eq       | string   | 1a316d88-3c7-4-ad7e-1001 |
      
    #And Validate the below details from the db table ms_inbox_events
    And Validate the below details from the db table ms_inbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | WithoutJWTToken       | eventId    | 1a316d88-3c7-4-ad7e-1001 |
      | WithoutJWTToken       | eventType    | ms-paymentorder.CreateNewPaymentOrder |
      
    And Validate if the below columns contains values from the db table ms_inbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | WithoutJWTToken       | status         | FAILED   |
   
    And set timeout session for 30 seconds
    
    #Check for no entries in PO table 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | WithoutJWTToken| paymentOrderId    | eq       | string   | PO~101~102~USD~10 |
    
     And Validate if below details not present in db table ms_payment_order 
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | WithoutJWTToken    | paymentOrderId  | PO~101~102~USD~10 |
    
    And set timeout session for 30 seconds
 
    #Check the entries in outbox for correlationId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | WithoutJWTToken| correlationId    | eq       | string   | 1a316d88-3c7-4-ad7e-1001 |
      
    #And Validate the below details from the db table ms_outbox_events
    And Validate the below details from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | WithoutJWTToken       | correlationId    | 1a316d88-3c7-4-ad7e-1001 |
      | WithoutJWTToken       | eventType    | CommandFailed |
      
    And Validate if the below columns contains values from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |      
      | WithoutJWTToken       | status         | DELIVERED   |
      | WithoutJWTToken       | payload        | "status":401 |
      | WithoutJWTToken      | payload        | "failureMessages":[{"message":"Authorization failed","code":"MSF-003"}]|
           
  # Author: Sabapathy
  # MSF-2472
  
  Scenario: Business failure in Prehook
 
	#Delete existing record in ms_reference_table
	Given Set the test backgound for PAYMENT_ORDER API
  Given Set the Testcase id BusinessFailure for company GB0010001
  And Delete Record in the table ms_reference_data for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | BusinessFailure    | value    | eq       | string   | PrehookBusiness |
  
  #Insert record in ms_reference_table
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |PrehookBusiness |
  | description | string |Payment ref|
  
	#Delete existing record in Inbox & Outbox table
   And Delete Record in the table ms_outbox_events for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | BusinessFailure    | correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1001 |
      
	And Delete Record in the table ms_inbox_events for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | BusinessFailure    | eventId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1001 |      

   
   When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/CreatePOBinaryIngesterPrehookFailure.json for Application PAYMENT_ORDER
   
   And set timeout session for 30 seconds
 
    #Check the entries in inbox for eventId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| eventId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1001 |
      
    #And Validate the below details from the db table ms_inbox_events
    And Validate the below details from the db table ms_inbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | BusinessFailure       | eventId    | 9dc99a2c-c3ee-4393-8e58-c4ef920e1001 |
      | BusinessFailure       | eventType    | ms-paymentorder.CreateNewPaymentOrder |
      
    And Validate if the below columns contains values from the db table ms_inbox_events
      | TestCaseID            | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | FAILED   |
      | BusinessFailure       | payload        | "descriptions":["preHookBusinessFailure"]|
      
   
    And set timeout session for 30 seconds
    
    #Check for no entries in PO table 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | BusinessFailure| paymentOrderId    | eq       | string   | PO~1001~1002~USD~1000 |
    
     And Validate if below details not present in db table ms_payment_order 
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | BusinessFailure    | paymentOrderId  | PO~1001~1002~USD~1000 |
    
    And set timeout session for 30 seconds
 
    #Check the entries in outbox for correlationId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1001 |
      
    #And Validate the below details from the db table ms_outbox_events
    And Validate the below details from the db table ms_outbox_events
      | TestCaseID                           | ColumnName     | ColumnValue |
      | BusinessFailure       | correlationId    | 9dc99a2c-c3ee-4393-8e58-c4ef920e1001 |
      | BusinessFailure       | eventType    | CommandFailed |
      
    And Validate if the below columns contains values from the db table ms_outbox_events
     	| TestCaseID                           | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | DELIVERED   |
      | BusinessFailure       | payload        | "status":500 |
      | BusinessFailure      | payload        | "failureMessages":[{"message":"Uncaught Exception occurs while processing pre hook","code":"MSF-999"}]|
      
  Scenario: Business failure in Process
  
	#Delete existing record in ms_reference_table
	Given Set the test backgound for PAYMENT_ORDER API
  Given Set the Testcase id BusinessFailure for company GB0010001
  And Delete Record in the table ms_reference_data for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | BusinessFailure    | value    | eq       | string   | ProcessBusiness |
  
  #Insert record in ms_reference_table
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |ProcessBusiness |
  | description | string |Payment ref|
  
	#Delete existing record in Inbox & Outbox table
   And Delete Record in the table ms_outbox_events for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | BusinessFailure    | correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1002 |
      
	And Delete Record in the table ms_inbox_events for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | BusinessFailure    | eventId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1002 |      

   
   When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/CreatePOBinaryIngesterProcessFailure.json for Application PAYMENT_ORDER
   
   And set timeout session for 30 seconds
 
    #Check the entries in inbox for eventId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| eventId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1002 |
      
    #And Validate the below details from the db table ms_inbox_events
    And Validate the below details from the db table ms_inbox_events and check no of record is 1
      | TestCaseID                           | ColumnName     | ColumnValue |
      | BusinessFailure       | eventId    | 9dc99a2c-c3ee-4393-8e58-c4ef920e1002 |
      | BusinessFailure       | eventType    | ms-paymentorder.CreateNewPaymentOrder |
      
    And Validate if the below columns contains values from the db table ms_inbox_events
      | TestCaseID            | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | FAILED   |
      | BusinessFailure       | payload        | "descriptions":["processBusinessFailure"]|
      
   
    And set timeout session for 30 seconds
    
    #Check for no entries in PO table 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | BusinessFailure| paymentOrderId    | eq       | string   | PO~1001~1002~USD~1000 |
    
     And Validate if below details not present in db table ms_payment_order 
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | BusinessFailure    | paymentOrderId  | PO~1003~1004~USD~1000 |
    
    And set timeout session for 30 seconds
    
    #Following event types validated in outbox table - CommandFailed,Prehook,Posthook
 
    #1.Check the entries in outbox for correlationId & eventType "CommandFailed"
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1002  |
      | BusinessFailure| eventType    | eq       | string   | CommandFailed|

    And Validate the below details from the db table ms_outbox_events and check no of record is 1
      | TestCaseID            | ColumnName     | ColumnValue |
      | BusinessFailure| eventType    | CommandFailed |
    
   	And Validate if the below columns contains values from the db table ms_outbox_events
     	| TestCaseID                           | ColumnName     | ColumnValue |      
      | BusinessFailure       | payload         | "failureMessages":[{"message":"Business Failure error generated","code":"MSF-999"}]   |
      | BusinessFailure       | status         | DELIVERED  |
      
    #2.Check the entries in outbox for correlationId & eventType "PreHookEvent"
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1002  |
      | BusinessFailure| eventType    | eq       | string   | PreHookEvent |
    
    And Validate the below details from the db table ms_outbox_events and check no of record is 1
      | TestCaseID            | ColumnName     | ColumnValue |
      | BusinessFailure| eventType    | PreHookEvent |
    
   	And Validate if the below columns contains values from the db table ms_outbox_events
     	| TestCaseID                           | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | DELIVERED  | 
      
    #3.Check the entries in outbox for correlationId & eventType "PostHookEvent"
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1002  |
      | BusinessFailure| eventType    | eq       | string   | PostHookEvent |
    
    And Validate the below details from the db table ms_outbox_events and check no of record is 1
      | TestCaseID            | ColumnName     | ColumnValue |
      | BusinessFailure| eventType    | PostHookEvent |
    
   And Validate if the below columns contains values from the db table ms_outbox_events
     	| TestCaseID                           | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | DELIVERED  | 
         
  Scenario: Business failure in Posthook
  
	#Delete existing record in ms_reference_table
	Given Set the test backgound for PAYMENT_ORDER API
  Given Set the Testcase id BusinessFailure for company GB0010001
  And Delete Record in the table ms_reference_data for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | BusinessFailure    | value    | eq       | string   | PosthookBusiness |
  
  #Insert record in ms_reference_table
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |PosthookBusiness |
  | description | string |Payment ref|
  
	#Delete existing record in Inbox & Outbox table
   And Delete Record in the table ms_outbox_events for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | BusinessFailure    | correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1003 |
      
	And Delete Record in the table ms_inbox_events for the following criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue  |
      | BusinessFailure    | eventId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1003 |      

   
   When Send Data to Topic ms-paymentorder-inbox-topic from file avro/ingester/CreatePOBinaryIngesterPosthookFailure.json for Application PAYMENT_ORDER
   
   And set timeout session for 30 seconds
 
    #Check the entries in inbox for eventId
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| eventId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1003 |
      
    #And Validate the below details from the db table ms_inbox_events
    And Validate the below details from the db table ms_inbox_events and check no of record is 1
      | TestCaseID                           | ColumnName     | ColumnValue |
      | BusinessFailure       | eventId    | 9dc99a2c-c3ee-4393-8e58-c4ef920e1003 |
      | BusinessFailure       | eventType    | ms-paymentorder.CreateNewPaymentOrder |
      
    And Validate if the below columns contains values from the db table ms_inbox_events
      | TestCaseID            | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | PROCESSED   |
      | BusinessFailure       | payload        | "descriptions":["postHookBusinessFailure"]|
      
   
    And set timeout session for 30 seconds
    
    #Check for no entries in PO table 
    Then Set the following data criteria
      | TestCaseID                    | ColumnName        | Operator | DataType | ColumnValue          |
      | BusinessFailure| paymentOrderId    | eq       | string   | PO~1005~1006~USD~1000 |
	  
    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID                        | ColumnName      | ColumnValue          |
      | BusinessFailure    | paymentOrderId  | PO~1005~1006~USD~1000 |
 
    And set timeout session for 30 seconds
    
 		#Following event types validated in outbox table - CommandProcessed,UpdatePaymentOrder,POAccepted,Prehook,Posthook
 		
    #1.Check for no entries in outbox for correlationId & eventType as Posthook
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1003  |
      | BusinessFailure| eventType    | eq       | string   | PostHookEvent |
      
		And Validate if below details not present in db table ms_outbox_events
      | TestCaseID            | ColumnName     | ColumnValue |
      | BusinessFailure| eventType    | PostHookEvent |
      
   #2.Check the entries in outbox for correlationId & eventType "CommandProcessed"
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1003  |
      | BusinessFailure| eventType    | eq       | string   | CommandProcessed|

    And Validate the below details from the db table ms_outbox_events and check no of record is 1
      | TestCaseID            | ColumnName     | ColumnValue |
      | BusinessFailure| eventType    | CommandProcessed |
    
   	And Validate if the below columns contains values from the db table ms_outbox_events
     	| TestCaseID                           | ColumnName     | ColumnValue |      
      | BusinessFailure       | payload         | "status":200   |
      | BusinessFailure       | status         | DELIVERED  |
      
   #3.Check the entries in outbox for correlationId & eventType "ms-paymentorder.UpdatePaymentOrder"
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1003  |
      | BusinessFailure| eventType    | eq       | string   | ms-paymentorder.UpdatePaymentOrder |
    
    And Validate the below details from the db table ms_outbox_events and check no of record is 1
      | TestCaseID            | ColumnName     | ColumnValue |
      | BusinessFailure| eventType    | ms-paymentorder.UpdatePaymentOrder |
    
   	And Validate if the below columns contains values from the db table ms_outbox_events
     	| TestCaseID                           | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | DELIVERED  | 
      
   #4.Check the entries in outbox for correlationId & eventType "POAccepted"
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1003  |
      | BusinessFailure| eventType    | eq       | string   | POAccepted |
    
    And Validate the below details from the db table ms_outbox_events and check no of record is 1
      | TestCaseID            | ColumnName     | ColumnValue |
      | BusinessFailure| eventType    | POAccepted |
    
   	And Validate if the below columns contains values from the db table ms_outbox_events
     	| TestCaseID                           | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | DELIVERED  |
   
   #5.Check the entries in outbox for correlationId & eventType "PreHookEvent"
    Then Set the following data criteria 
      | TestCaseID                    | ColumnName       | Operator | DataType | ColumnValue |
      | BusinessFailure| correlationId    | eq       | string   | 9dc99a2c-c3ee-4393-8e58-c4ef920e1003  |
      | BusinessFailure| eventType    | eq       | string   | PreHookEvent |
    
    And Validate the below details from the db table ms_outbox_events and check no of record is 1
      | TestCaseID            | ColumnName     | ColumnValue |
      | BusinessFailure| eventType    | PreHookEvent |
    
   	And Validate if the below columns contains values from the db table ms_outbox_events
     	| TestCaseID                           | ColumnName     | ColumnValue |      
      | BusinessFailure       | status         | DELIVERED  | 
     
      
      
   
      
    

     
      


      
      
      