#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#


#./repackbuild.sh ms-paymentorder postgresql

export DEPLOYMENT_ENVIRONMENT="mongo"

export JWT_TOKEN_PRINCIPAL_CLAIM="sub"
export JWT_TOKEN_ISSUER="https://localhost:9443/oauth2/token"
export ID_TOKEN_SIGNED="true"
export JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
export MONGODB_CONNSTR="mongodb+srv://user01:user01@mongodb01.jx2tl.mongodb.net/test"


# Create Streams
aws kinesis create-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-inbox-topic --shard-count 1
aws kinesis create-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-event-topic --shard-count 1
aws kinesis create-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-payment-inbox-error-topic --shard-count 1
aws kinesis create-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-outbox --shard-count 1
aws kinesis create-stream --stream-name ${DEPLOYMENT_ENVIRONMENT}-table-update-paymentorder --shard-count 1
sleep 10


# upload files
aws s3 mb s3://${DEPLOYMENT_ENVIRONMENT}-ms-payment-order
sleep 30
# Get the app file name for deployment
export serviceFileName=$(ls app | grep -e mongo)
aws s3 cp app/${serviceFileName} s3://${DEPLOYMENT_ENVIRONMENT}-ms-payment-order --storage-class REDUCED_REDUNDANCY

# Create lambdas for scheduler function
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-scheduler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.CloudWatchSchedulerProcessor::handleRequest --description "Scheduler for payment order" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_function_class_paymentscheduler=com.temenos.microservice.paymentorder.scheduler.PaymentOrderScheduler,temn_msf_security_authz_enabled=false,TEST_ENVIRONMENT=MOCK,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},temn_queue_impl=kinesis,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_kinesis_flow=true,DATABASE_KEY=mongodb,operationId=paymentscheduler,parameters=\''{"source":"JSON"}'\'\}

sleep 10
aws events put-rule --name ${DEPLOYMENT_ENVIRONMENT}-ms-paymentorder-scheduler-rule --schedule-expression 'cron(0/50 * * * ? *)'

sleep 10

aws lambda add-permission --function-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-scheduler --statement-id ${DEPLOYMENT_ENVIRONMENT}-ms-paymentorder-cloudwatchinvoke --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn arn:aws:events:eu-west-2:177642146375:rule/${DEPLOYMENT_ENVIRONMENT}-ms-paymentorder-scheduler-rule

sleep 10

aws events put-targets --rule ${DEPLOYMENT_ENVIRONMENT}-ms-paymentorder-scheduler-rule --targets "[{\"Id\":\"1\",\"Arn\":\"arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-paymentorder-scheduler\"}]"

sleep 10

# Create lambdas for scheduler inboxcleanup function
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-poinboxcleanupScheduler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.ingester.instance.CloudWatchSchedulerProcessor::handleRequest --description "Scheduler for inbox cleanup" --timeout 150 --memory-size 5000 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=${serviceFileName} --environment Variables=\{MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},temn_queue_impl=kinesis,temn_msf_kinesis_flow=true,DATABASE_KEY=mongodb,temn_entitlement_service_enabled=false,temn_msf_stream_vendor=kinesis,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_runtime_env=AWS,temn_msf_security_authz_enabled=false,temn_msf_name=PaymentOrder,temn_msf_scheduler_config=true,temn_msf_scheduler_config_key=scheduler,operationId=nosqlInboxCatchup,temn_msf_function_class_nosqlInboxCatchup=com.temenos.microservice.framework.scheduler.core.NoSqlInboxCatchupProcessor,temn_msf_scheduler_inboxcleanup_schedule=60,temn_msf_stream_kinesis_region=eu-west-2,EXECUTION_ENV=CLOUD,TEST_ENVIRONMENT=MOCK,temn_msf_outbox_direct_delivery_enabled=true,temn_config_service_api_key=\"ss0uIiJkxU4TZjkaSjSEU4LXU4svu1qrafCMpktz\"\}

