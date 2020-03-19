#Author: sabapathy

# Script being common for both SQL & NOSQL 

Feature: ToGetHealthCheckStatus


  #Below scripts cover the default status of API services - DB,ClientAPI,BusinessCondition
  
	 Scenario: To Get Health Check Status of API 

   Given create a new MS request with code ""
   And set the request path as "/healthz"
   And query parameter will be set to value ""

	 When a 'GET' request is sent
   Then the response code should be 200
   And property "status" should be equal to string "FAILURE"
   And property "clientAPIHealthChecks(0)/status" should be equal to string "FAILURE"
   And property "databaseHealthChecks(0)/status" should be equal to string "SUCCESS"
   
   #As business condition's status being SUCCESS for SQL & FAILURE for of NOSQL
   # And property "businessConditionHealthChecks(0)/status" should be equal to string "FAILURE"
   
   #Below scripts cover the default status of Ingester services - DB,Stream
    
	 Scenario: To Get Health Check Status of Data Ingester
	 
	 Given create a new request
   And end-point uri is set to "http://localhost:8082"
   And set the request path as "ingester/health"
   And query parameter will be set to value ""

	 When a 'GET' request is sent
   Then the response code should be 200
   And property "status" should be equal to string "SUCCESS"
   

	 #Scenario: To Get Health Check Status of Binary Ingester

   #Given create a new request
   #And end-point uri is set to "http://localhost:8086"
   #And set the request path as "ingester/health"
   #And query parameter will be set to value ""

	 #When a 'GET' request is sent
   #Then the response code should be 200
   #And property "status" should be equal to string "SUCCESS"

   
   
   
   

   
   
   
