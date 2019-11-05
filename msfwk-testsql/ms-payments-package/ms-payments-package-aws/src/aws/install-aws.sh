#!/bin/bash -x

# Setup the environment
export PATH=/opt/apache-maven-3.3.9/bin:/usr/bin:/usr/sbin:/usr/local/bin:$PATH
export MAVEN_OPTS="-Xmx2048m"

# Create Dynamo DB Tables
aws dynamodb create-table --table-name ms_marketing_catalog_productinformation --attribute-definitions AttributeName=productId,AttributeType=S AttributeName=currencyId,AttributeType=S,AttributeType=S AttributeName=productGroupId,AttributeType=S,AttributeType=S AttributeName=productLineId,AttributeType=S --key-schema AttributeName=productId,KeyType=HASH AttributeName=currencyId,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=1 --global-secondary-indexes IndexName=productGroupId,KeySchema=["{AttributeName=productGroupId,KeyType=HASH}"],Projection="{ProjectionType=INCLUDE ,NonKeyAttributes=["key"]}",ProvisionedThroughput="{ReadCapacityUnits=10,WriteCapacityUnits=10}" IndexName=productLineId,KeySchema=["{AttributeName=productLineId,KeyType=HASH}"],Projection="{ProjectionType=INCLUDE ,NonKeyAttributes=["key"]}",ProvisionedThroughput="{ReadCapacityUnits=10,WriteCapacityUnits=10}"
sleep 10
aws dynamodb create-table --table-name ms_marketing_catalog_marketinginformation --attribute-definitions AttributeName=productId,AttributeType=S AttributeName=currencyId,AttributeType=S --key-schema AttributeName=productId,KeyType=HASH AttributeName=currencyId,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=1
sleep 10

# Create Stream table-update-marketingcatalog for testing
aws kinesis create-stream --stream-name table-update-marketingcatalog --shard-count 1
sleep 10
aws kinesis create-stream --stream-name error-marketingcatalog --shard-count 1
sleep 10

# Before installing functions, get the fileName of the jar from /app
export serviceFileName=$(ls app)

# Install Ingester
#To-Do

# Install marketingcatalog API functions
aws lambda create-function --function-name marketingcatalog-productline-forcurrency --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.marketingcatalog.function.GetProductsInProductLineForCurrencyFunctionAWS::invoke --description "API to get products in product-line for currency" --timeout 120 --memory-size 256 --publish --tags FunctionType=API,Service=Marketingcatalog --zip-file fileb://app/${serviceFileName} --environment Variables=\{DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,className_getProductsInProductLineForCurrency=com.temenos.microservice.marketingcatalog.function.GetProductsInProductLineForCurrencyImpl\}
sleep 10
aws lambda create-function --function-name marketingcatalog-productgroup-forcurrency --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.marketingcatalog.function.GetProductsInProductGroupForCurrencyFunctionAWS::invoke --description "API to get products in product-group for currency" --timeout 120 --memory-size 256 --publish --tags FunctionType=API,Service=Marketingcatalog --zip-file fileb://app/${serviceFileName} --environment Variables=\{DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,className_getProductsInProductGroupForCurrency=com.temenos.microservice.marketingcatalog.function.GetProductsInProductGroupForCurrencyImpl\}
sleep 10
aws lambda create-function --function-name marketingcatalog-productline --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.marketingcatalog.function.GetProductsInProductLineFunctionAWS::invoke --description "API to get products in product-line" --timeout 120 --memory-size 256 --publish --tags FunctionType=API,Service=Marketingcatalog --zip-file fileb://app/${serviceFileName} --environment Variables=\{DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,className_getProductsInProductLine=com.temenos.microservice.marketingcatalog.function.GetProductsInProductLineImpl\}
sleep 10
aws lambda create-function --function-name marketingcatalog-productgroup --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.marketingcatalog.function.GetProductsInProductGroupFunctionAWS::invoke --description "API to get products in product-group" --timeout 120 --memory-size 256 --publish --tags FunctionType=API,Service=Marketingcatalog --zip-file fileb://app/${serviceFileName} --environment Variables=\{DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,className_getProductsInProductGroup=com.temenos.microservice.marketingcatalog.function.GetProductsInProductGroupImpl\}
sleep 10
aws lambda create-function --function-name marketingcatalog-product --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.marketingcatalog.function.GetProductFunctionAWS::invoke --description "API to get products for currency" --timeout 120 --memory-size 256 --publish --tags FunctionType=API,Service=Marketingcatalog --zip-file fileb://app/${serviceFileName} --environment Variables=\{DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,className_getProduct=com.temenos.microservice.marketingcatalog.function.GetProductImpl\}
sleep 10