sleep 10
aws events put-rule --name ${DEPLOYMENT_ENVIRONMENT}-ms-poinboxcleanupScheduler-scheduler-rule --schedule-expression 'cron(0/5 * * * ? *)'

sleep 10

aws lambda add-permission --function-name  ${DEPLOYMENT_ENVIRONMENT}-poinboxcleanupScheduler --statement-id ms-paymentorder-cloudwatchinvoke --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn arn:aws:events:eu-west-2:177642146375:rule/${DEPLOYMENT_ENVIRONMENT}-ms-poinboxcleanupScheduler-scheduler-rule

sleep 10

aws events put-targets --rule ${DEPLOYMENT_ENVIRONMENT}-ms-poinboxcleanupScheduler-scheduler-rule --targets "[{\"Id\":\"1\",\"Arn\":\"arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-poinboxcleanupScheduler\"}]"

sleep 10



# Create lambdas
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-inbox-ingester --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Inbox Ingester for Holding Service" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=${DEPLOYMENT_ENVIRONMENT}-payment-inbox-error-topic,temn_msf_ingest_generic_ingester=com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_package_name=com.temenos.microservice.paymentorder.function,temn_msf_ingest_is_avro_event_ingester=false,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_msf_function_class_UpdatePaymentOrder=com.temenos.microservice.paymentorder.function.UpdatePaymentOrderImpl,temn_msf_stream_vendor=kinesis,temn_entitlement_stubbed_service_enabled=true,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-event-ingester --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Inbox Ingester for Holding Service" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=${DEPLOYMENT_ENVIRONMENT}-payment-inbox-error-topic,temn_msf_ingest_generic_ingester=com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_package_name=com.temenos.microservice.paymentorder.function,temn_msf_ingest_is_avro_event_ingester=false,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_msf_ingest_event_processor=com.temenos.microservice.paymentorder.ingester.EventHandlerImpl,temn_msf_ingest_event_processor_POAccepted=com.temenos.microservice.paymentorder.ingester.PoHandlerImpl,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_stream_vendor=kinesis\}
sleep 10

#create reference data record lambda

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-create-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.CreateReferenceDataRecordFunctionAWS::invoke --description "Create reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_createReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.CreateReferenceDataRecordImpl,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10


#update reference data record lambda

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-update-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.UpdateReferenceDataRecordFunctionAWS::invoke --description "Update reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_updateReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.UpdateReferenceDataRecordImpl,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

#delete reference data record lambda

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-delete-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.DeleteReferenceDataRecordFunctionAWS::invoke --description "Delete reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_deleteReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.DeleteReferenceDataRecordImpl,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

#get reference data record lambda

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetReferenceDataRecordFunctionAWS::invoke --description "Get reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_getReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataRecordImpl,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

#get_type reference data record lambda

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-gettype-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetReferenceDataByTypeFunctionAWS::invoke --description "Get reference type data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_getReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataByTypeImpl,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,temn_msf_outbox_direct_delivery_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

#end reference data record lambdas

#Metadata API's lambda

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-metadata-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetMetadataFunctionAWS::invoke --description "Get Metadata" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_getMetadata=com.temenos.microservice.framework.core.data.metadata.GetMetadataImpl,class_package_name=com.temenos.microservice.framework.core.data.metadata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_queue_impl=kinesis,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_kinesis_flow=true\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-tables-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetTablesFunctionAWS::invoke --description "Get Metadata" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_getTables=com.temenos.microservice.framework.core.data.metadata.GetTablesImpl,class_package_name=com.temenos.microservice.framework.core.data.metadata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-table-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetTableFunctionAWS::invoke --description "Get Metadata" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_getTable=com.temenos.microservice.framework.core.data.metadata.GetTableImpl,class_package_name=com.temenos.microservice.framework.core.data.metadata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

#Metadata API's lambdas

