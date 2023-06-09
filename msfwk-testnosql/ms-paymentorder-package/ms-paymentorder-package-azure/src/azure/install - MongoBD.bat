@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo on

REM repacking db entity jar with api jar
CALL db/repackbuild.bat ms-paymentorder mongo

REM configuration details
SET RESOURCE_GROUP_NAME="paymentorder"
SET LOCATION="UK South"
SET DB_NAME_SPACE="paymentorderdb"
SET DB_NAME="ms_paymentorder"
SET APP_NAME="paymentorderapp"
SET INBOXOUTBOXAPPNAME="paymentorderapplistener"
SET SCRIPT_FILE_PATH="target/azure-functions/%APP_NAME%/DDL.cql"
SET EVENT_HUB_NAME_SPACE="PaymentOrder-Kafka"
SET EVENT_HUB="paymentorder"
SET EVENT_HUB_OUTBOX="PaymentOrder-outbox"
SET EVENT_HUB_CG="paymentordercg"
SET EVENT_HUB_OUTBOX_CG="paymentorderoutboxcg"
SET CASSANDRA_KEYSTORE_FILE_PATH="D:\Program Files\Java\zulu8.31.0.2-jre8.0.181-win_x64\lib\security\cacerts"
SET CASSANDRA_SSL="y"
SET CREATEPAYMENT="com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl"
SET GETpaymentorder="com.temenos.microservice.paymentorder.function.GetPaymentOrdersImpl"
SET UPDATEPAYMENT="com.temenos.microservice.paymentorder.function.UpdatePaymentOrderImpl"
SET GETPAYMENT="com.temenos.microservice.paymentorder.function.GetPaymentOrderImpl"
SET INVEPAYMENT="com.temenos.microservice.paymentorder.function.InvokePaymentOrderImpl"
SET HEATHCHECK="com.temenos.microservice.framework.core.function.camel.GetHealthCheckImpl"
SET FILE_UPLOAD="com.temenos.microservice.paymentorder.function.FileUploadImpl"
SET FILE_DOWNLOAD="com.temenos.microservice.paymentorder.function.FileDownloadImpl"
SET FILE_DELETE="com.temenos.microservice.paymentorder.function.FileDeleteImpl"
SET DOINPUTVALIDATION=com.temenos.microservice.paymentorder.function.DoInputValidationImpl
SET PAYMENT_SCHEDULER="com.temenos.microservice.paymentorder.scheduler.PaymentOrderScheduler"
SET DATABASE_KEY="mongodb"
SET eventHubConnection="TEST"
SET PDP_CONFIG_FILE="classpath:xacml/paymentorder-pdp-config.xml"
SET AUTHZ_ENABLED="false"
SET AVRO_INGEST_EVENT="false"
SET INGEST_EVENT_INGESTER="com.temenos.microservice.framework.core.ingester.MicroserviceIngester"
SET GENERIC_INGESTER="com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester"
SET INBOXOUTBOX_INGESTER="com.temenos.microservice.framework.core.ingester.MSKafkaOutboxEventListener"
SET ERROR_STREAM="error-paymentorder"
SET VALIDATE_PAYMENT_ORDER="false"
SET INBOX_DAO="com.temenos.microservice.framework.core.inbox.InboxDaoImpl"
SET OUTBOX_DAO="com.temenos.microservice.framework.core.outbox.OutboxDaoImpl"
SET PACKAGE_NAME="com.temenos.microservice.paymentorder.function"
SET CreateNewPaymentOrder="com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl"
SET MSF_NAME="PaymentOrder"
SET EXECUTION_ENV="TEST"
SET DATABASE_NAME="COSMOS"
SET EXEC_ENV="serverless"
SET QUEUE_IMPL="kafka"
SET KAFKA_SERVER="paymentorder-kafka.servicebus.windows.net:9093"
SET SSL_ENABLED="true"
SET MAX_POLL_RECORDS=20
SET SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://paymentorder-kafka.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=yUoa/1dlVqghGSUhf3YWUH5v7sbz9stw5ozyk8MaCx8=\";"
SET MONGODB_DBNAME="ms_paymentorder"
SET MONGODB_CONNECTIONSTR="mongodb://51.104.228.97:27017,51.104.228.97:27018,51.104.228.97:27019"
SET ms_security_tokencheck_enabled=Y
SET EXECUTION_ENVIRONMENT="TEST"
SET RESOURCE_STORAGE_NAME="paymentordernosql"
SET RESOURCE_STORAGE_HOME="blob://paymentorder"
SET MAX_FILE_UPLOAD_SIZE=70
SET SCHEDULER_TIME="0 */50 * * * *"

SET NOSQL_INBOX_CLEANUP_SCHEDULER_TIME="0 0/5 * * * *"
SET INBOX_CLEANUP_MINUTES="60"
SET NOSQL_INBOX_SCHEDULER="com.temenos.microservice.framework.scheduler.core.NoSqlInboxCatchupProcessor"

REM Appinit Variables
SET APPINT_NAME="paymentorderappinit"
SET TEM_APPINIT_DISABLEINBOX="true"
SET APPINIT_AUTHZ_ENABLED="false"
SET DB_AUTO_UPGRADE="N"

rem deployment azure package into azure enviornment
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%APP_NAME% -f pom-azure-deploy.xml -X

rem OutboxListener function
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%INBOXOUTBOXAPPNAME% -f pom-azure-deploy.xml -X

rem deploy appinit function app in to azure enviornment
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%APPINT_NAME% -f pom-azure-deploy.xml -X

