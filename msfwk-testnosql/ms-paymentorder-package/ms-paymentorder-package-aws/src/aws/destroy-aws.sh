#!/bin/bash -x

# Delete streams
aws kinesis delete-stream --stream-name PaymentOrder-inbox-topic
aws kinesis delete-stream --stream-name PaymentOrder-event-topic
aws kinesis delete-stream --stream-name payment-inbox-error-topic
aws kinesis delete-stream --stream-name payment-outbox-topic
aws kinesis delete-stream --stream-name table-update-paymentorder

# Delete and remove APIs from ApiGateway
export restDeleteAPIId=$(aws apigateway get-rest-apis | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["items"] if "ms-payment-order-api" == api["name"]]; print filter[0]["id"]')
aws apigateway delete-rest-api --rest-api-id $restDeleteAPIId

export apiDeleteKeyId=$(aws apigateway get-api-keys | python -c 'import json,sys;keys=json.load(sys.stdin); filter=[key for key in keys["items"] if "ms-payment-order-apikey" == key["name"]]; print filter[0]["id"]')
aws apigateway delete-api-key --api-key $apiDeleteKeyId

# Delete S3 bucket
aws s3 rb s3://ms-payment-order --force
sleep 30

#Delete scheduler
export schedulerRuleTargetId=$(aws events list-targets-by-rule --rule "ms-paymentorder-scheduler-rule" | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["Targets"] if "arn:aws:lambda:eu-west-2:177642146375:function:paymentorder-scheduler" == api["Arn"]]; print filter[0]["Id"]')
aws events remove-targets --rule ms-paymentorder-scheduler-rule --ids $schedulerRuleTargetId
aws events delete-rule --name ms-paymentorder-scheduler-rule
aws lambda delete-function --function-name paymentorder-scheduler

# Delete tables
aws dynamodb delete-table --table-name PaymentOrder.ms_inbox_events
aws dynamodb delete-table --table-name PaymentOrder.ms_outbox_events

# Delete event source mapping
export inboxingestorUUID=$(aws lambda list-event-source-mappings --function-name payment-inbox-ingester | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["EventSourceMappings"][0]["UUID"]')
aws lambda delete-event-source-mapping --uuid $inboxingestorUUID

export eventIngesterUUID=$(aws lambda list-event-source-mappings --function-name payment-event-ingester | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["EventSourceMappings"][0]["UUID"]')
aws lambda delete-event-source-mapping --uuid $eventIngesterUUID

export ingesterUUID=$(aws lambda list-event-source-mappings --function-name paymentorder-ingester | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["EventSourceMappings"][0]["UUID"]')
aws lambda delete-event-source-mapping --uuid $ingesterUUID

export outboxHandlerUUID=$(aws lambda list-event-source-mappings --function-name outbox-handler | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["EventSourceMappings"][0]["UUID"]')
aws lambda delete-event-source-mapping --uuid $outboxHandlerUUID

# Delete tables
aws dynamodb delete-table --table-name ms_payment_order
aws dynamodb delete-table --table-name ms_payment_order_customer
aws dynamodb delete-table --table-name ms_payment_order_balance
aws dynamodb delete-table --table-name ms_payment_order_transaction
aws dynamodb delete-table --table-name ms_event_sequence

# Delete usage plan
export usageDeletePlanId=$(aws apigateway get-usage-plans | python -c 'import json,sys; usagePlans=json.load(sys.stdin); filter=[plan for plan in usagePlans["items"] if "ms-payment-order-usageplan" == plan["name"]]; print filter[0]["id"]')
aws apigateway delete-usage-plan --usage-plan-id $usageDeletePlanId

# Delete lambdas
aws lambda delete-function --function-name payment-inbox-ingester
aws lambda delete-function --function-name payment-event-ingester
aws lambda delete-function --function-name payment-post-api-handler
aws lambda delete-function --function-name payment-getall-api-handler
aws lambda delete-function --function-name payment-get-api-handler
aws lambda delete-function --function-name payment-put-api-handler
aws lambda delete-function --function-name outbox-handler
aws lambda delete-function --function-name paymentorder-ingester
aws lambda delete-function --function-name fileDownload
aws lambda delete-function --function-name fileUpload
aws lambda delete-function --function-name fileDelete
aws lambda delete-function --function-name create-customer-payments
aws lambda delete-function --function-name get-customer-payments
aws lambda delete-function --function-name payment-post-api-validation-handler
aws lambda delete-function --function-name payment-put-status-api-handler
aws lambda delete-function --function-name payment-delete-status-api-handler
sleep 60