# Create customer lambdas
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-create-customer-payments --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.paymentorder.function.CreateCustomerFunctionAWS::invoke --description "Create Customer" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_createCustomer=com.temenos.microservice.paymentorder.function.CreateCustomerImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_stream_vendor=kinesis,tem_msf_disableInbox=true\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-get-customer-payments --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.paymentorder.function.GetCustomersFunctionAWS::invoke --description "GEt customer" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_getCustomers=com.temenos.microservice.paymentorder.function.GetCustomerImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_stream_vendor=kinesis,tem_msf_disableInbox=true\}
sleep 10


aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-post-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_CreateNewPaymentOrder=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-getall-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorderschema.function.GetPaymentOrdersFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_GetPaymentOrders=com.temenos.microservice.paymentorder.function.GetPaymentOrdersImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

#dynamic order
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-dynamicorder-get-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorderschema.function.GetDynamicOrderFunctionAWS::invoke --description "dynamic order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_GetPaymentOrders=com.temenos.microservice.paymentorder.function.GetDynamicOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-get-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.GetPaymentOrderFunctionAWS::invoke --description "GET Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_GetPaymentOrder=com.temenos.microservice.paymentorder.function.GetPaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,temn_msf_outbox_direct_delivery_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-put-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.UpdatePaymentOrderFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_UpdatePaymentOrder=com.temenos.microservice.paymentorder.function.UpdatePaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,temn_msf_outbox_direct_delivery_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-outbox-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.OutboxHandlerKinesis::handleRequest --description "Listen outbox table and deliver the events to designated queue" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},OUTBOX_STREAM=${DEPLOYMENT_ENVIRONMENT}-payment-outbox-topic,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_ingest_is_cloud_event=true,temn_msf_stream_vendor=kinesis,MONGODB_DBNAME=ms_paymentorder,temn_msf_outbox_direct_delivery_enabled=true,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-ingester --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Paymentorder Service" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payments --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_msf_stream_kinesis_region=eu-west-2,temn_msf_stream_vendor=kinesis,temn_msf_schema_registry_url=\"Data,PAYMENT.ORDER\",temn_msf_ingest_sink_error_stream=${DEPLOYMENT_ENVIRONMENT}-error-paymentorder,temn_msf_ingest_event_ingester=com.temenos.microservice.framework.core.ingester.MicroserviceIngester,temn_ingester_mapping_enabled=true,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,PAYMENT_ORDEREvent=com.temenos.microservice.paymentorder.entity.PaymentOrder,EXECUTION_ENVIRONMENT=TEST,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true,EXECUTION_ENV=TEST,temn_msf_ingest_source_stream=${DEPLOYMENT_ENVIRONMENT}-table-update-paymentorder,temn_msf_outbox_direct_delivery_enabled=true,temn_config_file_path=s3://metering-file-bucket/test/\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-fileUpload --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.FileUploadFunctionAWS::invoke --description "Handler for  FileUploadFunctionAWS Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_FileUpload=com.temenos.microservice.paymentorder.function.FileUploadImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true,temn_msf_stream_vendor=kinesis,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_storage_home=s3://paymentorder-file-bucket\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-fileDownload --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.FileDownloadFunctionAWS::invoke --description "Handler for  FileDownloadFunctionAWS Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_FileDownload=com.temenos.microservice.paymentorder.function.FileDownloadImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_msf_storage_home=s3://paymentorder-file-bucket\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-put-status-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.UpdateStatusFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_UpdateStatus=com.temenos.microservice.paymentorder.function.UpdatePaymentStatusImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_outbox_direct_delivery_enabled=true,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-fileDelete --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.FileDeleteFunctionAWS::invoke --description "Handler for  FileDeleteFunctionAWS Impl" --timeout 120 --memory-size 512 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_FileDelete=com.temenos.microservice.paymentorder.function.FileDeleteImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_stream_vendor=kinesis,temn_msf_storage_home=s3://paymentorder-file-bucket,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-delete-status-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.DeleteWithConditionFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_DeleteWithCondition=com.temenos.microservice.paymentorder.function.DeleteWithConditionImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-post-api-validation-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.DoInputValidationFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_DoInputValidation=com.temenos.microservice.paymentorder.function.DoInputValidationImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

