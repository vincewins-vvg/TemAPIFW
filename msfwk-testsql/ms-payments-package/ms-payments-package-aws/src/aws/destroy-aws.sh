#!/bin/bash -x

# Setup the environment
export PATH=/opt/apache-maven-3.3.9/bin:/usr/bin:/usr/sbin:/usr/local/bin:$PATH
export MAVEN_OPTS="-Xmx2048m"

# Delete Dynamo DB Tables
aws dynamodb delete-table --table-name ms_marketing_catalog_productinformation
aws dynamodb delete-table --table-name ms_marketing_catalog_marketinginformation

# Dekete Stream table-update-marketingcatalog
aws kinesis delete-stream --stream-name table-update-marketingcatalog
aws kinesis delete-stream --stream-name error-marketingcatalog

# Delete Ingester
#To-Do

# Delete marketingcatalog API functions
aws lambda delete-function --function-name marketingcatalog-productline-forcurrency
aws lambda delete-function --function-name marketingcatalog-productgroup-forcurrency
aws lambda delete-function --function-name marketingcatalog-productline
aws lambda delete-function --function-name marketingcatalog-productline
aws lambda delete-function --function-name marketingcatalog-product

# Delete REST API
export restAPIId=$(aws apigateway get-rest-apis | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["items"] if "ms-marketingcatalog-api" == api["name"]]; print filter[0]["id"]')
aws apigateway delete-rest-api --rest-api-id $restAPIId

# Delete API Key
export apiKeyId=$(aws apigateway get-api-keys | python -c 'import json,sys;keys=json.load(sys.stdin); filter=[key for key in keys["items"] if "ms-marketingcatalog-apikey" == key["name"]]; print filter[0]["id"]')
aws apigateway delete-api-key --api-key $apiKeyId

# Create usage plan and get Id
export usagePlanId=$(aws apigateway get-usage-plans | python -c 'import json,sys; usagePlans=json.load(sys.stdin); filter=[plan for plan in usagePlans["items"] if "ms-marketingcatalog-usageplan" == plan["name"]]; print filter[0]["id"]')
aws apigateway delete-usage-plan --usage-plan-id $usagePlanId