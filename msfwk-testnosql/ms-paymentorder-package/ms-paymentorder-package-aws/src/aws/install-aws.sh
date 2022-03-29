#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#


# ./repackbuild.sh ms-paymentorder dynamo

export JWT_TOKEN_PRINCIPAL_CLAIM="sub"
export JWT_TOKEN_ISSUER="https://localhost:9443/oauth2/token"
export ID_TOKEN_SIGNED="true"
export JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"


# Create Streams
aws kinesis create-stream --stream-name PaymentOrder-inbox-topic --shard-count 1
aws kinesis create-stream --stream-name PaymentOrder-event-topic --shard-count 1
aws kinesis create-stream --stream-name payment-inbox-error-topic --shard-count 1
aws kinesis create-stream --stream-name payment-outbox-topic --shard-count 1
aws kinesis create-stream --stream-name table-update-paymentorder --shard-count 1
sleep 10

# Create tables
export inboxSourceArn=$(aws dynamodb create-table --table-name PaymentOrder.ms_inbox_events --attribute-definitions AttributeName=eventId,AttributeType=S AttributeName=eventType,AttributeType=S --key-schema AttributeName=eventId,KeyType=HASH  AttributeName=eventType,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["TableDescription"]["LatestStreamArn"]')


aws dynamodb update-table \
--table-name PaymentOrder.ms_inbox_events \
--attribute-definitions AttributeName=status,AttributeType=S \
--global-secondary-index-updates \
"[{\"Create\":{\"IndexName\": \"status-index\",\"KeySchema\":[{\"AttributeName\":\"status\",\"KeyType\":\"HASH\"}], \
\"ProvisionedThroughput\": {\"ReadCapacityUnits\": 10, \"WriteCapacityUnits\": 5 },\"Projection\":{\"ProjectionType\":\"ALL\"}}}]"

aws dynamodb create-table --table-name ms_payment_order --attribute-definitions AttributeName=paymentOrderId,AttributeType=S AttributeName=debitAccount,AttributeType=S --key-schema AttributeName=paymentOrderId,KeyType=HASH  AttributeName=debitAccount,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

aws dynamodb create-table --table-name ms_reference_data --attribute-definitions AttributeName=type,AttributeType=S AttributeName=value,AttributeType=S --key-schema AttributeName=type,KeyType=HASH  AttributeName=value,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

aws dynamodb create-table --table-name ms_payment_order_customer --attribute-definitions AttributeName=customerId,AttributeType=S AttributeName=customerName,AttributeType=S --key-schema AttributeName=customerId,KeyType=HASH  AttributeName=customerName,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

aws dynamodb create-table --table-name ms_payment_order_balance --attribute-definitions AttributeName=recId,AttributeType=S --key-schema AttributeName=recId,KeyType=HASH  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

aws dynamodb create-table --table-name ms_payment_order_transaction --attribute-definitions AttributeName=recId,AttributeType=S --key-schema AttributeName=recId,KeyType=HASH  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

aws dynamodb create-table --table-name ms_event_sequence --attribute-definitions AttributeName=eventSourceId,AttributeType=S AttributeName=businessKey,AttributeType=S --key-schema AttributeName=eventSourceId,KeyType=HASH  AttributeName=businessKey,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

export outboxSourceArn=$(aws dynamodb create-table --table-name PaymentOrder.ms_outbox_events --attribute-definitions AttributeName=eventId,AttributeType=S AttributeName=eventType,AttributeType=S --key-schema AttributeName=eventId,KeyType=HASH  AttributeName=eventType,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["TableDescription"]["LatestStreamArn"]')
sleep 10

# upload files
aws s3 mb s3://ms-payment-order
sleep 30
# Get the app file name for deployment
export serviceFileName=$(ls app | grep -e dynamo)
aws s3 cp app/${serviceFileName} s3://ms-payment-order --storage-class REDUCED_REDUNDANCY

# Create lambdas for scheduler function
aws lambda create-function --function-name paymentorder-scheduler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.CloudWatchSchedulerProcessor::handleRequest --description "Scheduler for payment order" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_function_class_paymentscheduler=com.temenos.microservice.paymentorder.scheduler.PaymentOrderScheduler,temn_msf_security_authz_enabled=false,TEST_ENVIRONMENT=MOCK,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,DATABASE_KEY=dynamodb,operationId=paymentscheduler,parameters=\''{"source":"JSON"}'\'\}

sleep 10
aws events put-rule --name ms-paymentorder-scheduler-rule --schedule-expression 'cron(0/50 * * * ? *)'

sleep 10

aws lambda add-permission --function-name  paymentorder-scheduler --statement-id ms-paymentorder-cloudwatchinvoke --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn arn:aws:events:eu-west-2:177642146375:rule/ms-paymentorder-scheduler-rule

sleep 10

aws events put-targets --rule ms-paymentorder-scheduler-rule --targets "[{\"Id\":\"1\",\"Arn\":\"arn:aws:lambda:eu-west-2:177642146375:function:paymentorder-scheduler\"}]"

sleep 10


# Create lambdas for scheduler inboxcleanup function
aws lambda create-function --function-name poinboxcleanupScheduler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.ingester.instance.CloudWatchSchedulerProcessor::handleRequest --description "Scheduler for inbox cleanup" --timeout 150 --memory-size 5000 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{DATABASE_KEY=dynamodb,temn_entitlement_service_enabled=false,temn_msf_stream_vendor=kinesis,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_runtime_env=AWS,temn_msf_security_authz_enabled=false,temn_msf_name=PaymentOrder,temn_msf_scheduler_config=true,temn_msf_scheduler_config_key=scheduler,operationId=nosqlInboxCatchup,temn_msf_function_class_nosqlInboxCatchup=com.temenos.microservice.framework.scheduler.core.NoSqlInboxCatchupProcessor,temn_msf_scheduler_inboxcleanup_schedule=60,temn_msf_stream_kinesis_region=eu-west-2,EXECUTION_ENV=CLOUD,TEST_ENVIRONMENT=MOCK,temn_config_service_api_key=\"ss0uIiJkxU4TZjkaSjSEU4LXU4svu1qrafCMpktz\"\}

sleep 10
aws events put-rule --name ms-poinboxcleanupScheduler-scheduler-rule --schedule-expression 'cron(0/5 * * * ? *)'

sleep 10

aws lambda add-permission --function-name  poinboxcleanupScheduler --statement-id ms-paymentorder-cloudwatchinvoke --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn arn:aws:events:eu-west-2:177642146375:rule/ms-poinboxcleanupScheduler-scheduler-rule

sleep 10

aws events put-targets --rule ms-poinboxcleanupScheduler-scheduler-rule --targets "[{\"Id\":\"1\",\"Arn\":\"arn:aws:lambda:eu-west-2:177642146375:function:poinboxcleanupScheduler\"}]"

sleep 10





# Create lambdas
aws lambda create-function --function-name payment-inbox-ingester --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Inbox Ingester for Holding Service" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=payment-inbox-error-topic,temn_msf_ingest_generic_ingester=com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_package_name=com.temenos.microservice.paymentorder.function,temn_msf_ingest_is_avro_event_ingester=false,DATABASE_KEY=dynamodb,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_msf_function_class_UpdatePaymentOrder=com.temenos.microservice.paymentorder.function.UpdatePaymentOrderImpl,temn_msf_stream_vendor=kinesis,temn_entitlement_stubbed_service_enabled=true,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-event-ingester --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Inbox Ingester for Holding Service" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=payment-inbox-error-topic,temn_msf_ingest_generic_ingester=com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_package_name=com.temenos.microservice.paymentorder.function,temn_msf_ingest_is_avro_event_ingester=false,DATABASE_KEY=dynamodb,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_msf_ingest_event_processor=com.temenos.microservice.paymentorder.ingester.EventHandlerImpl,temn_msf_ingest_event_processor_POAccepted=com.temenos.microservice.paymentorder.ingester.PoHandlerImpl\}
sleep 10

# Create customer lambdas
aws lambda create-function --function-name create-customer-payments --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.paymentorder.function.CreateCustomerFunctionAWS::invoke --description "Create Customer" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_createCustomer=com.temenos.microservice.paymentorder.function.CreateCustomerImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,tem_msf_disableInbox=true\}
sleep 10

aws lambda create-function --function-name get-customer-payments --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.paymentorder.function.GetCustomersFunctionAWS::invoke --description "GEt customer" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_getCustomers=com.temenos.microservice.paymentorder.function.GetCustomerImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,tem_msf_disableInbox=true\}
sleep 10


