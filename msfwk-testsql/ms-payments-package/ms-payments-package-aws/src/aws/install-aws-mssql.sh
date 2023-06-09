#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#


export JWT_TOKEN_PRINCIPAL_CLAIM="sub"
export DATABASE_NAME="databaseName"
export JWT_TOKEN_ISSUER="https://localhost:9443/oauth2/token"
export ID_TOKEN_SIGNED="true"
export JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"


# Setup the environment
export PATH=/opt/apache-maven-3.3.9/bin:/usr/bin:/usr/sbin:/usr/local/bin:$PATH
export MAVEN_OPTS="-Xmx2048m"


# Create Streams
aws kinesis create-stream --stream-name PaymentOrder-inbox-topic --shard-count 1
aws kinesis create-stream --stream-name PaymentOrder-event-topic --shard-count 1
aws kinesis create-stream --stream-name payment-inbox-error-topic --shard-count 1
aws kinesis create-stream --stream-name payment-outbox-topic --shard-count 1
aws kinesis create-stream --stream-name table-update-paymentorder --shard-count 1
aws kinesis create-stream --stream-name error-paymentorder --shard-count 1

sleep 10


# Create instance for MSSQL
aws rds create-db-instance --allocated-storage 25 --db-instance-identifier paymentorderMSSQL --engine sqlserver-se --master-username sa --master-user-password rootroot --engine-version "15.00.4073.23.v1" --db-instance-class db.t3.xlarge --publicly-accessible --license-model license-included
sleep 900


# Get MSSQL DB Instance endpoint address
export host=$(aws rds describe-db-instances | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["DBInstances"] if "paymentordermssql" == api["DBInstanceIdentifier"]]; print filter[0]["Endpoint"]["Address"]')

# Get MSSQL DB Instance endpoint port
export port=$(aws rds describe-db-instances | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["DBInstances"] if "paymentordermssql" == api["DBInstanceIdentifier"]]; print filter[0]["Endpoint"]["Port"]')

# Get MSSQL DB name
export dbname=$(aws rds describe-db-instances | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["DBInstances"] if "paymentordermssql" == api["DBInstanceIdentifier"]]; print filter[0]["DBName"]')

# Get MSSQL DB master username
export username=$(aws rds describe-db-instances | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["DBInstances"] if "paymentordermssql" == api["DBInstanceIdentifier"]]; print filter[0]["MasterUsername"]')

# Get MSSQL DB instance arn
export dbinstancearn=$(aws rds describe-db-instances | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["DBInstances"] if "paymentordermssql" == api["DBInstanceIdentifier"]]; print filter[0]["DBInstanceArn"]')

# Before installing functions, get the fileName of the jar from /app
export serviceFileName=$(ls app)

# upload files
aws s3 mb s3://ms-payment-order-sql
sleep 30
aws s3 cp app/ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar s3://ms-payment-order-sql --storage-class REDUCED_REDUNDANCY

#create cloudwatch for payments Scheduler
aws lambda create-function --function-name paymentscheduler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.CloudWatchSchedulerProcessor::handleRequest --description "Scheduler for payment order" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order-sql",S3Key=${serviceFileName} --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,PORT=${port},HOST=${host},temn_msf_name=PaymentOrderService,temn_msf_function_class_paymentscheduler=com.temenos.microservice.payments.scheduler.PaymentOrderScheduler,temn_msf_security_authz_enabled=false,temn_msf_tracer_enabled=false,DATABASE_KEY=sql,TEST_ENVIRONMENT=MOCK,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,temn_msf_stream_vendor=kinesis,operationId=paymentscheduler,parameters=\''{"source":"JSON"}'\'\}

sleep 10
aws events put-rule --name ms-payments-scheduler-rule --schedule-expression 'cron(0/50 * * * ? *)'

sleep 10
aws lambda add-permission --function-name  paymentscheduler --statement-id ms-payment-cloudwatchinvoke --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn arn:aws:events:eu-west-2:177642146375:rule/ms-payments-scheduler-rule

sleep 10
aws events put-targets --rule ms-payments-scheduler-rule --targets "[{\"Id\":\"1\",\"Arn\":\"arn:aws:lambda:eu-west-2:177642146375:function:paymentscheduler\"}]"

sleep 10


