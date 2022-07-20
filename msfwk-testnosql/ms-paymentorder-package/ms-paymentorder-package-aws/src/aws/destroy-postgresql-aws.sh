#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#


export DEPLOYMENT_ENVIRONMENT="postgres"

# Delete streams
aws kinesis delete-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-inbox-topic
aws kinesis delete-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-event-topic
aws kinesis delete-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-payment-inbox-error-topic
aws kinesis delete-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-payment-outbox
aws kinesis delete-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-table-update-paymentorder
aws kinesis delete-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-outbox

aws rds delete-db-instance  --db-instance-identifier PaymentOrderPosgres --skip-final-snapshot
sleep 600

# Delete and remove APIs from ApiGateway
restDeleteAPIIdCommand="aws apigateway get-rest-apis | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis[\"items\"] if \"${DEPLOYMENT_ENVIRONMENT}-ms-payment-order-api\" == api[\"name\"]]; print filter[0][\"id\"]'"
export restDeleteAPIId=$(eval "$restDeleteAPIIdCommand")
aws apigateway delete-rest-api --rest-api-id $restDeleteAPIId

apiDeleteKeyIdCommand="aws apigateway get-api-keys | python -c 'import json,sys;keys=json.load(sys.stdin); filter=[key for key in keys[\"items\"] if \"${DEPLOYMENT_ENVIRONMENT}-ms-payment-order-apikey\" == key[\"name\"]]; print filter[0][\"id\"]'"
export apiDeleteKeyId=$(eval "$apiDeleteKeyIdCommand")
aws apigateway delete-api-key --api-key $apiDeleteKeyId

# Delete S3 bucket
aws s3 rb s3://${DEPLOYMENT_ENVIRONMENT}-ms-payment-order --force
sleep 30

#Delete scheduler
aws events remove-targets --rule ${DEPLOYMENT_ENVIRONMENT}-ms-paymentorder-scheduler-rule --ids "${DEPLOYMENT_ENVIRONMENT}-paymentorder-scheduler"
aws events delete-rule --name ${DEPLOYMENT_ENVIRONMENT}-ms-paymentorder-scheduler-rule
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-scheduler

#Delete inbox cleanup scheduler
aws events remove-targets --rule ${DEPLOYMENT_ENVIRONMENT}-ms-poinboxcleanupScheduler-scheduler-rule --ids "${DEPLOYMENT_ENVIRONMENT}-poinboxcleanupScheduler"
aws events delete-rule --name ${DEPLOYMENT_ENVIRONMENT}-ms-poinboxcleanupScheduler-scheduler-rule
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-poinboxcleanupScheduler

# Delete usage plan
usageDeletePlanIdCommand="aws apigateway get-usage-plans | python -c 'import json,sys; usagePlans=json.load(sys.stdin); filter=[plan for plan in usagePlans[\"items\"] if \"${DEPLOYMENT_ENVIRONMENT}-ms-payment-order-usageplan\" == plan[\"name\"]]; print filter[0][\"id\"]'"
export usageDeletePlanId=$(eval "$usageDeletePlanIdCommand")
aws apigateway delete-usage-plan --usage-plan-id $usageDeletePlanId

# Delete event source mapping
inboxuuidCommand="aws lambda list-event-source-mappings --event-source-arn $inboxSourceArn | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[\"EventSourceMappings\"][0][\"UUID\"]'"
export inboxuuid=$(eval "$inboxuuidCommand")
aws lambda delete-event-source-mapping --uuid $inboxuuid

outboxuuidCommand="aws lambda list-event-source-mappings --event-source-arn $outboxSourceArn | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[\"EventSourceMappings\"][0][\"UUID\"]'"
export outboxuuid=$(eval "$outboxuuidCommand")
aws lambda delete-event-source-mapping --uuid $outboxuuid

inboxingesteruuidCommand="aws lambda list-event-source-mappings --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/${DEPLOYMENT_ENVIRONMENT}-payment-inbox-topic | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[\"EventSourceMappings\"][0][\"UUID\"]'"
export inboxingesteruuid=$(eval "$inboxingesteruuidCommand")
aws lambda delete-event-source-mapping --uuid $inboxingesteruuid

inboxingesteruuidCommand="aws lambda list-event-source-mappings --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/${DEPLOYMENT_ENVIRONMENT}-paymentorder-event-topic | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[\"EventSourceMappings\"][0][\"UUID\"]'"
export inboxingesteruuid=$(eval "$inboxingesteruuidCommand")
aws lambda delete-event-source-mapping --uuid $inboxingesteruuid

inboxingesteruuidCommand="aws lambda list-event-source-mappings --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/${DEPLOYMENT_ENVIRONMENT}-table-update-paymentorder | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[\"EventSourceMappings\"][0][\"UUID\"]'"
export inboxingesteruuid=$(eval "$inboxingesteruuidCommand")
aws lambda delete-event-source-mapping --uuid $inboxingesteruuid

# Delete lambdas
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-inbox-ingester
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-event-ingester
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-post-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-getall-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-get-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-put-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-outbox-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-ingester
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-create-reference-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-reference-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-create-reference-value-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-update-reference-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-delete-reference-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-metadata-record-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-tables-record-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-table-record-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-fileDownload
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-fileUpload
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-fileDelete
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-create-customer-payments
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-customer-payments
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-post-api-validation-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-put-status-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-delete-status-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-invoke-state
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-sql-get-currency
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-create-user
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-get-user
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-create-account
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-get-account
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-delete-account
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-update-account
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-order-delete
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-get-validation
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-search-users
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-get-account-validate
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-create-reference-record-api-handler 
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-update-reference-record-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-delete-reference-record-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-reference-record-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-gettype-reference-record-api-handler
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-cdp_erasure
aws lambda delete-function --function-name ${DEPLOYMENT_ENVIRONMENT}-cdp_reportgeneration
sleep 60