aws lambda create-function --function-name payment-post-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_CreateNewPaymentOrder=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-post-bulk-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.CreateNewPaymentOrdersFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_CreateNewPaymentOrders=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrdersImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-getall-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorderschema.function.GetPaymentOrdersFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_GetPaymentOrders=com.temenos.microservice.paymentorder.function.GetPaymentOrdersImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-get-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.GetPaymentOrderFunctionAWS::invoke --description "GET Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_GetPaymentOrder=com.temenos.microservice.paymentorder.function.GetPaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-put-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.UpdatePaymentOrderFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_UpdatePaymentOrder=com.temenos.microservice.paymentorder.function.UpdatePaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-put-bulk-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.UpdateNewPaymentOrdersFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_UpdateNewPaymentOrders=com.temenos.microservice.paymentorder.function.UpdateNewPaymentOrdersImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-delete-bulk-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.DeletePaymentOrdersFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_DeletePaymentOrders=com.temenos.microservice.paymentorder.function.DeletePaymentOrdersImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10


aws lambda create-function --function-name outbox-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.OutboxHandler::handleRequest --description "Listen outbox table and deliver the events to designated queue" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{OUTBOX_STREAM=payment-outbox-topic,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_ingest_is_cloud_event=true\}
sleep 10

aws lambda create-function --function-name paymentorder-ingester --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Paymentorder Service" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payments --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_msf_stream_kinesis_region=eu-west-2,temn_msf_stream_vendor=kinesis,temn_msf_schema_registry_url=\"Data,PAYMENT.ORDER\",temn_msf_ingest_sink_error_stream=error-paymentorder,temn_msf_ingest_event_ingester=com.temenos.microservice.framework.core.ingester.MicroserviceIngester,temn_ingester_mapping_enabled=true,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,DATABASE_KEY=dynamodb,PAYMENT_ORDEREvent=com.temenos.microservice.paymentorder.entity.PaymentOrder,EXECUTION_ENVIRONMENT=TEST,EXECUTION_ENV=TEST,temn_msf_ingest_source_stream=table-update-paymentorder,temn_config_file_path=s3://metering-file-bucket/test/\}
sleep 10