#create cloudwatch for inboxcleanup scheduler
aws lambda create-function --function-name paymentinboxcleanupScheduler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.CloudWatchSchedulerProcessor::handleRequest --description "Scheduler for executing inboxcleanup" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order-sql",S3Key=${serviceFileName} --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,PORT=${port},HOST=${host},temn_msf_name=PaymentOrderService,temn_msf_function_class_sqlInboxCatchup=com.temenos.microservice.framework.scheduler.core.SqlInboxCatchupProcessor,temn_msf_scheduler_inboxcleanup_schedule=60,temn_msf_security_authz_enabled=false,DATABASE_KEY=sql,TEST_ENVIRONMENT=MOCK,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,temn_msf_stream_vendor=kinesis,operationId=sqlInboxCatchup,parameters=\''{"source":"JSON"}'\'\}

sleep 10
aws events put-rule --name ms-paymentinboxcleanupScheduler-scheduler-rule --schedule-expression 'cron(0/5 * * * ? *)'
sleep 10
aws lambda add-permission --function-name  paymentinboxcleanupScheduler --statement-id ms-payment-cloudwatchinvoke --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn arn:aws:events:eu-west-2:177642146375:rule/ms-paymentinboxcleanupScheduler-scheduler-rule
sleep 10
aws events put-targets --rule ms-paymentinboxcleanupScheduler-scheduler-rule --targets "[{\"Id\":\"1\",\"Arn\":\"arn:aws:lambda:eu-west-2:177642146375:function:paymentinboxcleanupScheduler\"}]"

sleep 10


# Create lambdas
aws lambda create-function --function-name payment-sql-create --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.CreateNewPaymentOrderFunctionAWS::invoke --description "Handler for SQL Create new payment order Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_name=PaymentOrder\}
sleep 10

aws lambda create-function --function-name payment-sql-getall --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.paymentsorder.function.GetPaymentOrdersFunctionAWS::invoke --description "Handler for SQL get all payment orders Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,PORT=${port},HOST=${host},temn_msf_security_authz_enabled=false,className_GetPaymentOrders=com.temenos.microservice.payments.function.GetPaymentOrdersImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-sql-get --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.GetPaymentOrderFunctionAWS::invoke --description "Handler for SQL Get payment order Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,className_GetPaymentOrder=com.temenos.microservice.payments.function.GetPaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,temn_exec_env=serverless,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_msf_outbox_direct_delivery_enabled=true,temn_entitlement_stubbed_service_enabled=true,temn_msf_tracer_enabled=false,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-sql-update --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.UpdatePaymentOrderFunctionAWS::invoke --description "Handler for SQL update payment order Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,className_UpdatePaymentOrder=com.temenos.microservice.payments.function.UpdatePaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,temn_exec_env=serverless,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-sql-inbox-ingester --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Inbox Ingester Service" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,DATABASE_NAME=payments,temn_msf_security_authz_enabled=false,EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=payment-inbox-error-topic,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false",temn_msf_ingest_is_avro_event_ingester=false,DATABASE_KEY=sql,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MIN_POOL_SIZE=10,MAX_POOL_SIZE=150,temn_msf_ingest_generic_ingester=com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester,temn_msf_function_class_UpdatePaymentOrder=com.temenos.microservice.payments.function.UpdatePaymentOrderImpl,temn_msf_stream_kinesis_region=eu-west-2,temn_msf_stream_vendor=kinesis,temn_msf_outbox_direct_delivery_enabled=true,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-sql-event-ingester --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Inbox Ingester Service" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DB_USERNAME=${username},DB_PASSWORD=rootroot,DATABASE_NAME=payments,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,EXECUTION_ENV=TEST,temn_msf_name=PaymentOrder,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=payment-inbox-error-topic,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false",temn_msf_ingest_is_avro_event_ingester=false,DATABASE_KEY=sql,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,MIN_POOL_SIZE=10,MAX_POOL_SIZE=150,temn_msf_ingest_generic_ingester=com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester,temn_msf_ingest_event_processor=com.temenos.microservice.payments.ingester.EventHandlerImpl,temn_msf_tracer_enabled=false,temn_msf_ingest_event_processor_POAccepted=com.temenos.microservice.payments.ingester.PoHandlerImpl,temn_msf_outbox_direct_delivery_enabled=true,class_package_name=com.temenos.microservice.payments.function\}
sleep 10

