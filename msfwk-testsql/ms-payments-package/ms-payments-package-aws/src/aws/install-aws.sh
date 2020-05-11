#!/bin/bash -x


# Setup the environment
export PATH=/opt/apache-maven-3.3.9/bin:/usr/bin:/usr/sbin:/usr/local/bin:$PATH
export MAVEN_OPTS="-Xmx2048m"


# Create Streams
aws kinesis create-stream --stream-name payment-inbox-topic --shard-count 1
aws kinesis create-stream --stream-name payment-inbox-error-topic --shard-count 1
aws kinesis create-stream --stream-name payment-outbox-topic --shard-count 1
aws kinesis create-stream --stream-name table-update-paymentorder --shard-count 1
aws kinesis create-stream --stream-name error-paymentorder --shard-count 1

sleep 10


# Create DB parameter group to grant lambda access privilege
aws rds create-db-cluster-parameter-group --db-cluster-parameter-group-name PaymentOrderPG --db-parameter-group-family aurora5.6 --description "Payment order parameter group"
sleep 10


# Modify aws_default_lambda_role in Parameter group
aws rds modify-db-cluster-parameter-group --db-cluster-parameter-group-name PaymentOrderPG --parameters 'ParameterName=aws_default_lambda_role,ParameterValue=arn:aws:iam::177642146375:role/rds_lambda_execution_role,ApplyMethod=immediate'
sleep 10


# Create Aurora-MySql DB Cluster
aws rds create-db-cluster --db-cluster-identifier PaymentOrderCluster --engine aurora --engine-version "5.6.10a" --port 3306 --master-username root --master-user-password rootroot --database-name payments --db-cluster-parameter-group-name PaymentOrderPG
sleep 400


# Associate Aurora-MySql DB Cluster to IAM role to provide the permission to execute lambda
aws rds add-role-to-db-cluster --db-cluster-identifier PaymentOrderCluster --role-arn arn:aws:iam::177642146375:role/rds_lambda_execution_role
sleep 30


# Create Aurora-MySql DB Instance
aws rds create-db-instance --db-instance-identifier PaymentOrderInstance --db-cluster-identifier PaymentOrderCluster --engine aurora --engine-version "5.6.10a" --db-instance-class db.t2.small --publicly-accessible
sleep 900


# Get Aurora-mysql DB Instance endpoint address
export host=$(aws rds describe-db-instances | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["DBInstances"] if "paymentorderinstance" == api["DBInstanceIdentifier"]]; print filter[0]["Endpoint"]["Address"]')

# Get Aurora-mysql DB Instance endpoint port
export port=$(aws rds describe-db-instances | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["DBInstances"] if "paymentorderinstance" == api["DBInstanceIdentifier"]]; print filter[0]["Endpoint"]["Port"]')

# Get Aurora-mysql DB name
export dbname=$(aws rds describe-db-instances | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["DBInstances"] if "paymentorderinstance" == api["DBInstanceIdentifier"]]; print filter[0]["DBName"]')

# Get Aurora-mysql DB master username
export username=$(aws rds describe-db-instances | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["DBInstances"] if "paymentorderinstance" == api["DBInstanceIdentifier"]]; print filter[0]["MasterUsername"]')

# Get Aurora-mysql DB instance arn
export dbinstancearn = $(aws rds describe-db-instances | python -c 'import json,sys;apis=json.load(sys.stdin); filter=[api for api in apis["DBInstances"] if "paymentorderinstance" == api["DBInstanceIdentifier"]]; print filter[0]["DBInstanceArn"]')



# upload files
aws s3 mb s3://ms-payment-order-sql
sleep 30
aws s3 cp app/ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar s3://ms-payment-order-sql --storage-class REDUCED_REDUNDANCY


# Create lambdas
aws lambda create-function --function-name payment-sql-create --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.CreateNewPaymentOrderFunctionAWS::invoke --description "Handler for SQL Create new payment order Impl" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.mysql.jdbc.Driver,DIALECT=org.hibernate.dialect.MySQL5InnoDBDialect,HOST=${host},PORT=${port},DATABASE_NAME=${dbname},DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:mysql://${host}:${port}/${dbname},temn_msf_security_authz_enabled=false,className_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=sql\}
sleep 10

aws lambda create-function --function-name payment-sql-get --runtime java8 --role arn:aws:iam::177642146375:role/lambda_basic_execution --handler com.temenos.microservice.payments.function.GetPaymentOrderFunctionAWS::invoke --description "Handler for SQL Get payment order Impl" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.mysql.jdbc.Driver,DIALECT=org.hibernate.dialect.MySQL5InnoDBDialect,HOST=${host},PORT=${port},DATABASE_NAME=${dbname},DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:mysql://${host}:${port}/${dbname},temn_msf_security_authz_enabled=false,className_GetPaymentOrder=com.temenos.microservice.payments.function.GetPaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false",class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,DATABASE_KEY=sql\}
sleep 10

aws lambda create-function --function-name payment-sql-inbox-ingester --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.InboxEventProcessorSql::handleRequest --description "Inbox Ingester Service" --timeout 120 --memory-size 512 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.mysql.jdbc.Driver,DIALECT=org.hibernate.dialect.MySQL5InnoDBDialect,HOST=${host},PORT=${port},DATABASE_NAME=${dbname},DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:mysql://${host}:${port}/${dbname},temn_msf_security_authz_enabled=false,EXECUTION_ENV=TEST,temn_msf_name=PaymentOrderService,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=payment-inbox-error-topic,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false",temn_msf_ingest_is_avro_event_ingester=false,DATABASE_KEY=sql,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl\}
sleep 10