aws lambda create-function --function-name fileUpload --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.FileUploadFunctionAWS::invoke --description "Handler for  FileUploadFunctionAWS Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_FileUpload=com.temenos.microservice.paymentorder.function.FileUploadImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_msf_storage_home=s3://paymentorder-file-bucket\}
sleep 10

aws lambda create-function --function-name fileDownload --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.FileDownloadFunctionAWS::invoke --description "Handler for  FileDownloadFunctionAWS Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_FileDownload=com.temenos.microservice.paymentorder.function.FileDownloadImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_msf_storage_home=s3://paymentorder-file-bucket\}
sleep 10

aws lambda create-function --function-name payment-put-status-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.UpdateStatusFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_UpdateStatus=com.temenos.microservice.paymentorder.function.UpdatePaymentStatusImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}

aws lambda create-function --function-name fileDelete --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.FileDeleteFunctionAWS::invoke --description "Handler for  FileDeleteFunctionAWS Impl" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_FileDelete=com.temenos.microservice.paymentorder.function.FileDeleteImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_msf_storage_home=s3://paymentorder-file-bucket\}
sleep 10

aws lambda create-function --function-name payment-delete-status-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.DeleteWithConditionFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_DeleteWithCondition=com.temenos.microservice.paymentorder.function.DeleteWithConditionImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

