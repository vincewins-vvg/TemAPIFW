#Author: Sabapathy

Feature: ToGetHealthCheckStatus


  #Below scripts cover the default status of API services - DB,External API,BusinessCondition
  
	Scenario: To Get Health Check Status of API 

   Given create a new MS request with code ""
   And set the request path as "v1.0.0/health/api"
   And query parameter will be set to value ""
   And set request header key "Authorization" with value "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMTkwMDA2MjU4ODQiLCJyb2xlSWQiOiJCYWxhbmNlVmlld2VyIiwiaWF0IjoxNTg5NTkzMTQwLCJleHAiOjE2MjExMjkxNDJ9.KiZCAFf6Iien5ZJE70fhGweJZ6ErmLqaKyz40lZnjVChmzSaFW3z7IUfqdt8370PNufLf_S79C8b0MgNJo1NHtTojhjUSGGtHFn98WTb8s7DJmLtAAnGAwm-RHWzRvhJVVBZO1VbbwA4-QJhBK30OjOxiJg1ujTpZrtOIqhZiFCjgWB9jmfg74iLou5nylVKo8YGR7ZANrVO_qxW5LhLuOfuGY7HKQ5iGUDjAeI_U7XZU7-edmM9UZFlvkaAyAE672G388KK3NCcfFqWfgJ10hqrGUw9xHlZ4tSy3C7JousiMsM_jPNFCQ2p3thirPUn6cPCojokvqxaterPiNFlwA"

   When a 'GET' request is sent
   Then the response code should be 409
   And property "status" should be equal to string "FAILURE"
  
   
   #Below scripts cover the default status of Ingester services - DB,External API,Stream
    
	 Scenario: To Get Health Check Status of Data Ingester
	 
	Given create a new request
   #And end-point uri is set to "http://localhost:8082"
   And server URL set to "http://localhost:" with data ingester port
   And set the request path as "ingester/v1.0.0/health/ingester"
   And query parameter will be set to value ""
   And set request header key "Authorization" with value "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMTkwMDA2MjU4ODQiLCJyb2xlSWQiOiJCYWxhbmNlVmlld2VyIiwiaWF0IjoxNTg5NTkzMTQwLCJleHAiOjE2MjExMjkxNDJ9.KiZCAFf6Iien5ZJE70fhGweJZ6ErmLqaKyz40lZnjVChmzSaFW3z7IUfqdt8370PNufLf_S79C8b0MgNJo1NHtTojhjUSGGtHFn98WTb8s7DJmLtAAnGAwm-RHWzRvhJVVBZO1VbbwA4-QJhBK30OjOxiJg1ujTpZrtOIqhZiFCjgWB9jmfg74iLou5nylVKo8YGR7ZANrVO_qxW5LhLuOfuGY7HKQ5iGUDjAeI_U7XZU7-edmM9UZFlvkaAyAE672G388KK3NCcfFqWfgJ10hqrGUw9xHlZ4tSy3C7JousiMsM_jPNFCQ2p3thirPUn6cPCojokvqxaterPiNFlwA"

	 When a 'GET' request is sent
   Then the response code should be 409
   And property "status" should be equal to string "FAILURE"
  
   

	 Scenario: To Get Health Check Status of Binary Ingester
	 
	 Given create a new request
   #And end-point uri is set to "http://localhost:8084"
   And server URL set to "http://localhost:" with binary ingester port
   And set the request path as "ingester/v1.0.0/health/ingester"
   And query parameter will be set to value ""
   And set request header key "Authorization" with value "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJob2xkaW5ncyIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwic3ViIjoiMTkwMDA2MjU4ODQiLCJyb2xlSWQiOiJCYWxhbmNlVmlld2VyIiwiaWF0IjoxNTg5NTkzMTQwLCJleHAiOjE2MjExMjkxNDJ9.KiZCAFf6Iien5ZJE70fhGweJZ6ErmLqaKyz40lZnjVChmzSaFW3z7IUfqdt8370PNufLf_S79C8b0MgNJo1NHtTojhjUSGGtHFn98WTb8s7DJmLtAAnGAwm-RHWzRvhJVVBZO1VbbwA4-QJhBK30OjOxiJg1ujTpZrtOIqhZiFCjgWB9jmfg74iLou5nylVKo8YGR7ZANrVO_qxW5LhLuOfuGY7HKQ5iGUDjAeI_U7XZU7-edmM9UZFlvkaAyAE672G388KK3NCcfFqWfgJ10hqrGUw9xHlZ4tSy3C7JousiMsM_jPNFCQ2p3thirPUn6cPCojokvqxaterPiNFlwA"

	 When a 'GET' request is sent
   Then the response code should be 409
   And property "status" should be equal to string "FAILURE"
   