aws lambda create-function --function-name inbox-sql-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.InboxHandlerSql::handleRequest --description "Listen inbox table and deliver the events to designated queue" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.mysql.jdbc.Driver,DIALECT=org.hibernate.dialect.MySQL5InnoDBDialect,HOST=${host},PORT=${port},DATABASE_NAME=${dbname},DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:mysql://${host}:${port}/${dbname},temn_msf_security_authz_enabled=false,EXECUTION_ENV=TEST,temn_msf_name=PaymentOrderService,DATABASE_KEY=sql,class_inbox_dao=com.temenos.microservice.framework.core.inbox.InboxDaoImpl,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_exec_env=serverless,class_package_name=com.temenos.microservice.payments.function,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false"\}
sleep 10

aws lambda create-function --function-name outbox-sql-handler --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.core.function.aws.OutboxHandlerSql::handleRequest --description "Listen outbox table and deliver the events to designated queue" --timeout 120 --memory-size 512 --publish --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.mysql.jdbc.Driver,DIALECT=org.hibernate.dialect.MySQL5InnoDBDialect,HOST=${host},PORT=${port},DATABASE_NAME=${dbname},DB_USERNAME=${username},DB_PASSWORD=rootroot,DB_CONNECTION_URL=jdbc:mysql://${host}:${port}/${dbname},temn_msf_security_authz_enabled=false,EXECUTION_ENV=TEST,temn_msf_name=PaymentOrderService,DATABASE_KEY=sql,OUTBOX_STREAM=payment-outbox-topic,class_outbox_dao=com.temenos.microservice.framework.core.outbox.OutboxDaoImpl,temn_exec_env=serverless,class_package_name=com.temenos.microservice.payments.function,temn_msf_function_class_CreateNewPaymentOrder=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl,VALIDATE_PAYMENT_ORDER="false"\}
sleep 10

aws lambda create-function --function-name payment-sql-configavro-ingester --runtime java8 --role arn:aws:iam::177642146375:role/lambda-kinesis-execution-role --handler com.temenos.microservice.framework.ingester.instance.KinesisEventProcessor::handleRequest --description "Ingester for payment-sql configavro Service" --timeout 120 --memory-size 512 --publish --tags FunctionType=Ingester,Service=Payment --code S3Bucket="ms-payment-order-sql",S3Key=ms-payments-package-aws-DEV.0.0-SNAPSHOT.jar --environment Variables=\{DRIVER_NAME=com.mysql.jdbc.Driver,DIALECT=org.hibernate.dialect.MySQL5InnoDBDialect,DB_CONNECTION_URL=jdbc:mysql://paymentorderinstance.cdbrg3shwmrx.eu-west-2.rds.amazonaws.com:3306/payments,DATABASE_NAME=payments,DB_USERNAME=root,DB_PASSWORD=rootroot,EXECUTION_ENV=TEST,temn_msf_name=PaymentOrderService,temn_msf_security_authz_enabled=false,temn_msf_stream_kinesis_region=eu-west-2,temn_msf_stream_vendor=kinesis,temn_exec_env=serverless,temn_msf_ingest_sink_error_stream=error-paymentorder,temn_msf_ingest_event_ingester=com.temenos.microservice.framework.core.ingester.MicroserviceIngester,PAYMENT_ORDEREvent=com.temenos.microservice.payments.ingester.PaymentorderIngesterUpdater,temn_ingester_mapping_enabled=false,temn_msf_ingest_source_stream=table-update-paymentorder,EXECUTION_ENVIRONMENT=TEST,HOST=paymentorderinstance.cdbrg3shwmrx.eu-west-2.rds.amazonaws.com,PORT=3306,temn_msf_schema_registry_url=\"Data,PAYMENT.ORDER\",DATABASE_KEY=sql\}
sleep 10

# Create event source mapping
aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/payment-inbox-topic --function-name payment-sql-inbox-ingester --enabled --batch-size 100 --starting-position LATEST
sleep 10

aws lambda create-event-source-mapping --event-source-arn arn:aws:kinesis:eu-west-2:177642146375:stream/table-update-paymentorder --function-name payment-sql-configavro-ingester --enabled --batch-size 100 --starting-position LATEST
sleep 10



# Create and add APIs to ApiGateway
export restAPIId=$(aws apigateway create-rest-api --name ms-payment-order-sql-api --description "Payment order SQL API" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
aws apigateway put-gateway-response --rest-api-id $restAPIId --response-type MISSING_AUTHENTICATION_TOKEN --status-code 404

export apiRootResourceId=$(aws apigateway get-resources --rest-api-id $restAPIId | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["items"][-1]["id"]')

export paymentsId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $apiRootResourceId --path-part "payments" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')

export ordersId=$(aws apigateway create-resource --rest-api-id $restAPIId --parent-id $paymentsId --path-part "orders" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["id"]')
aws apigateway put-method --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --authorization-type NONE --api-key-required --region eu-west-2
aws apigateway put-integration --rest-api-id $restAPIId --resource-id $ordersId --http-method POST --type AWS_PROXY --uri arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:177642146375:function:payment-sql-create/invocations --credentials arn:aws:iam::177642146375:role/apigatewayrole --integration-http-method POST --content-handling CONVERT_TO_TEXT
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



# Creation of Tables [DDL] & Triggers [DML] & Stored Procedures [DML] via script file execution on Aurora-MySql database in AWS environment
export rdsscriptpath="db/sql/DDL.sql"
java -cp db/lib/microservice-package-aws-resources-DEV.0.0-SNAPSHOT.jar -Drds_instance_host=${host} -Drds_instance_port=${port} -Drds_instance_dbname=${dbname} -Drds_instance_username=${username} -Drds_instance_password=rootroot -Drds_script_path=${rdsscriptpath} com.temenos.microservice.aws.rds.query.execution.AwsRdsScriptExecution
sleep 20