aws lambda create-function --function-name payment-post-api-validation-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.DoInputValidationFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_DoInputValidation=com.temenos.microservice.paymentorder.function.DoInputValidationImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

aws lambda create-function --function-name initiate-db-migration-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.InitiateDbMigrationFunctionAWS::invoke --description "Handler for NoSQL Initiate Db migration Impl " --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_initiateDbMigration=com.temenos.microservice.framework.dbmigration.core.InitiateDbMigrationImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,ms_security_tokencheck_enabled=N,temn_entitlement_stubbed_service_enabled=true,tem_msf_disableInbox=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_storage_home=s3://paymentorder-file-bucket\}
sleep 10

aws lambda create-function --function-name get-db-migration-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.GetDbMigrationFunctionAWS::invoke --description "Handler for NoSQL Initiate Get migration Impl " --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_getDbMigrationStatus=com.temenos.microservice.framework.dbmigration.core.GetDbMigrationStatusImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,tem_msf_disableInbox=true,ms_security_tokencheck_enabled=N,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_storage_home=s3://paymentorder-file-bucket\}
sleep 10

aws lambda create-function --function-name account-post-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.CreateAccountFunctionAWS::invoke --description "Account handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_CreateAccount=com.temenos.microservice.paymentorder.function.CreateAccountImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,ms_security_tokencheck_enabled=N\}
sleep 10

#start reference data lambda

aws lambda create-function --function-name create-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.CreateReferenceDataRecordFunctionAWS::invoke --description "create reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_createReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.CreateReferenceDataRecordImpl,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,ms_security_tokencheck_enabled=N\}
sleep 10


aws lambda create-function --function-name update-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.UpdateReferenceDataRecordFunctionAWS::invoke --description "update reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_updateReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.UpdateReferenceDataRecordImpl,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,ms_security_tokencheck_enabled=N\}
sleep 10


aws lambda create-function --function-name delete-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.DeleteReferenceDataRecordFunctionAWS::invoke --description "delete reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_deleteReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.DeleteReferenceDataRecordImpl,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,ms_security_tokencheck_enabled=N\}
sleep 10


aws lambda create-function --function-name get-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetReferenceDataRecordFunctionAWS::invoke --description "get reference data record by type and code" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_getReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataRecordImpl,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,ms_security_tokencheck_enabled=N\}
sleep 10

aws lambda create-function --function-name gettype-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetReferenceDataByTypeFunctionAWS::invoke --description "get reference data record by type" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_getReferenceDataByType=com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataByTypeImpl,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,ms_security_tokencheck_enabled=N\}
sleep 10


#end reference data lambda


export account=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "account" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $account --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $account --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:account-post-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws lambda create-function --function-name account-put-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.UpdateAccountFunctionAWS::invoke --description "Update Account handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{className_UpdateAccount=com.temenos.microservice.paymentorder.function.UpdateAccountImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,ms_security_tokencheck_enabled=N\}
sleep 10

export accountid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $account --path-part "{accountId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $accountid --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $accountid --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:account-put-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# Create event source mapping
aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/PaymentOrder-inbox-topic --function-name payment-inbox-ingester --enabled --batch-size 100 --starting-position LATEST

aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/PaymentOrder-event-topic --function-name payment-event-ingester --enabled --batch-size 100 --starting-position LATEST

aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/table-update-paymentorder --function-name paymentorder-ingester --enabled --batch-size 100 --starting-position LATEST

