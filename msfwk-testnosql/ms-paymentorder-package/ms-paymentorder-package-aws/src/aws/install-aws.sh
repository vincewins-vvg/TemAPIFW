#!/bin/bash -x

# Create Streams
aws kinesis create-stream --stream-name payment-inbox-topic --shard-count 1
aws kinesis create-stream --stream-name payment-inbox-error-topic --shard-count 1
aws kinesis create-stream --stream-name payment-outbox-topic --shard-count 1
sleep 10

# Create tables
export inboxSourceArn=$(aws dynamodb create-table --table-name ms_inbox_events --attribute-definitions AttributeName=eventId,AttributeType=S AttributeName=eventname,AttributeType=S --key-schema AttributeName=eventId,KeyType=HASH  AttributeName=eventname,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["TableDescription"]["LatestStreamArn"]')

aws dynamodb create-table --table-name ms_payment_order --attribute-definitions AttributeName=paymentOrderId,AttributeType=S AttributeName=debitAccount,AttributeType=S --key-schema AttributeName=paymentOrderId,KeyType=HASH  AttributeName=debitAccount,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

export outboxSourceArn=$(aws dynamodb create-table --table-name ms_outbox_events --attribute-definitions AttributeName=eventId,AttributeType=S AttributeName=eventname,AttributeType=S --key-schema AttributeName=eventId,KeyType=HASH  AttributeName=eventname,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["TableDescription"]["LatestStreamArn"]')
sleep 10

# upload files
aws s3 mb s3://ms-payment-order
sleep 30
aws s3 cp app/ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar s3://ms-payment-order --storage-class REDUCED_REDUNDANCY

# Create lambdas
aws lambda create-function --function-name payment-inbox-ingester --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Inbox Ingester for Holding Service" --timeout 120 --memory-size 256 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=payment-inbox-error-topic,temn_msf_ingest_generic_ingester=com.temenos.microservice.framework.core.ingester.GenericCommandBinaryIngester,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl,class_package_name=com.temenos.microservice.payments.function,temn_msf_ingest_is_avro_event_ingester=false,DATABASE_KEY=dynamodb,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false\}
sleep 10

aws lambda create-function --function-name payment-api-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.CreateNewPaymentOrderFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl,class_package_name=com.temenos.microservice.payments.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false\}
sleep 10

aws lambda create-function --function-name inbox-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.InboxHandler::handleRequest --description "Listen inbox table and deliver the events to designated queue" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_security_authz_enabled=false,DATABASE_KEY=dynamodb,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,class_package_name=com.temenos.microservice.payments.function,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl\}
sleep 10

aws lambda create-function --function-name outbox-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.OutboxHandler::handleRequest --description "Listen outbox table and deliver the events to designated queue" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{OUTBOX_STREAM=payment-outbox-topic,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder\}
sleep 10

# Create event source mapping
aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/payment-inbox-topic --function-name payment-inbox-ingester --enabled --batch-size 100 --starting-position LATEST

aws lambda create-event-source-mapping --function-name inbox-handler --batch-size 500 --starting-position LATEST --event-source-arn $inboxSourceArn

aws lambda create-event-source-mapping --function-name outbox-handler --batch-size 500 --starting-position LATEST --event-source-arn $outboxSourceArn
sleep 10

# Create and add APIs to ApiGateway
export restAPIId=$(aws apigateway create-rest-api --name ms-payment-order-api --description "Payment order API" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-gateway-response --rest-api-id $restAPIId --response-type MISSING_AUTHENTICATION_TOKEN --status-code 404

export apiRootResourceId=$(aws apigateway get-resources --rest-api-id $restAPIId | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["items"][-1]["id"]')

export paymentsId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $apiRootResourceId --path-part "payments" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export ordersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "orders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway create-deployment --rest-api-id $restAPIId --stage-name test-primary --stage-description "Payment order Stage"

export apiKeyId=$(aws apigateway create-api-key --name ms-payment-order-apikey --description "Payment order API Key" --enabled | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export apiKeyValue=$(aws apigateway get-api-key --api-key $apiKeyId --include-value | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["value"]')
sleep 10
export API_KEY=$apiKeyValue
echo $API_KEY

# Create usage plan

export usagePlanId=$(aws apigateway create-usage-plan --name ms-payment-order-usageplan --api-stages apiId=$restAPIId,stage=test-primary | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway create-usage-plan-key --usage-plan-id $usagePlanId --key-id $apiKeyId --key-type API_KEY
sleep 10

export API_BASE_URL=https://${restAPIId}.execute-api.eu-west-2.amazonaws.com/test-primary
echo $API_BASE_URL