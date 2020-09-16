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

#Delete scheduler
aws events remove-targets --rule ms-payments-scheduler-rule --ids "paymentscheduler"
aws events delete-rule --name ms-payments-scheduler-rule
aws lambda delete-function --function-name paymentscheduler

# Delete Stream table-update-marketingcatalog
aws kinesis delete-stream --stream-name payment-inbox-topic
aws kinesis delete-stream --stream-name payment-inbox-error-topic
aws kinesis delete-stream --stream-name payment-outbox-topic
aws kinesis delete-stream --stream-name table-update-paymentorder
aws kinesis delete-stream --stream-name error-paymentorder

# Delete Ingester
aws lambda delete-function --function-name payment-sql-inbox-ingester
aws lambda delete-function --function-name outbox-sql-handler
aws lambda delete-function --function-name payment-sql-configavro-ingester
aws lambda delete-function --function-name create-reference-api-handler
aws lambda delete-function --function-name get-reference-api-handler
aws lambda delete-function --function-name create-reference-value-api-handler
aws lambda delete-function --function-name update-reference-api-handler
aws lambda delete-function --function-name delete-reference-api-handler
aws lambda delete-function --function-name payment-sql-validation



# Delete payments API functions
aws lambda delete-function --function-name payment-sql-create
aws lambda delete-function --function-name payment-sql-get
aws lambda delete-function --function-name payment-sql-getall
aws lambda delete-function --function-name payment-sql-update
aws lambda delete-function --function-name fileDownloadsql
aws lambda delete-function --function-name fileUploadsql
aws lambda delete-function --function-name fileDeletesql

#Delete event source mappings
export inboxIngesterUuid=$(aws lambda list-event-source-mappings --function-name payment-sql-inbox-ingester | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["EventSourceMappings"][0]["UUID"]')
export avroIngesterUuid=$(aws lambda list-event-source-mappings --function-name payment-sql-configavro-ingester | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["EventSourceMappings"][0]["UUID"]')
aws lambda delete-event-source-mapping --uuid ${inboxIngesterUuid}
aws lambda delete-event-source-mapping --uuid ${avroIngesterUuid}

# Delete REST API
export restAPIId=$(aws apigateway get-rest-apis | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["items"] if "ms-payment-order-sql-api" == api["name"]]; print filter[0]["id"]')
aws apigateway delete-rest-api --rest-api-id $restAPIId

# Delete API Key
export apiKeyId=$(aws apigateway get-api-keys | python -c 'import json,sys;keys=json.load(sys.stdin); filter=[key for key in keys["items"] if "ms-payment-order-sql-apikey" == key["name"]]; print filter[0]["id"]')
aws apigateway delete-api-key --api-key $apiKeyId

# Create usage plan and get Id
export usagePlanId=$(aws apigateway get-usage-plans | python -c 'import json,sys; usagePlans=json.load(sys.stdin); filter=[plan for plan in usagePlans["items"] if "ms-payment-order-sql-usageplan" == plan["name"]]; print filter[0]["id"]')
aws apigateway delete-usage-plan --usage-plan-id $usagePlanId