aws lambda create-event-source-mapping --function-name outbox-handler --batch-size 500 --starting-position LATEST --event-source-arn $outboxSourceArn
sleep 10

# Create and add APIs to ApiGateway
export restAPIId=$(aws apigateway create-rest-api --name ms-payment-order-api --description "Payment order API" --binary-media-types "multipart/form-data" "*/*" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-gateway-response --rest-api-id $restAPIId --response-type MISSING_AUTHENTICATION_TOKEN --status-code 404

export apiRootResourceId=$(aws apigateway get-resources --rest-api-id $restAPIId | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["items"][-1]["id"]')

export versionResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $apiRootResourceId --path-part "v1.0.0" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export paymentsId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "payments" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export ordersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "orders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export allOrdersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "allorders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export deleteAllOrdersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $allOrdersId --path-part "delete" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export updateAllOrdersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $allOrdersId --path-part "update" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export deleteId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $ordersId --path-part "delete" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export updateId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $ordersId --path-part "update" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export validationsId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "validations" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export referenceResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "reference" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')


# GET: /v1.0.0/reference/referenceTypes

export reftypesResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $referenceResourceId --path-part "referenceTypes" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# GET: /v1.0.0/reference/referenceTypes/{referenceTypeId}
export reftypeIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $reftypesResourceId --path-part "{referenceTypeId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $reftypeIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $reftypeIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:gettype-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT



# POST: /v1.0.0/reference/referenceTypes/{referenceTypeId}/referenceCodes

export refcodeResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $reftypeIdResourceId --path-part "referenceCodes" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# POST: /v1.0.0/reference/referenceTypes/{referenceTypeId}/referenceCodes/{referenceCode}

export refcodeIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $refcodeResourceId --path-part "{referenceCode}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')


aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:create-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:update-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:delete-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:get-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


#end reference data


aws apigateway put-method --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-post-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


aws apigateway put-method --rest-api-id $restAPIId --resource-id $allOrdersId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $allOrdersId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-post-bulk-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

export deletepaymentorderId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $deleteAllOrdersId --path-part "{paymentIds}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $deletepaymentorderId --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $deletepaymentorderId --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-delete-bulk-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $ordersId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $ordersId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-getall-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

export paymentorderId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $ordersId --path-part "{paymentId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $paymentorderId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $paymentorderId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-get-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $paymentorderId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $paymentorderId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-put-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $updateAllOrdersId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $updateAllOrdersId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-put-bulk-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#customer Api

export customersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "customers" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')


aws apigateway put-method --rest-api-id $restAPIId --resource-id $customersId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $customersId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:get-customer-payments/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $customersId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $customersId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:create-customer-payments/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


#FileUpload API

export uploadid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "upload" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $uploadid --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $uploadid --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:fileUpload/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#FileDownload API
export downloadid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "download" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export downloadparams=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $downloadid --path-part "{fileName}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $downloadparams --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $downloadparams --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:fileDownload/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_BINARY

#FileDelete API
export filedeleteid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "delete" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export deleteparams=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $filedeleteid --path-part "{fileName}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $deleteparams --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $deleteparams --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:fileDelete/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_BINARY

aws apigateway put-method --rest-api-id $restAPIId --resource-id $updateId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $updateId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-put-status-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $deleteId --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $deleteId --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-delete-status-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $validationsId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $validationsId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-post-api-validation-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway create-deployment --rest-api-id $restAPIId --stage-name test-primary --stage-description "Payment order Stage"

# Initiate DbMigration and GetDbMigration - /v1.0.0/migration
export migrationResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "migration" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

# Initiate DbMigration API
aws apigateway put-method --rest-api-id $restAPIId --resource-id $migrationResourceId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $migrationResourceId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:initiate-db-migration-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# GET DbMigration API
aws apigateway put-method --rest-api-id $restAPIId --resource-id $migrationResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $migrationResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:get-db-migration-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


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