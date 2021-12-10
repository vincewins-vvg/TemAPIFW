#Author: Sabapathy
#JIRA-ID MFW-936
Feature: Error Message column with max size(1024)
 
  Scenario: To validate error table with error message of max char
    Given enter the tablename ms_error
  	And enter data for table
  	| Fields   | type | data|
  	| errorEventId | string |1002|
  	| dataEventId | string |2001|
  	| errorMessage | string |{"eventId":"U000049_d7b3d688-04fd-4ee9-ae99-4fd20646f09f000pe_0002","eventSize":1,"eventIndex":0,"emittedTime":1624431844800,"processingTime":1624431843748,"company":{"string":"FBNK"},"context":null,"entityName":{"string":"FBNK.PAYMENT.ORDER"},"entityId":{"string":"PI21105123MRJXPW"},"application":{"string":"PAYMENT.ORDER"},"payload":{"recId":{"string":"PI21105123MRJXPW"},"Id":null,"PaymentOrderProduct":{"string":"ACCLM"},"OrderingCompany":{"string":"GB0010001"},"OrderingCustomer":{"string":"100100"},"OrderingCustomerBic":null,"OrderingCustName":{"string":"Harry Crisp Harry Crisp"},"OrderingPostAddressType":null,"ARRAY_OrderingPostSwiftAddr":[{"OrderingPostSwiftAddr":{"string":"United States of America"}}],"ARRAY_OrderingPostAddrLine":[{"OrderingPostAddrLine":{"string":"1000 - 2nd Ave"}},{"OrderingPostAddrLine":{"string":"Seattle"}},{"OrderingPostAddrLine":{"string":"98104-1049"}},{"OrderingPostAddrLine":{"string":"Suite 2200"}}],"OrderingPortfolio":null,"DebitAccount":{"string"},"OrderingPortfolio":null,null|
  	| errorSourceTopic | string |topic|
  	| lastProcessedTime | string |2021-09-02 13:25:56.828|
  	| payload | string |25443020C706179696E6702023100|
  	| status | string |UNPROCESSED|
  	And MS request URI is "v1.0.0/system/ingester/errorDetail/services"
    And MS query parameter for Azure env is set to value "status=UNPROCESSED"
    And MS request header "Authorization" is set with jwt token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMjkwMDA4NjQ3MzI4OSIsInJvbGVJZCI6IkJhbGFuY2VWaWV3ZXIiLCJpYXQiOjE1ODk1OTMxNDAsImV4cCI6MzYyMTEyOTE0Mn0.YYalWJ7qoWwZnDD2MB5zgtCwK3DgnVwcBBfeeKX7DBVIpilCNLslyNWRO895LJsP6n-eC_RdeuPkyauG400mG35SweW35oJRqH8jsgoFI4lPLDK-xjC18rZ-ibjv_irJNv97siCfoUjhLZbG64klYCJki4eFTaZEZIiXMPYhaW2nW-xReuyDdDQ7tOaj_9Cg-cOoTjfRprZYqkgqEHx20xOu-i-37xVQUhMj9prLQAZPs7Kvxn-aASpPLUtd7eYQW30fByq4PMUSM1_524yfXMLzZV-VHHYuMK8pb1xSLdizvn9QcbbDDuvSNPyLpTGhoBbFgZ9_geGjFIky6yjVzw"
    When a "GET" request is sent to MS
    And log all MS response in console
    Then MS response code should be 200