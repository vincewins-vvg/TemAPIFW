#!/bin/bash -x

# Create Streams
aws kinesis create-stream --stream-name payment-inbox-topic --shard-count 1
aws kinesis create-stream --stream-name payment-inbox-error-topic --shard-count 1
aws kinesis create-stream --stream-name payment-outbox-topic --shard-count 1
aws kinesis create-stream --stream-name table-update-paymentorder --shard-count 1
sleep 10

# Create tables
export inboxSourceArn=$(aws dynamodb create-table --table-name PaymentOrder.ms_inbox_events --attribute-definitions AttributeName=eventId,AttributeType=S AttributeName=eventType,AttributeType=S --key-schema AttributeName=eventId,KeyType=HASH  AttributeName=eventType,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["TableDescription"]["LatestStreamArn"]')

aws dynamodb create-table --table-name ms_payment_order --attribute-definitions AttributeName=paymentOrderId,AttributeType=S AttributeName=debitAccount,AttributeType=S --key-schema AttributeName=paymentOrderId,KeyType=HASH  AttributeName=debitAccount,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

export outboxSourceArn=$(aws dynamodb create-table --table-name PaymentOrder.ms_outbox_events --attribute-definitions AttributeName=eventId,AttributeType=S AttributeName=eventType,AttributeType=S --key-schema AttributeName=eventId,KeyType=HASH  AttributeName=eventType,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["TableDescription"]["LatestStreamArn"]')
sleep 10

# upload files
aws s3 mb s3://ms-payment-order
sleep 30
aws s3 cp app/ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar s3://ms-payment-order --storage-class REDUCED_REDUNDANCY

# Create lambdas
aws lambda create-function --function-name payment-inbox-ingester --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Inbox Ingester for Holding Service" --timeout 120 --memory-size 256 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=payment-inbox-error-topic,temn_msf_ingest_generic_ingester=com.temenos.microservice.framework.core.ingester.GenericCommandBinaryIngester,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,temn_msf_ingest_is_avro_event_ingester=false,DATABASE_KEY=dynamodb,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties\}
sleep 10

aws lambda create-function --function-name create-reference-api-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.CreateReferenceDataFunctionAWS::invoke --description "Handler for SQL Get Reference Data Impl" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_createReferenceData=com.temenos.microservice.framework.core.data.referencedata.CreateReferenceDataImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name get-reference-api-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.GetReferenceDataFunctionAWS::invoke --description "Handler for SQL POST Reference Data Impl" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_getReferenceData=com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name create-reference-value-api-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.AddReferenceDataFunctionAWS::invoke --description "Handler for SQL POST Reference Value Impl to " --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_addReferenceData=com.temenos.microservice.framework.core.data.referencedata.AddReferenceDataImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name update-reference-api-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.UpdateReferenceDataFunctionAWS::invoke --description "Handler for SQL PUT Reference Data Impl to " --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_updateReferenceData=com.temenos.microservice.framework.core.data.referencedata.UpdateReferenceDataImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name delete-reference-api-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.DeleteReferenceDataFunctionAWS::invoke --description "Handler for SQL PUT Reference Data Impl to " --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_deleteReferenceData=com.temenos.microservice.framework.core.data.referencedata.DeleteReferenceDataImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,class_package_name=com.temenos.microservice.framework.core.data.referencedata,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-post-api-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_CreateNewPaymentOrder=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-getall-api-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorderschema.function.GetPaymentOrdersFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_GetPaymentOrders=com.temenos.microservice.paymentorder.function.GetPaymentOrdersImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/XACML/Xacml.properties,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-get-api-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.GetPaymentOrderFunctionAWS::invoke --description "GET Payment order handler" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_GetPaymentOrder=com.temenos.microservice.paymentorder.function.GetPaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-put-api-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.UpdatePaymentOrderFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_UpdatePaymentOrder=com.temenos.microservice.paymentorder.function.UpdatePaymentOrderImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name inbox-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.InboxHandler::handleRequest --description "Listen inbox table and deliver the events to designated queue" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{temn_msf_security_authz_enabled=false,DATABASE_KEY=dynamodb,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,class_package_name=com.temenos.microservice.paymentorder.function,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl\}
sleep 10

aws lambda create-function --function-name outbox-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.OutboxHandler::handleRequest --description "Listen outbox table and deliver the events to designated queue" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{OUTBOX_STREAM=payment-outbox-topic,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder\}
sleep 10

aws lambda create-function --function-name paymentorder-ingester --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Paymentorder Service" --timeout 120 --memory-size 256 --publish --tags FunctionType=Ingester,Service=Payments --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_msf_stream_kinesis_region=eu-west-2,temn_msf_stream_vendor=kinesis,temn_msf_schema_registry_url=\"Data,PAYMENT.ORDER\",temn_msf_ingest_sink_error_stream=error-paymentorder,temn_msf_ingest_event_ingester=com.temenos.microservice.framework.core.ingester.MicroserviceIngester,temn_ingester_mapping_enabled=true,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,DATABASE_KEY=dynamodb,PAYMENT_ORDEREvent=com.temenos.microservice.paymentorder.entity.PaymentOrder,EXECUTION_ENVIRONMENT=TEST,EXECUTION_ENV=TEST,temn_msf_ingest_source_stream=table-update-paymentorder,temn_config_file_path=s3://metering-file-bucket/test/\}
sleep 10

aws lambda create-function --function-name fileUpload --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.FileUploadFunctionAWS::invoke --description "Handler for  FileUploadFunctionAWS Impl" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_FileUpload=com.temenos.microservice.paymentorder.function.FileUploadImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_msf_storage_home=s3://paymentorder-file-bucket\}
sleep 10

aws lambda create-function --function-name fileDownload --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentorder.function.FileDownloadFunctionAWS::invoke --description "Handler for  FileDownloadFunctionAWS Impl" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order",S3Key=ms-paymentorder-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{className_FileDownload=com.temenos.microservice.paymentorder.function.FileDownloadImpl,class_package_name=com.temenos.microservice.paymentorder.function,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=dynamodb,temn_msf_security_authz_enabled=false,temn_exec_env=serverless,temn_msf_name=PaymentOrder,temn_msf_stream_vendor=kinesis,temn_msf_storage_home=s3://paymentorder-file-bucket\}
sleep 10

# Create event source mapping
aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/payment-inbox-topic --function-name payment-inbox-ingester --enabled --batch-size 100 --starting-position LATEST

aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/table-update-paymentorder --function-name paymentorder-ingester --enabled --batch-size 100 --starting-position LATEST

aws lambda create-event-source-mapping --function-name inbox-handler --batch-size 500 --starting-position LATEST --event-source-arn $inboxSourceArn

aws lambda create-event-source-mapping --function-name outbox-handler --batch-size 500 --starting-position LATEST --event-source-arn $outboxSourceArn
sleep 10

# Create and add APIs to ApiGateway
export restAPIId=$(aws apigateway create-rest-api --name ms-payment-order-api --description "Payment order API" --binary-media-types "multipart/form-data" "*/*" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-gateway-response --rest-api-id $restAPIId --response-type MISSING_AUTHENTICATION_TOKEN --status-code 404

export apiRootResourceId=$(aws apigateway get-resources --rest-api-id $restAPIId | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["items"][-1]["id"]')

export versionResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $apiRootResourceId --path-part "v1.0.0" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export paymentsId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $apiRootResourceId --path-part "payments" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export ordersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "orders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

# Create Reference resource and get id - /v1.0.0/reference
export referenceResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "reference" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')
echo "----------------------------------"
echo $referenceResourceId
echo "----------------------------------"

# POST API
aws apigateway put-method --rest-api-id $restAPIId --resource-id $referenceResourceId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $referenceResourceId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:create-reference-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# POST: /v1.0.0/reference/{types}
export typeIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $referenceResourceId --path-part "{types}" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $typeIdResourceId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $typeIdResourceId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:create-reference-value-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# DELETE API
aws apigateway put-method --rest-api-id $restAPIId --resource-id $typeIdResourceId --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $typeIdResourceId --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:delete-reference-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# GET API
aws apigateway put-method --rest-api-id $restAPIId --resource-id $referenceResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $referenceResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:get-reference-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# PUT API
aws apigateway put-method --rest-api-id $restAPIId --resource-id $referenceResourceId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $referenceResourceId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:update-reference-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


aws apigateway put-method --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-post-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $ordersId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $ordersId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-getall-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

export paymentorderId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $ordersId --path-part "{paymentId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $paymentorderId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $paymentorderId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-get-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $paymentorderId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $paymentorderId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-put-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#FileUpload API

export uploadid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "upload" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $uploadid --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $uploadid --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:fileUpload/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#FileDownload API
export downloadid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "download" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export downloadparams=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $downloadid --path-part "{fileName}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $downloadparams --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $downloadparams --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:fileDownload/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_BINARY

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