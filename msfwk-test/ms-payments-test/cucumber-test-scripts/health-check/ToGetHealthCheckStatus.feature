#Author: sabapathy

# Script being common for both SQL & NOSQL 

Feature: ToGetHealthCheckStatus


  #Below scripts cover the default status of API services - DB,External API,BusinessCondition
  
	 Scenario: To Get Health Check Status of API 

   Given create a new MS request with code ""
   And set the request path as "v1.0.0/health"
   And query parameter will be set to value ""

	 When a 'GET' request is sent
   Then the response code should be 409
   And property "status" should be equal to string "FAILURE"
   #And property "externalAPI(0)/status" should be equal to string "SUCCESS"
   And property "database(0)/status" should be equal to string "SUCCESS"
   And property "businessCondition(0)/status" should be equal to string "SUCCESS"
   
   #Below scripts cover the default status of Ingester services - DB,External API,Stream
    
	 #Scenario: To Get Health Check Status of Data Ingester
	 
	 #Given create a new request
   #And end-point uri is set to "http://localhost:8082"
   #And set the request path as "ingester/v1.0.0/health"
   #And query parameter will be set to value ""

	 #When a 'GET' request is sent
   #Then the response code should be 409
   #And property "status" should be equal to string "FAILURE"
   

	 #Scenario: To Get Health Check Status of Binary Ingester

   #Given create a new request
   #And end-point uri is set to "http://localhost:8084"
   #And set the request path as "ingester/v1.0.0/health"
   #And query parameter will be set to value ""

	 #When a 'GET' request is sent
   #Then the response code should be 409
   #And property "status" should be equal to string "FAILURE"