rem Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.
call az eventhubs namespace create --name %EVENT_HUB_NAME_SPACE% --resource-group %RESOURCE_GROUP_NAME% -l %LOCATION% --enable-kafka true

rem Create an event hub. Specify a name for the event hub. 
call az eventhubs eventhub create --name %EVENT_HUB% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

rem Outbox EventListener EventHub //Outbox Listener
call az eventhubs eventhub create --name %EVENT_HUB_OUTBOX% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_CG%

rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB_OUTBOX% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_OUTBOX_CG%

rem Reterive event hub connection string 
call az eventhubs namespace authorization-rule keys list --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])" >> out.txt
set /p eventHubConnection=< out.txt
del out.txt

REM create new Storage
call az storage account create -n %RESOURCE_STORAGE_NAME% -g %RESOURCE_GROUP_NAME% -l %LOCATION% --sku Standard_LRS

REM Exporting master key from appinit function app
call az functionapp keys list -g %RESOURCE_GROUP_NAME% -n %APPINT_NAME% --query masterKey  >> out1.txt
SET /p MASTER_KEY=< out1.txt
del out1.txt

rem Reterive storage account connection string
call az storage account show-connection-string -g %RESOURCE_GROUP_NAME% -n %RESOURCE_STORAGE_NAME% | python -c "import json,sys;apis=json.load(sys.stdin); print(apis['connectionString'])" >> out1.txt
set /p storageconnectionString=< out1.txt
set AZURE_STORAGE_CONNECTION_STRING=%storageconnectionString%
del out1.txt

rem Environment variable settings
call az functionapp config appsettings set --name %APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETpaymentorder% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokepaymentordertate=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK% DATABASE_NAME=%DATABASE_NAME% DATABASE_KEY=%DATABASE_KEY% CASSANDRA_HOST=%HostName% CASSANDRA_KEYSPACE=%DB_NAME% CASSANDRA_KEYSTORE_FILE_PATH=%CASSANDRA_KEYSTORE_FILE_PATH% CASSANDRA_PASS=%Password% CASSANDRA_PORT=%Port% CASSANDRA_SSL=%CASSANDRA_SSL% CASSANDRA_USER=%Username% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% temn_msf_name=%MSF_NAME% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB% eventHubConsumerGroup=%EVENT_HUB_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER% temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% MONGODB_DBNAME=%MONGODB_DBNAME% MONGODB_CONNECTIONSTR=%MONGODB_CONNECTIONSTR% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% className_FileDelete=%FILE_DELETE% ms_security_tokencheck_enabled=%ms_security_tokencheck_enabled% EXECUTION_ENVIRONMENT=%EXECUTION_ENVIRONMENT% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME% className_DoInputValidation=%DOINPUTVALIDATION% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% className_paymentscheduler=%PAYMENT_SCHEDULER% schedulerTime=%SCHEDULER_TIME% operationId=paymentscheduler NoSqlInboxCleanupSchedulerTime=%NOSQL_INBOX_CLEANUP_SCHEDULER_TIME% className_nosqlinboxcleanup=%NOSQL_INBOX_SCHEDULER% temn.msf.scheduler.inboxcleanup.schedule=%INBOX_CLEANUP_MINUTES%

rem Environment variable settings
call az functionapp config appsettings set --name %INBOXOUTBOXAPPNAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETpaymentorder% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokepaymentordertate=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK% DATABASE_NAME=%DATABASE_NAME% DATABASE_KEY=%DATABASE_KEY% CASSANDRA_HOST=%HostName% CASSANDRA_KEYSPACE=%DB_NAME% CASSANDRA_KEYSTORE_FILE_PATH=%CASSANDRA_KEYSTORE_FILE_PATH% CASSANDRA_PASS=%Password% CASSANDRA_PORT=%Port% CASSANDRA_SSL=%CASSANDRA_SSL% CASSANDRA_USER=%Username% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% temn_msf_name=%MSF_NAME% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB_OUTBOX% eventHubConsumerGroup=%EVENT_HUB_OUTBOX_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.generic.ingester=%INBOXOUTBOX_INGESTER% temn.exec.env=%EXEC_ENV% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER% temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% MONGODB_DBNAME=%MONGODB_DBNAME% MONGODB_CONNECTIONSTR=%MONGODB_CONNECTIONSTR% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% className_FileDelete=%FILE_DELETE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME%

REM Set environment variables for appinit function app
call az functionapp config appsettings set --name %APPINT_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings MONGODB_DBNAME=%MONGODB_DBNAME% MONGODB_CONNECTIONSTR=%MONGODB_CONNECTIONSTR% DATABASE_KEY=%DATABASE_KEY% temn_msf_name=%MSF_NAME%  EXECUTION_ENV=%EXECUTION_ENV% DATABASE_NAME=%DATABASE_NAME% class_package_name=%PACKAGE_NAME% tem_msf_disableInbox=%TEM_APPINIT_DISABLEINBOX% temn_msf_security_authz_enabled=%APPINIT_AUTHZ_ENABLED% temn_msf_database_auto_upgrade=%DB_AUTO_UPGRADE%

timeout /t 10 /nobreak

REM Execute appinit api which internally creates tables and indexes for first time and also executes scripts for DB upgrade.
curl -H "Content-Type: application/json" -X POST https://%APPINT_NAME%.azurewebsites.net/api/v1.0.0/dbmigration?code=%MASTER_KEY%   