#invoke Payment State
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-invoke-state --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.InvokePaymentStateFunctionAWS::invoke --description "invoke Payment State handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_invokePaymentState=com.temenos.microservice.paymentorder.function.InvokePaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

#GetPaymentOrderCurrency
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-sql-get-currency --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.GetPaymentOrderCurrencyFunctionAWS::invoke --description "Get Payment order by currency handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_GetPaymentOrderCurrency=com.temenos.microservice.paymentorder.function.GetPaymentOrderCurrencyImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

#CreateUser
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-create-user --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.CreateUserFunctionAWS::invoke --description "Create User" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_CreateUser=com.temenos.microservice.paymentorder.function.CreateUserImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

#GetUser
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-get-user --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.GetUserFunctionAWS::invoke --description "Get User" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_GetUser=com.temenos.microservice.paymentorder.function.GetUserImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

#CreateAccount
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-create-account --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.CreateAccountFunctionAWS::invoke --description "Create Account" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_CreateAccount=com.temenos.microservice.paymentorder.function.CreateAccountImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

#GetAccount
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-get-account --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.GetAccountFunctionAWS::invoke --description "Get Account" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_GetAccount=com.temenos.microservice.paymentorder.function.GetAccountImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

#DeleteAccount
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-delete-account --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.DeleteAccountFunctionAWS::invoke --description "Delete Account" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_DeleteAccount=com.temenos.microservice.paymentorder.function.DeleteAccountImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

#UpdateAccount
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-update-account --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.UpdateAccountFunctionAWS::invoke --description "Update Account" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_UpdateAccount=com.temenos.microservice.paymentorder.function.UpdateAccountImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

#deletePaymentOrder
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-order-delete --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.DeletePaymentOrderFunctionAWS::invoke --description "Delete payment Order" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_deletePaymentOrder=com.temenos.microservice.paymentorder.function.DeletePaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis\}
sleep 10

#GetInputValidation
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-get-validation --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.GetInputValidationFunctionAWS::invoke --description "Get Input Validation" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_GetInputValidation=com.temenos.microservice.paymentorder.function.GetInputValidationImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_stream_vendor=kinesis\}
sleep 10

#searchUsers
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-search-users --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.SearchUsersFunctionAWS::invoke --description "Get Input Validation" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_searchUsers=com.temenos.microservice.paymentorder.function.SearchUsersImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_stream_vendor=kinesis\}
sleep 10

#GetAccountValidate
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-get-account-validate --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.GetAccountValidateFunctionAWS::invoke --description "Get Account Validation" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_GetAccountValidate=com.temenos.microservice.paymentorder.function.GetAccountValidateImpl,class_package_name=com.temenos.microservice.paymentorder.function,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_stream_vendor=kinesis\}
sleep 10


aws lambda create-function --function-name payment-delete-bulk-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.DeletePaymentOrdersFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_DeletePaymentOrders=com.temenos.microservice.paymentorder.function.DeletePaymentOrdersImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_msf_outbox_direct_delivery_enabled=true,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

#Customer personaldata protection
aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-cdp_erasure --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.dataprotection.function.ExecuteCDPErasureRequestFunctionAWS::invoke --description "Erasure API" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_ExecuteCDPErasureRequest=com.temenos.microservice.framework.dataprotection.function.ExecuteCDPErasureRequestImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10

aws lambda create-function --function-name ${DEPLOYMENT_ENVIRONMENT}-cdp_reportgeneration --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.dataprotection.function.ExecuteSubjectAccessRequestFunctionAWS::invoke --description "Erasure API" --timeout 120 --memory-size 1024 --publish --code S3Bucket="${DEPLOYMENT_ENVIRONMENT}-ms-payment-order",S3Key=ms-paymentorder-package-aws-mongo-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_deployment_env=${DEPLOYMENT_ENVIRONMENT},className_ExecuteSubjectAccessRequest=com.temenos.microservice.framework.dataprotection.function.ExecuteSubjectAccessRequestImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},MONGODB_DBNAME=ms_paymentorder,MONGODB_CONNECTIONSTR=${MONGODB_CONNSTR},DATABASE_KEY=mongodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_queue_impl=kinesis,temn_msf_kinesis_flow=true\}
sleep 10