aws lambda create-function --function-name outbox-sql-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.OutboxHandlerSql::handleRequest --description "Listen outbox table and deliver the events to designated queue" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,EXECUTION_ENV=TEST,temn_msf_name=PaymentOrderService,DATABASE_KEY=sql,OUTBOX_STREAM=payment-outbox-topic,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},temn_exec_env=serverless,class_package_name=com.temenos.microservice.payments.function,temn_msf_tracer_enabled=false,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false",MIN_POOL_SIZE=10,MAX_POOL_SIZE=150s,temn_msf_ingest_is_cloud_event=true\}
sleep 10

aws lambda create-function --function-name payment-sql-configavro-ingester --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Ingester for payment-sql configavro Service" --timeout 120 --memory-size 1024 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,temn_msf_stream_kinesis_region=eu-west-2,temn_msf_stream_vendor=kinesis,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=error-paymentorder,temn_msf_ingest_event_ingester=com.temenos.microservice.framework.core.ingester.MicroserviceIngester,PAYMENT_ORDEREvent=com.temenos.microservice.payments.ingester.PaymentorderIngesterUpdater,temn_ingester_mapping_enabled=false,temn_msf_tracer_enabled=false,temn_msf_ingest_source_stream=table-update-paymentorder,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,HOST=${host},PORT=${port},temn_msf_schema_registry_url=\"Data,PAYMENT.ORDER\",DATABASE_KEY=sql,MIN_POOL_SIZE=10,MAX_POOL_SIZE=150\}
sleep 10


#Start reference data records


# Create lambdas
aws lambda create-function --function-name create-sql-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.CreateReferenceDataRecordFunctionAWS::invoke --description "Create Reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_createReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.CreateReferenceDataRecordImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,temn_msf_outbox_direct_delivery_enabled=true,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_name=PaymentOrder\}
sleep 10


aws lambda create-function --function-name update-sql-reference-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.UpdateReferenceDataRecordFunctionAWS::invoke --description "Update Reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_updateReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.UpdateReferenceDataRecordImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_name=PaymentOrder\}
sleep 10


aws lambda create-function --function-name delete-sql-reference-record-api-handler  --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.DeleteReferenceDataRecordFunctionAWS::invoke --description "Delete Reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_deleteReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.DeleteReferenceDataRecordImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,temn_msf_outbox_direct_delivery_enabled=true,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_name=PaymentOrder\}
sleep 10


aws lambda create-function --function-name get-sql-reference-record-api-handler  --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetReferenceDataRecordFunctionAWS::invoke --description "Get Reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_getReferenceDataRecord=com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataRecordImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_name=PaymentOrder\}
sleep 10

aws lambda create-function --function-name gettype-sql-reference-record-api-handler  --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetReferenceDataByTypeFunctionAWS::invoke --description "Get by type Reference data record" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_getReferenceDataByType=com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataByTypeImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_name=PaymentOrder\}
sleep 10


#End Reference Data records

# Create metadata API's lambdas
aws lambda create-function --function-name get-sql-metadata-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetMetadataFunctionAWS::invoke --description "Get metadata records" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_getMetadata=com.temenos.microservice.framework.core.data.metadata.GetMetadataImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_name=PaymentOrder\}
sleep 10


aws lambda create-function --function-name get-sql-tables-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetTablesFunctionAWS::invoke --description "Get entity records" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_getTables=com.temenos.microservice.framework.core.data.metadata.GetTablesImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_name=PaymentOrder\}
sleep 10

aws lambda create-function --function-name get-sql-table-record-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetTableFunctionAWS::invoke --description "Get entity records" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_getTable=com.temenos.microservice.framework.core.data.metadata.GetTableImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,temn_msf_outbox_direct_delivery_enabled=true,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,temn_msf_name=PaymentOrder\}
sleep 10

#end metadata API's

aws lambda create-function --function-name fileUploadsql --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.FileUploadFunctionAWS::invoke --description "Handler for SQL FileUploadFunctionAWS Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,temn_msf_outbox_direct_delivery_enabled=true,className_FileUpload=com.temenos.microservice.payments.function.FileUploadImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},temn_msf_tracer_enabled=false,JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=5,MIN_POOL_SIZE=1,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name fileDownloadsql --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.FileDownloadFunctionAWS::invoke --description "Handler for SQL FileDownloadFunctionAWS Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,className_FileDownload=com.temenos.microservice.payments.function.FileDownloadImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},temn_msf_tracer_enabled=false,temn_msf_outbox_direct_delivery_enabled=true,JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=5,MIN_POOL_SIZE=1,ms_security_tokencheck_enabled=Y,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name payment-sql-validation --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.CreateNewPaymentOrderFunctionAWS::invoke --description "Handler for SQL Create new payment order Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=paymentsJWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},temn_msf_security_authz_enabled=false,className_DoInputValidation=com.temenos.microservice.payments.function.DoInputValidationImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,DATABASE_KEY=sql,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_tracer_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10\}