# Create REST API
export restAPIId=$(aws apigateway create-rest-api --name ms-marketingcatalog-api --description "Marketingcatalog API" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Get root resource id for all other resources
export apiRootResourcetId=$(aws apigateway get-resources --rest-api-id $restAPIId | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["items"][-1]["id"]')



# Create version resource and get id
export versionResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $apiRootResourcetId --path-part "v1.0.0" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')



# Create productLines resource and get id
export productLinesResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "productLines" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Create productLineId resource and get id.  Create access method i.e. GET and link it with the function installed above
export productLineIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $productLinesResourceId --path-part "{productLineId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
aws apigateway put-method --rest-api-id $restAPIId --resource-id $productLineIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $productLineIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:marketingcatalog-productline/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# Create currencies resource and get Id
export productLineCurrenciesResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $productLineIdResourceId --path-part "currencies" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Create currencyId resource and get id.  Create access method i.e. GET and link it with the function installed above
export productLineCurrencyIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $productLineCurrenciesResourceId --path-part "{currencyId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
aws apigateway put-method --rest-api-id $restAPIId --resource-id $productLineCurrencyIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $productLineCurrencyIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:marketingcatalog-productline-forcurrency/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT



# Create productGroups resource and get id
export productGroupsResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "productGroups" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Create productGroupId resource and get id.  Create access method i.e. GET and link it with the function installed above
export productGroupIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $productGroupsResourceId --path-part "{productGroupId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
aws apigateway put-method --rest-api-id $restAPIId --resource-id $productGroupIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $productGroupIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:marketingcatalog-productgroup/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# Create currencies resource and get Id
export productGroupCurrenciesResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $productGroupIdResourceId --path-part "currencies" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Create currencyId resource and get id.  Create access method i.e. GET and link it with the function installed above
export productGroupCurrencyIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $productGroupCurrenciesResourceId --path-part "{currencyId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
aws apigateway put-method --rest-api-id $restAPIId --resource-id $productGroupCurrencyIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $productGroupCurrencyIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:marketingcatalog-productgroup-forcurrency/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT



# Create product resource and get id
export productResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "product" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Create productId resource and get id
export productIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $productResourceId --path-part "{productId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Create currencies resource and get Id
export productCurrenciesResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $productIdResourceId --path-part "currencies" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Create currencyId resource and get id.  Create access method i.e. GET and link it with the function installed above
export productCurrencyIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $productCurrenciesResourceId --path-part "{currencyId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
aws apigateway put-method --rest-api-id $restAPIId --resource-id $productCurrencyIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $productCurrencyIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:marketingcatalog-product/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT



# To publish API so that we can access, create deployment and get id
export deploymentId=$(aws apigateway create-deployment --rest-api-id $restAPIId --stage-name test-primary --stage-description "Marketingcatalog Test Primary" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Create API Key
export apiKeyId=$(aws apigateway create-api-key --name ms-marketingcatalog-apikey --description "Marketingcatalog api key" --enabled | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
export apiKeyValue=$(aws apigateway get-api-key --api-key $apiKeyId --include-value | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["value"]')
export API_KEY=$apiKeyValue

# Create usage plan and get Id
export usagePlanId=$(aws apigateway create-usage-plan --name ms-marketingcatalog-usageplan --api-stages apiId=$restAPIId,stage=test-primary | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
# Now map the usage plan with the key
aws apigateway create-usage-plan-key --usage-plan-id $usagePlanId --key-id $apiKeyId --key-type API_KEY

# Finally set the URL for integration test to invoke
export API_BASE_URL=https://${restAPIId}.execute-api.eu-west-2.amazonaws.com/test-primary
