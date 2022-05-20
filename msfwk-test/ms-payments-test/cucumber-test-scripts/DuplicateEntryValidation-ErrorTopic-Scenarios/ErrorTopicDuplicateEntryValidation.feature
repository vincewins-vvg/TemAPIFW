#Mukila
Feature: ErrorTopicDuplicateEntryValidation

Scenario: Send Error Data to valid topic and validate Error topic data_1

#preconfig
Given Set the test backgound for PAYMENT_ORDER API
Given Set the Testcase id MS-Test-PO-Error-001 for company GB0010001
#to send error data to valid topic
When send JSON data to topic ms-paymentorder-inbox-topic from file cucumber-json-payload/SequenceCompleted1.json for Application PaymentOrder

#And set timeout session for 30 seconds
And set timeout session for 30 seconds

#validating error topic data record duplication for 1st entry
Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error1 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Scenario: Send Error Data to valid topic and validate Error topic data_2

#preconfig
Given Set the test backgound for PAYMENT_ORDER API
Given Set the Testcase id MS-Test-PO-Error-002 for company GB0010001
#to send error data to valid topic
When send JSON data to topic ms-paymentorder-inbox-topic from file cucumber-json-payload/SequenceCompleted2.json for Application PaymentOrder
#And set timeout session for 30 seconds
And set timeout session for 30 seconds

#validating error topic data record duplication for 1st & 2nd entry
Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error1 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error2 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1


Scenario: Send Error Data to valid topic and validate Error topic data_3


#preconfig
Given Set the test backgound for PAYMENT_ORDER API
Given Set the Testcase id MS-Test-PO-Error-003 for company GB0010001
#to send error data to valid topic
When send JSON data to topic ms-paymentorder-inbox-topic from file cucumber-json-payload/SequenceCompleted3.json for Application PaymentOrder
#And set timeout session for 30 seconds
And set timeout session for 30 seconds

#validating error topic data record duplication for 1st,2nd & 3rd entry
Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error1 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error2 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error3 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1


Scenario: Send Error Data to valid topic and validate Error topic data_4

#preconfig
Given Set the test backgound for PAYMENT_ORDER API
Given Set the Testcase id MS-Test-PO-Error-004 for company GB0010001
#to send error data to valid topic
When send JSON data to topic ms-paymentorder-inbox-topic from file cucumber-json-payload/SequenceCompleted4.json for Application PaymentOrder
#And set timeout session for 30 seconds
And set timeout session for 30 seconds

#validating error topic data record duplication for 1-4 entries entry
Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error1 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error2 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error3 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error4 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1


Scenario: Send Error Data to valid topic and validate Error topic data_5

#preconfig
Given Set the test backgound for PAYMENT_ORDER API
Given Set the Testcase id MS-Test-PO-Error-005 for company GB0010001
#to send error data to valid topic
When send JSON data to topic ms-paymentorder-inbox-topic from file cucumber-json-payload/SequenceCompleted5.json for Application PaymentOrder
#And set timeout session for 30 seconds
And set timeout session for 30 seconds



#validating error topic data record duplication for 1-5 entries entry
Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error1 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error2 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error3 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error4 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error5 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1


Scenario: Send Valid Data to valid topic and validate both error and valid topics
#preconfig
Given Set the test backgound for PAYMENT_ORDER API
Given Set the Testcase id MS-Test-PO-Error-001 for company GB0010001
#to send valid data to valid topic
When send JSON data to topic ms-paymentorder-inbox-topic from file cucumber-json-payload/CreateNewPaymentOrder1.json for Application PaymentOrder
#And set timeout session for 30 seconds
And set timeout session for 30 seconds

#validating inbox valid topic for data record
Then check if json data with event id 9dc99a2c-c3ee-4393-8e58-c4ef920ef0005-valid1 and type ms-paymentorder.CreateNewPaymentOrder is present in topic ms-paymentorder-inbox-topic

#validating error topic data record duplication for 1-5 entries entry
Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error1 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error2 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error3 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error4 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error5 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

#checking valid data record not to present in inbox error topic
Then check if json data with event id 9dc99a2c-c3ee-4393-8e58-c4ef920ef0005-valid1 and type ms-paymentorder.CreateNewPaymentOrder is not present in topic ms-paymentorder-inbox-error-topic



Scenario: Send Error Data to valid inbox topic followed by valid data entry in inbox topic

#preconfig
Given Set the test backgound for PAYMENT_ORDER API
Given Set the Testcase id MS-Test-PO-Error-001 for company GB0010001
#to send error data to valid topic
When send JSON data to topic ms-paymentorder-inbox-topic from file cucumber-json-payload/SequenceCompleted6.json for Application PaymentOrder
#And set timeout session for 30 seconds
And set timeout session for 30 seconds

#validating error topic data record duplication for 1-6 entries entry
Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error1 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error2 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error3 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error4 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error5 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1

Then check if json data with event id 148313a7-ff3a-45d3-b34b-169adbd61161-error6 and type ms-paymentorder.CreateNewPaymentOrder.SequenceCompleted is present in topic ms-paymentorder-inbox-error-topic with count should be equal to 1