aws lambda create-function --function-name payment-post-bulk-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.CreateNewPaymentOrdersFunctionAWS::invoke --description "Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},temn_msf_security_authz_enabled=false,className_CreateNewPaymentOrders=com.temenos.microservice.payments.function.CreateNewPaymentOrdersImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,temn_msf_outbox_direct_delivery_enabled=true,DATABASE_KEY=sql,temn_msf_tracer_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10\}
sleep 10

aws lambda create-function --function-name payment-put-bulk-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.UpdateNewPaymentOrdersFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},temn_msf_security_authz_enabled=false,className_UpdateNewPaymentOrders=com.temenos.microservice.payments.function.UpdateNewPaymentOrdersImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,DATABASE_KEY=sql,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_tracer_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10\}
sleep 10

aws lambda create-function --function-name payment-delete-bulk-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.DeletePaymentOrdersFunctionAWS::invoke --description "Update Payment order handler" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},temn_msf_security_authz_enabled=false,className_DeletePaymentOrders=com.temenos.microservice.payments.function.DeletePaymentOrdersImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,DATABASE_KEY=sql,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_tracer_enabled=false,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10\}
sleep 10

aws lambda create-function --function-name fileDeletesql --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.FileDeleteFunctionAWS::invoke --description "Handler for SQL FileDeleteFunctionAWS Impl" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,className_FileDelete=com.temenos.microservice.payments.function.FileDeleteImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_msf_outbox_direct_delivery_enabled=true,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10



aws lambda create-function --function-name initiate-db-migration-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.InitiateDbMigrationFunctionAWS::invoke --description "Handler for NoSQL Initiate Db migration Impl" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,className_initiateDbMigration=com.temenos.microservice.framework.dbmigration.core.InitiateDbMigrationImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

aws lambda create-function --function-name get-db-migration-api-handler --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.core.function.aws.GetDbMigrationFunctionAWS::invoke --description "Handler for NoSQL Initiate Get migration Impl " --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,className_getDbMigrationStatus=com.temenos.microservice.framework.dbmigration.core.GetDbMigrationStatusImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_outbox_direct_delivery_enabled=true,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST\}
sleep 10

#Customer data protection Lambda functions
aws lambda create-function --function-name cdp_erasure --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.dataprotection.function.ExecuteCDPErasureRequestFunctionAWS::invoke --description "Handler for SQL Erasure API" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_ExecuteCDPErasureRequest=com.temenos.microservice.framework.dataprotection.function.ExecuteCDPErasureRequestImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,class_package_name=com.temenos.microservice.payments.function,temn_msf_name=PaymentOrder\}
sleep 10

aws lambda create-function --function-name cdp_reportgeneration --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.framework.dataprotection.function.ExecuteSubjectAccessRequestFunctionAWS::invoke --description "Handler for SQL Resport Generation API" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DIALECT=org.hibernate.dialect.SQLServer2012Dialect,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,PORT=${port},DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DB_USERNAME=sa,DB_PASSWORD=rootroot,DATABASE_NAME=payments,HOST=${host},temn_msf_security_authz_enabled=false,className_ExecuteSubjectAccessRequest=com.temenos.microservice.framework.dataprotection.function.ExecuteSubjectAccessRequestImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_msf_stream_vendor=kinesis,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,ms_security_tokencheck_enabled=Y,temn_msf_tracer_enabled=false,temn_entitlement_stubbed_service_enabled=true,EXECUTION_ENVIRONMENT=TEST,class_package_name=com.temenos.microservice.payments.function,temn_msf_name=PaymentOrder\}
sleep 10

