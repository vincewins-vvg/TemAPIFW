#!/bin/bash -x

# Delete streams
aws kinesis delete-stream --stream-name payment-inbox-topic
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

# Delete tables
export inboxSourceArn=$(aws dynamodb delete-table --table-name PaymentOrder.ms_inbox_events | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["TableDescription"]["LatestStreamArn"]')

aws dynamodb delete-table --table-name ms_payment_order

export outboxSourceArn=$(aws dynamodb delete-table --table-name PaymentOrder.ms_outbox_events | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["TableDescription"]["LatestStreamArn"]')

# Delete usage plan
export usageDeletePlanId=$(aws apigateway get-usage-plans | python -c 'import json,sys; usagePlans=json.load(sys.stdin); filter=[plan for plan in usagePlans["items"] if "ms-payment-demo-usageplan" == plan["name"]]; print filter[0]["id"]')
aws apigateway delete-usage-plan --usage-plan-id $usageDeletePlanId

# Delete event source mapping
export inboxuuid=$(aws lambda list-event-source-mappings --event-source-arn $inboxSourceArn | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["EventSourceMappings"][0]["UUID"]')

aws lambda delete-event-source-mapping --uuid inboxuuid

export outboxuuid=$(aws lambda list-event-source-mappings --event-source-arn $outboxSourceArn | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["EventSourceMappings"][0]["UUID"]')

aws lambda delete-event-source-mapping --uuid outboxuuid

export inboxingesteruuid=$(aws lambda list-event-source-mappings --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/payment-inbox-topic | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["EventSourceMappings"][0]["UUID"]')

aws lambda delete-event-source-mapping --uuid inboxingesteruuid

# Delete lambdas
aws lambda delete-function --function-name payment-inbox-ingester
aws lambda delete-function --function-name payment-post-api-handler
aws lambda delete-function --function-name payment-getall-api-handler
aws lambda delete-function --function-name payment-get-api-handler
aws lambda delete-function --function-name payment-put-api-handler
aws lambda delete-function --function-name inbox-handler
aws lambda delete-function --function-name outbox-handler
aws lambda delete-function --function-name paymentorder-ingester
sleep 60