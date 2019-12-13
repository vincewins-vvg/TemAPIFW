#!/bin/bash -x

# Setup the environment
export PATH=/opt/apache-maven-3.3.9/bin:/usr/bin:/usr/sbin:/usr/local/bin:$PATH
export MAVEN_OPTS="-Xmx2048m"


# Delete DB Instance
aws rds delete-db-instance --db-instance-identifier PaymentOrderInstance --skip-final-snapshot
sleep 400


# Delete DB Cluster
aws rds delete-db-cluster --db-cluster-identifier PaymentOrderCluster --skip-final-snapshot
sleep 400


# Delete DB parameter group
aws rds delete-db-cluster-parameter-group --db-cluster-parameter-group-name PaymentOrderPG


# Delete S3 bucket
aws s3 rb s3://ms-payment-order-sql --force


# Delete Stream table-update-marketingcatalog
aws kinesis delete-stream --stream-name payment-inbox-topic
aws kinesis delete-stream --stream-name payment-inbox-error-topic
aws kinesis delete-stream --stream-name payment-outbox-topic


# Delete Ingester
aws lambda delete-function --function-name payment-sql-inbox-ingester
aws lambda delete-function --function-name inbox-sql-handler
aws lambda delete-function --function-name outbox-sql-handler


# Delete payments API functions
aws lambda delete-function --function-name payment-sql-create


# Delete REST API
export restAPIId=$(aws apigateway get-rest-apis | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["items"] if "ms-payment-order-sql-api" == api["name"]]; print filter[0]["id"]')
aws apigateway delete-rest-api --rest-api-id $restAPIId

# Delete API Key
export apiKeyId=$(aws apigateway get-api-keys | python -c 'import json,sys;keys=json.load(sys.stdin); filter=[key for key in keys["items"] if "ms-payment-order-sql-apikey" == key["name"]]; print filter[0]["id"]')
aws apigateway delete-api-key --api-key $apiKeyId

# Create usage plan and get Id
export usagePlanId=$(aws apigateway get-usage-plans | python -c 'import json,sys; usagePlans=json.load(sys.stdin); filter=[plan for plan in usagePlans["items"] if "ms-payment-order-sql-usageplan" == plan["name"]]; print filter[0]["id"]')
aws apigateway delete-usage-plan --usage-plan-id $usagePlanId