#dynamic order
aws lambda create-function --function-name dynamicorder-get-api-handler-payments --runtime java8.al2 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.GetDynamicOrderFunctionAWS::invoke --description "Handler for SQL GetDynamicOrderFunctionAWS Impl" --timeout 120 --memory-size 1024 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver,DIALECT=org.hibernate.dialect.SQLServer2012Dialect,HOST=${host},PORT=${port},DATABASE_NAME=payments,DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:sqlserver://${host}:${port}\;${DATABASE_NAME}=payments,temn_msf_security_authz_enabled=false,className_GetDynamicOrder=com.temenos.microservice.payments.function.GetDynamicOrderImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=sql,temn_msf_storage_home=s3://paymentorder-file-bucket,JWT_TOKEN_PRINCIPAL_CLAIM=${JWT_TOKEN_PRINCIPAL_CLAIM},JWT_TOKEN_ISSUER=${JWT_TOKEN_ISSUER},ID_TOKEN_SIGNED=${ID_TOKEN_SIGNED},JWT_TOKEN_PUBLIC_KEY=${JWT_TOKEN_PUBLIC_KEY},FILE_STORAGE_URL=/pdpTestAzureFun.properties,MAX_POOL_SIZE=150,MIN_POOL_SIZE=10,temn_exec_env=serverless,temn_msf_stream_vendor=kinesis,ms_security_tokencheck_enabled=Y,temn_msf_outbox_direct_delivery_enabled=true,temn_entitlement_stubbed_service_enabled=true,temn_msf_tracer_enabled=false,EXECUTION_ENVIRONMENT=TEST\}
sleep 10


# Create event source mapping
aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/PaymentOrder-inbox-topic --function-name payment-sql-inbox-ingester --enabled --batch-size 100 --starting-position LATEST
sleep 10

aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/PaymentOrder-event-topic --function-name payment-sql-event-ingester --enabled --batch-size 100 --starting-position LATEST
sleep 10

aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/table-update-paymentorder --function-name payment-sql-configavro-ingester --enabled --batch-size 100 --starting-position LATEST
sleep 10