# Create event source mapping
aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/${DEPLOYMENT_ENVIRONMENT}-paymentorder-inbox-topic --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-inbox-ingester --enabled --batch-size 100 --starting-position LATEST

aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/${DEPLOYMENT_ENVIRONMENT}-paymentorder-event-topic --function-name ${DEPLOYMENT_ENVIRONMENT}-payment-event-ingester --enabled --batch-size 100 --starting-position LATEST

aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/${DEPLOYMENT_ENVIRONMENT}-table-update-paymentorder --function-name ${DEPLOYMENT_ENVIRONMENT}-paymentorder-ingester --enabled --batch-size 100 --starting-position LATEST

aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/${DEPLOYMENT_ENVIRONMENT}-paymentorder-outbox --function-name ${DEPLOYMENT_ENVIRONMENT}-outbox-handler --enabled --batch-size 100 --starting-position LATEST

#aws lambda create-event-source-mapping --function-name ${DEPLOYMENT_ENVIRONMENT}-outbox-handler --batch-size 500 --starting-position LATEST --event-source-arn $outboxSourceArn
sleep 10

# Create and add APIs to ApiGateway
restAPIIdCommand="aws apigateway create-rest-api --name ${DEPLOYMENT_ENVIRONMENT}-ms-payment-order-api --description \"Payment order API\" --binary-media-types \"multipart/form-data\" \"*/*\" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[\"id\"]'"
export restAPIId=$(eval "$restAPIIdCommand")

aws apigateway put-gateway-response --rest-api-id $restAPIId --response-type MISSING_AUTHENTICATION_TOKEN --status-code 404

