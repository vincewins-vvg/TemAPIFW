
 Feature: EventIngester    

 Scenario Outline: Send Data to topic for an existing Payment Order
  

  #To insert the Payment reference details into the DB for testing purpose
  Given enter the tablename ms_reference_data
  And enter data for table
  | Fields   | type | data|
  | type | string |paymentref|
  | value | string |payeven|
  | description | string |Payment ref|
  
        
    Given Set the test backgound for PAYMENT_ORDER API
    And Set the Testcase id MS-Test-PO-EventIngester-001 for company GB0010001
    Given create a new MS request with code using Restassured arguments ""
    And MS request URI is "payments/orders"
    And MS query parameter for Azure env is set to value ""
    And MS request header "roleId" is set to "[ADMIN,BANKER]"
    And MS request header "Content-Type" is set to "application/json"
    And post the static MS JSON as payload <payload>
    When a "POST" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200

    When Send Data to Topic paymentorder-event-topic from file avro/ingester/CreatePOEventIngester.json for Application PAYMENT_ORDER
   
    And set timeout session for 30 seconds

    Then Set the following data criteria
      | TestCaseID                      | ColumnName        | Operator | DataType | ColumnValue |
      | MS-Test-PO-EventIngester-001    | paymentOrderId    | eq       | string   | PO~100-CBE~232-EVEN~INR~125 |

    
    And Validate the below details from the db table ms_payment_order and check no of record is 1
      | TestCaseID                      | ColumnName      | ColumnValue |
      | MS-Test-PO-EventIngester-001    | paymentOrderId  | PO~100-CBE~232-EVEN~INR~125 |  
    
    And set timeout session for 30 seconds
    
    #Check the entries in Inbox
    Then Set the following data criteria
      | TestCaseID                    | ColumnName | Operator | DataType | ColumnValue |
      | MS-Test-PO-EventIngester-001  | eventId    | eq       | string   | 6f7cd466-2dea-45ac-999b-c61eb54ae81d11 |
      | MS-Test-PO-EventIngester-001  | eventType  | eq       | string   | ms-paymentorder.CreatePayment.SequenceCompleted |

    And Validate the below details from the db table ms_inbox_events and check no of record is 1    
      | TestCaseID                   | ColumnName | ColumnValue |
      | MS-Test-PO-EventIngester-001 | eventid    | 6f7cd466-2dea-45ac-999b-c61eb54ae81d11 |
      

    #Check the entries in outbox

      #
    #Then Set the following data criteria
      #| TestCaseID                         | ColumnName       | Operator | DataType | ColumnValue |
      #| MS-Test-PO-EventIngester-001       | correlationid    | eq       | string   | 6f7cd466-2dea-45ac-999b-c61eb54ae81d11 |
      #| MS-Test-PO-EventIngester-001       | eventtype        | eq      | string    | CommandProcessed |
      #
    #And Validate the below details from the db table ms_outbox_events
      #| TestCaseID                         | ColumnName    | ColumnValue |
      #| MS-Test-PO-EventIngester-001       | correlationid | 6f7cd466-2dea-45ac-999b-c61eb54ae81d11 |
      #| MS-Test-PO-EventIngester-001       | eventtype     | CommandProcessed |
      #| MS-Test-PO-EventIngester-001       | status        | DELIVERED |  
      
    Examples:
    
    |payload|
    |{"fromAccount":"100-CBE","toAccount":"232-EVEN","paymentReference":"payeven","paymentDetails":"Success","currency":"INR","amount":125,"expires":10,"fileContent":"test","paymentDate":"2024-05-05","paymentMethod":{"id":100100,"name":"HDFC","card":{"cardid":723,"cardname":"Diners","cardlimit":120000.11}},"exchangeRates":[{"id":30,"name":"USD","value":78.12}],"payeeDetails":{"payeeName":"MSTester","payeeType":"temp"},"descriptions":["Tester"]}|
    
    