# Create and add APIs to ApiGateway
export restAPIId=$(aws apigateway create-rest-api --name ms-payment-order-sql-api --description "Payment order SQL API" --binary-media-types "multipart/form-data" "*/*" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
aws apigateway put-gateway-response --rest-api-id $restAPIId --response-type MISSING_AUTHENTICATION_TOKEN --status-code 404

export apiRootResourceId=$(aws apigateway get-resources --rest-api-id $restAPIId | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["items"][-1]["id"]')

export versionResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $apiRootResourceId --path-part "v1.0.0" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export paymentsId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "payments" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export ordersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "orders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export allOrdersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "allorders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export deleteAllOrdersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $allOrdersId --path-part "delete" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export updateAllOrdersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $allOrdersId --path-part "update" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')


export validationsId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "validations" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
aws apigateway put-method --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-sql-create/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $allOrdersId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $allOrdersId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-post-bulk-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

export deletepaymentorderId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $deleteAllOrdersId --path-part "{paymentIds}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $deletepaymentorderId --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $deletepaymentorderId --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-delete-bulk-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


aws apigateway put-method --rest-api-id $restAPIId --resource-id $ordersId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $ordersId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-sql-getall/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#FileUpload API

export uploadid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "upload" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $uploadid --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $uploadid --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:fileUploadsql/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#FileDownload API
export downloadid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "download" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export downloadparams=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $downloadid --path-part "{fileName}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $downloadparams --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $downloadparams --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:fileDownloadsql/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_BINARY

#FileDelete API
export filedeleteid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "delete" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export deleteparams=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $filedeleteid --path-part "{fileName}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $deleteparams --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $deleteparams --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:fileDeletesql/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_BINARY


aws apigateway put-method --rest-api-id $restAPIId --resource-id $validationsId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $validationsId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-sql-validation/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $updateAllOrdersId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $updateAllOrdersId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-put-bulk-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


# Create Reference resource and get id - /v1.0.0/reference
export referenceResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "reference" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')
echo "----------------------------------"
echo $referenceResourceId
echo "----------------------------------"

# Create Reference resource and get id - /v1.0.0/reference/referenceTypes
export referenceTypesResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $referenceResourceId --path-part "referenceTypes" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')


# GET: /v1.0.0/reference/referenceTypes/{referenceTypeId}
export reftypeIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $referenceTypesResourceId --path-part "{referenceTypeId}" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $reftypeIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $reftypeIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:gettype-sql-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


# GET: /v1.0.0/reference/referenceTypes/{referenceTypeId}/referenceCodes
export refcodeResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $reftypeIdResourceId --path-part "referenceCodes" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

# GET: /v1.0.0/reference/referenceTypes/{referenceTypeId}/referenceCodes/{referenceCode}
export refcodeIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $refcodeResourceId --path-part "{referenceCode}" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:create-sql-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:update-sql-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:delete-sql-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $refcodeIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:get-sql-reference-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT


# Create metadata resource and get id - /v1.0.0/meta
export metadataResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "meta" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $metadataResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $metadataResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:get-sql-metadata-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# Create metadata resource and get id - /v1.0.0/meta/tables
export metadataTablesResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $metadataResourceId --path-part "tables" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $metadataTablesResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $metadataTablesResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:get-sql-tables-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# Create metadata resource and get id - /v1.0.0/meta/{table}
export metadataTableIdResourceId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $metadataTablesResourceId --path-part "{table}" | python -c 'import json,sys;obj=json.load(sys.stdin); print (obj["id"])')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $metadataTableIdResourceId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $metadataTableIdResourceId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:get-sql-table-record-api-handler/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#dynamicorder gateway
export dynamicType=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $versionResourceId --path-part "getDynamicType" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export dynamicordersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $dynamicType --path-part "orders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $dynamicordersId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $dynamicordersId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:dynamicorder-get-api-handler-payments/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT
#end dynamicorder gateway


## ADDED GET
export paymentorderId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $ordersId --path-part "{paymentId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $paymentorderId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $paymentorderId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-sql-get/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway put-method --rest-api-id $restAPIId --resource-id $paymentorderId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $paymentorderId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-sql-update/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

#EMPLOYEE APIs
# POST: /v1.0.0/payments/employee
export employee=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "employee" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $employee --http-method POST --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $employee --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:createEmployee/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# PUT: /v1.0.0/payments/employee/{employeeId}
export employeeId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $employee --path-part "{employeeId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $employeeId --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $employeeId --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:updateEmployee/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# DELETE: /v1.0.0/payments/employee/{employeeId}
aws apigateway put-method --rest-api-id $restAPIId --resource-id $employeeId --http-method DELETE --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $employeeId --http-method DELETE --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:deleteEmployee/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

# GET: /v1.0.0/payments/employee/{employeeId}
aws apigateway put-method --rest-api-id $restAPIId --resource-id $employeeId --http-method GET --authorization-type NONE --api-key-required --region eu-west-2

aws apigateway put-integration --rest-api-id $restAPIId --resource-id $employeeId --http-method GET --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:getEmployee/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

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
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $erasurerequestid --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:cdp_erasure/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT



export reports=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $personaldataresource --path-part "reports" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export reporttype=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $reports --path-part "{reportType}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export requests=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $reporttype --path-part "requests" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export requestid=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $requests --path-part "{requestId}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

aws apigateway put-method --rest-api-id $restAPIId --resource-id $requestid --http-method PUT --authorization-type NONE --api-key-required --region eu-west-2 
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $requestid --http-method PUT --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:cdp_reportgeneration/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT

aws apigateway create-deployment --rest-api-id $restAPIId --stage-name test-primary --stage-description "Payment order Stage"

export apiKeyId=$(aws apigateway create-api-key --name ms-payment-order-sql-apikey --description "Payment order SQL API Key" --enabled | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export apiKeyValue=$(aws apigateway get-api-key --api-key $apiKeyId --include-value | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["value"]')

export API_KEY=$apiKeyValue
echo $API_KEY

# Create usage plan
export usagePlanId=$(aws apigateway create-usage-plan --name ms-payment-order-sql-usageplan --api-stages apiId=$restAPIId,stage=test-primary | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
aws apigateway create-usage-plan-key --usage-plan-id $usagePlanId --key-id $apiKeyId --key-type API_KEY

export API_BASE_URL=https://${restAPIId}.execute-api.eu-west-2.amazonaws.com/test-primary
echo $API_BASE_URL



# Creation MSSQL database in AWS environment
export rdsscriptpath="db/mssql/DDL.sql"
java -cp db/lib/microservice-package-aws-resources-DEV.0.0-SNAPSHOT.jar -Drds_instance_host=${host} -Drds_instance_port=${port} -Drds_instance_dbname=paymentorderMSsql -Drds_instance_username=${username} -Drds_instance_password=rootroot -Drds_script_path=${rdsscriptpath} -Drds_database=MSSQL  com.temenos.microservice.aws.rds.query.execution.AwsRdsScriptExecution
sleep 20