export apiRootResourceId=$(aws apigateway get-resources --rest-api-id $restAPIId | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["items"][-1]["id"]')

export versionResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $apiRootResourceId --path-part "v1.0.0" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export paymentsId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "payments" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export ordersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "orders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export allOrdersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "allorders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export deleteAllOrdersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $allOrdersId --path-part "delete" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export deleteId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $ordersId --path-part "delete" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export updateId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $ordersId --path-part "update" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export validationsId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "validations" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Create Reference resource and get id - /v1.0.0/reference
export referenceResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "reference" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')
echo "----------------------------------"
echo $referenceResourceId
echo "----------------------------------"

# Create Reference resource and get id - /v1.0.0/reference/referenceTypes
export referenceResourceTypeId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $referenceResourceId --path-part "referenceTypes" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

# reference-data-record-gateway-response

# GET: /v1.0.0/reference/referenceTypes/{referenceTypeId}
export reftypeIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $referenceResourceTypeId --path-part "{referenceTypeId}" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')


aws apigateway put-method --rest-api-id $restAPIId --resource-id $reftypeIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $reftypeIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-gettype-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


# POST: /v1.0.0/reference/{referenceTypeId}/referenceCodes

export refcodesResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $reftypeIdResourceId --path-part "referenceCodes" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

# POST: /v1.0.0/reference/{referenceTypeId}/referenceCodes/{referenceCode}
export refcodeIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $refcodesResourceId --path-part "{referenceCode}" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')


aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-create-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-update-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-delete-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-get-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#dynamicorder gateway
export dynamicType=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "getDynamicType" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export dynamicordersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $dynamicType --path-part "orders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $dynamicordersId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $dynamicordersId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-dynamicorder-get-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT
#end dynamicorder gateway

# Create metadata resource and get id - /v1.0.0/meta

export metadataResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "meta" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')


aws apigateway put-method --rest-api-id $restAPIId --resource-id $metadataResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $metadataResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-get-metadata-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# Create metadata resource and get id - /v1.0.0/meta/tables

export metadataTablesResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $metadataResourceId --path-part "tables" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')


aws apigateway put-method --rest-api-id $restAPIId --resource-id $metadataTablesResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $metadataTablesResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-get-tables-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# Create metadata resource and get id - /v1.0.0/meta/tables/{table}

export metadataTableidResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $metadataTablesResourceId --path-part "{table}" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')


aws apigateway put-method --rest-api-id $restAPIId --resource-id $metadataTableidResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $metadataTableidResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-get-table-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-payment-post-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $ordersId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $ordersId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-payment-getall-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

export paymentorderId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $ordersId --path-part "{paymentId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $paymentorderId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $paymentorderId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-payment-get-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $paymentorderId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $paymentorderId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-payment-put-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

export deletepaymentorderId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $deleteAllOrdersId --path-part "{paymentIds}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $deletepaymentorderId --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $deletepaymentorderId --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-delete-bulk-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#customer Api

export customersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "customers" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')


aws apigateway put-method --rest-api-id $restAPIId --resource-id $customersId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $customersId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-get-customer-payments/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $customersId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $customersId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-create-customer-payments/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


#FileUpload API

export uploadid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "upload" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $uploadid --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $uploadid --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-fileUpload/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $validationsId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $validationsId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-post-api-validation-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#FileDownload API
export downloadid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "download" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export downloadparams=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $downloadid --path-part "{fileName}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $downloadparams --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $downloadparams --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-fileDownload/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_BINARY

#FileDelete API
export filedeleteid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "delete" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export deleteparams=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $filedeleteid --path-part "{fileName}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $deleteparams --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $deleteparams --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-fileDelete/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_BINARY

aws apigateway put-method --rest-api-id $restAPIId --resource-id $updateId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $updateId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-payment-put-status-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $deleteId --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $deleteId --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-payment-delete-status-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


# Initiate DbMigration and GetDbMigration - /v1.0.0/migration
export migrationResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "migration" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

# Initiate DbMigration API
aws apigateway put-method --rest-api-id $restAPIId --resource-id $migrationResourceId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $migrationResourceId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:initiate-db-migration-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# GET DbMigration API
aws apigateway put-method --rest-api-id $restAPIId --resource-id $migrationResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $migrationResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:get-db-migration-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# Customer data protection APIs
export partyresource=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "party" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export personaldataresource=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $partyresource --path-part "personalData" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export erasurerequest=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $personaldataresource --path-part "erasureRequests" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export erasurerequestid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $erasurerequest --path-part "{erasureRequestId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $erasurerequestid --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $erasurerequestid --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-cdp_erasure/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT



export reports=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $personaldataresource --path-part "reports" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export reporttype=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $reports --path-part "{reportType}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export requests=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $reporttype --path-part "requests" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export requestid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $requests --path-part "{requestId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $requestid --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $requestid --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:${DEPLOYMENT_ENVIRONMENT}-cdp_reportgeneration/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT



aws apigateway create-deployment --rest-api-id $restAPIId --stage-name test-primary --stage-description "Payment order Stage"

apiKeyIdCommand="aws apigateway create-api-key --name ${DEPLOYMENT_ENVIRONMENT}-ms-payment-order-apikey --description \"Payment order API Key\" --enabled | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[\"id\"]'"
export apiKeyId=$(eval "$apiKeyIdCommand")

export apiKeyValue=$(aws apigateway get-api-key --api-key $apiKeyId --include-value | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["value"]')
sleep 10
export API_KEY=$apiKeyValue
echo $API_KEY

# Create usage plan
usagePlanIdCommand="aws apigateway create-usage-plan --name ${DEPLOYMENT_ENVIRONMENT}-ms-payment-order-usageplan --api-stages apiId=$restAPIId,stage=test-primary | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[\"id\"]'"
export usagePlanId=$(eval "$usagePlanIdCommand")

aws apigateway create-usage-plan-key --usage-plan-id $usagePlanId --key-id $apiKeyId --key-type API_KEY
sleep 10

export API_BASE_URL=https://${restAPIId}.execute-api.eu-west-2.amazonaws.com/test-primary
echo $API_BASE_URL