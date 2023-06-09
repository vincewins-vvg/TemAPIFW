@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo on
REM configuration details
SET RESOURCE_GROUP_NAME="oracle_test"
SET LOCATION="UK South"
SET DB_NAME_SPACE="oratest1"
SET DB_NAME="oratest1"
SET APP_NAME="paymentsappOracle"
SET OUTBOX_LISTENER_APP_NAME="paymentsapplistenerOracle"
SET CREATEPAYMENT="com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl"
SET GETPAYMENTS="com.temenos.microservice.payments.function.GetPaymentOrdersImpl"
SET UPDATEPAYMENT="com.temenos.microservice.payments.function.UpdatePaymentOrderImpl"
SET GETPAYMENT="com.temenos.microservice.payments.function.GetPaymentOrderImpl"
SET INVEPAYMENT="com.temenos.microservice.payments.function.InvokePaymentOrderImpl"
SET HEATHCHECK="com.temenos.microservice.framework.core.function.camel.GetHealthCheckImpl"
SET CREATE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.CreateReferenceDataImpl"
SET ADD_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.AddReferenceDataImpl"
SET UPDATE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.UpdateReferenceDataImpl"
SET GET_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataImpl"
SET DELETE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.DeleteReferenceDataImpl"
SET FILE_UPLOAD="com.temenos.microservice.payments.function.FileUploadImpl"
SET FILE_DOWNLOAD="com.temenos.microservice.payments.function.FileDownloadImpl"
SET FILE_DELETE="com.temenos.microservice.payments.function.FileDeleteImpl"
SET DOINPUTVALIDATION="com.temenos.microservice.payments.function.DoInputValidationImpl"
SET PAYMENT_SCHEDULER="com.temenos.microservice.payments.scheduler.PaymentOrderScheduler"
SET 	CREATE_EMPLOYEE=com.temenos.microservice.payments.function.CreateEmployeeImpl
SET GET_EMPLOYEE=com.temenos.microservice.payments.function.GetEmployeeImpl
SET UPDATE_EMPLOYEE=com.temenos.microservice.payments.function.UpdateEmployeeImpl
SET DELETE_EMPLOYEE=com.temenos.microservice.payments.function.DeleteEmployeeImpl
SET DATABASE_NAME="oratest1"
SET DB_PASSWORD="OraPasswd1"
SET ORACLE_SID=oratest1
SET DB_USERNAME="SYSTEM"
SET DB_ADMIN_USERNAME="oracle_admin"
SET DRIVER_NAME="oracle.jdbc.OracleDriver"
SET DIALECT="org.hibernate.dialect.Oracle8iDialect"
SET DB_CONNECTION_URL="jdbc:oracle:thin:@20.77.51.125:1521:oratest1"
SET JAVA_OPTS="-Djava.net.preferIPv4Stack=true"
SET defaultExecutablePath="C:\Program Files\Java\jdk1.8.0_261\jre\bin\java"
SET AUTHZ_ENABLED="false"
SET EVENT_HUB_NAME_SPACE="payments-Kafka"
SET EVENT_HUB_OUTBOX="PaymentOrder-outbox"
SET EVENT_HUB="payments"
SET EVENT_HUB_INBOX_TOPIC="PaymentOrder-inbox-topic"
SET EVENT_HUB_EVENT_TOPIC="PaymentOrder-event-topic"
SET EVENT_HUB_CG="paymentordercg"
SET EVENT_HUB_OUTBOX_CG="paymentorderoutboxcg"
SET eventHubConnection="TEST"
REM SET INGEST_EVENT_INGESTER="com.temenos.microservice.framework.core.ingester.MicroserviceIngester"
SET ERROR_STREAM="error-paymentorder"
SET MSF_NAME="PaymentOrder"
SET REGISTRY_URL="IF.EVENTS.INTERFACE.TABLE,Data"
SET EXECUTION_ENV="TEST"
SET VALIDATE_PAYMENT_ORDER="false"
SET INBOX_DAO="com.temenos.microservice.framework.core.inbox.InboxDaoImpl"
SET OUTBOX_DAO="com.temenos.microservice.framework.core.outbox.OutboxDaoImpl"
SET INGEST_SOURCE_STREAM="payments"
SET SINK_ERROR_STREAM="ms-paymentorder-inbox-error-topic"
SET GENERIC_INGESTER="com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester"
SET INBOXOUTBOX_INGESTER="com.temenos.microservice.framework.core.ingester.MSKafkaOutboxEventListener"
SET EXEC_ENV="serverless"
SET OUTBOX_TOPIC="ms-paymentorder-outbox-topic"
SET CreateNewPaymentOrder="com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl"
SET PACKAGE_NAME="com.temenos.microservice.payments.function"
SET AVRO_INGEST_EVENT="false"
SET QUEUE_IMPL="kafka"
SET KAFKA_SERVER="payments-kafka.servicebus.windows.net:9093"
SET SSL_ENABLED="true"
SET MAX_POLL_RECORDS=20
SET DB_CONNECTION_MIN_POOL_SIZE=1
SET DB_CONNECTION_MAX_POOL_SIZE=5
SET SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://payments-kafka.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=yUoa/1dlVqghGSUhf3YWUH5v7sbz9stw5ozyk8MaCx8=\";"
SET RESOURCE_STORAGE_NAME="paymentordersql"
SET RESOURCE_STORAGE_HOME="blob://paymentorder"
SET ms_security_tokencheck_enabled=Y
SET EXECUTION_ENVIRONMENT="TEST"
SET MAX_FILE_UPLOAD_SIZE=70
SET SCHEDULER_TIME="0 */50 * * * *"
SET JWT_TOKEN_PRINCIPAL_CLAIM="sub"
SET JWT_TOKEN_ISSUER="https://localhost:9443/oauth2/token"
SET ID_TOKEN_SIGNED="true"
SET JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
SET ENTITLEMENT_STUBBED_SERVICE_ENABLED="true"
SET INITIATE_DBMIGRATION="com.temenos.microservice.framework.dbmigration.core.InitiateDbMigrationImpl"
SET GET_DBMIGRATION="com.temenos.microservice.framework.dbmigration.core.GetDbMigrationImpl"


SET EVENT_HUB_CG="paymentordercg"
SET EVENT_HUB_OUTBOX_CG="paymentorderoutboxcg"
SET EVENT_HUB_EVENT_CG="paymentordereventcg"
SET EVENT_HUB_INBOX_CG="paymentorderinboxcg"

SET INGESTER_APP_1="paymentinbox"
SET INGESTER_APP_2="paymentevent"
SET JAR_NAME="ms-paymentorder"
SET JAR_VERSION="DEV.0.0-SNAPSHOT"

SET CLOUD_EVENT_FLAG="true"

SET SCRIPTPATH="db/initdb.sql"

SET EVENTDIRECTLYDELIVERY="true"


call ingester_creator %APP_NAME% %INGESTER_APP_1%,%INGESTER_APP_2% %JAR_NAME% %JAR_VERSION% 

rem Create a resource resourceGroupName
call az group create --name %RESOURCE_GROUP_NAME%   --location %LOCATION%

rem deployment azure package into azure enviornment //Payments App
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%APP_NAME% -f pom-azure-deploy.xml -X

rem OutboxListener function
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%OUTBOX_LISTENER_APP_NAME% -f pom-azure-deploy.xml -X 

rem deployment azure package into azure enviornment
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%INGESTER_APP_1% -f pom-azure-deploy.xml -X

rem OutboxListener function
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%INGESTER_APP_2% -f pom-azure-deploy.xml -X


rem Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.
call az eventhubs namespace create --name %EVENT_HUB_NAME_SPACE% --resource-group %RESOURCE_GROUP_NAME% -l %LOCATION% --enable-kafka true

rem Create an event hub. Specify a name for the event hub. //GENERIC_INGESTER
call az eventhubs eventhub create --name %EVENT_HUB% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

rem Outbox EventListener EventHub //Outbox Listener
call az eventhubs eventhub create --name %EVENT_HUB_OUTBOX% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

rem Create an event hub. Specify a name for the event hub. 
call az eventhubs eventhub create --name %EVENT_HUB_INBOX_TOPIC% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

rem Outbox EventListener EventHub //Outbox Listener
call az eventhubs eventhub create --name %EVENT_HUB_EVENT_TOPIC% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_CG%

rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB_OUTBOX% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_OUTBOX_CG%

rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB_INBOX_TOPIC% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_INBOX_CG%

rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB_EVENT_TOPIC% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_EVENT_CG%
rem Reterive event hub connection string
call az eventhubs namespace authorization-rule keys list --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])" >> out.txt
set /p eventHubConnection=< out.txt
del out.txt

rem create new Storage
call az storage account create -n %RESOURCE_STORAGE_NAME% -g %RESOURCE_GROUP_NAME% -l %LOCATION% --sku Standard_LRS

rem Reterive storage account connection string
call az storage account show-connection-string -g %RESOURCE_GROUP_NAME% -n %RESOURCE_STORAGE_NAME% | python -c "import json,sys;apis=json.load(sys.stdin); print(apis['connectionString'])" >> out1.txt
set /p storageconnectionString=< out1.txt
set AZURE_STORAGE_CONNECTION_STRING=%storageconnectionString%
del out1.txt

rem Environment variable settings
call az functionapp config appsettings set --name %APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETPAYMENTS% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokePaymentState=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK% DATABASE_NAME=%DATABASE_NAME% DB_CONNECTION_URL=%DB_CONNECTION_URL% DRIVER_NAME=%DRIVER_NAME% DIALECT=%DIALECT% DB_PASSWORD=%DB_PASSWORD% DB_USERNAME=%DB_USERNAME% JAVA_OPTS=%JAVA_OPTS% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB% eventHubConsumerGroup=%EVENT_HUB_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% DATABASE_KEY=sql temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.sink.error.stream=%SINK_ERROR_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% temn.msf.stream.outbox.topic=%OUTBOX_TOPIC% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER%  temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% className_createReferenceData=%CREATE_REFERENCE_DATA% className_getReferenceData=%GET_REFERENCE_DATA% JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% className_updateReferenceData=%UPDATE_REFERENCE_DATA% className_addReferenceData=%ADD_REFERENCE_DATA% className_FileDownload=%FILE_DOWNLOAD% className_FileDelete=%FILE_DELETE% className_FileUpload=%FILE_UPLOAD% className_deleteReferenceData=%DELETE_REFERENCE_DATA% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME%  ms_security_tokencheck_enabled=%ms_security_tokencheck_enabled% EXECUTION_ENVIRONMENT=%EXECUTION_ENVIRONMENT%  className_DoInputValidation=%DOINPUTVALIDATION% className_paymentscheduler=%PAYMENT_SCHEDULER% schedulerTime=%SCHEDULER_TIME% operationId=paymentscheduler className_CreateEmployee=%CREATE_EMPLOYEE% className_GetEmployee=%GET_EMPLOYEE% className_UpdateEmployee=%UPDATE_EMPLOYEE% className_DeleteEmployee=%DELETE_EMPLOYEE% temn.entitlement.stubbed.service.enabled=%ENTITLEMENT_STUBBED_SERVICE_ENABLED% className_initiateDbMigration=%INITIATE_DBMIGRATION% className_getDbMigration=%GET_DBMIGRATION% temn.msf.outbox.direct.delivery.enabled=%EVENTDIRECTLYDELIVERY%

rem Environment variable settings for paymentslistenerapp functionapp
call az functionapp config appsettings set --name %OUTBOX_LISTENER_APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETPAYMENTS% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokePaymentState=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK%  DATABASE_NAME=%DATABASE_NAME% DB_CONNECTION_URL=%DB_CONNECTION_URL% DRIVER_NAME=%DRIVER_NAME% DIALECT=%DIALECT% DB_PASSWORD=%DB_PASSWORD% DB_USERNAME=%DB_USERNAME% JAVA_OPTS=%JAVA_OPTS% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB_OUTBOX% eventHubConsumerGroup=%EVENT_HUB_OUTBOX_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% DATABASE_KEY=sql temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.sink.error.stream=%SINK_ERROR_STREAM% temn.msf.ingest.generic.ingester=%INBOXOUTBOX_INGESTER% temn.exec.env=%EXEC_ENV% temn.msf.stream.outbox.topic=%OUTBOX_TOPIC% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER%  temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% className_FileDownload=%FILE_DOWNLOAD% className_FileDelete=%FILE_DELETE% className_FileUpload=%FILE_UPLOAD% temn.msf.storage.home=%RESOURCE_STORAGE_HOME% temn.msf.ingest.is.cloud.event=%CLOUD_EVENT_FLAG% temn.msf.outbox.direct.delivery.enabled=%EVENTDIRECTLYDELIVERY%


call az functionapp config appsettings set --name %INGESTER_APP_1% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETPAYMENTS% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokePaymentState=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK% DATABASE_NAME=%DATABASE_NAME% DB_CONNECTION_URL=%DB_CONNECTION_URL% DRIVER_NAME=%DRIVER_NAME% DIALECT=%DIALECT% DB_PASSWORD=%DB_PASSWORD% DB_USERNAME=%DB_USERNAME% JAVA_OPTS=%JAVA_OPTS% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB_INBOX_TOPIC% eventHubConsumerGroup=%EVENT_HUB_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% DATABASE_KEY=sql temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.sink.error.stream=%SINK_ERROR_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% temn.msf.stream.outbox.topic=%OUTBOX_TOPIC% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER%  temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% className_createReferenceData=%CREATE_REFERENCE_DATA% className_getReferenceData=%GET_REFERENCE_DATA% JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% className_updateReferenceData=%UPDATE_REFERENCE_DATA% className_addReferenceData=%ADD_REFERENCE_DATA% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% className_deleteReferenceData=%DELETE_REFERENCE_DATA% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME%  ms_security_tokencheck_enabled=%ms_security_tokencheck_enabled% EXECUTION_ENVIRONMENT=%EXECUTION_ENVIRONMENT%  className_DoInputValidation=%DOINPUTVALIDATION% className_paymentscheduler=%PAYMENT_SCHEDULER% schedulerTime=%SCHEDULER_TIME% operationId=paymentscheduler eventHubConsumerGroup=%EVENT_HUB_INBOX_CG% temn.msf.outbox.direct.delivery.enabled=%EVENTDIRECTLYDELIVERY%


call az functionapp config appsettings set --name %INGESTER_APP_2% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETPAYMENTS% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokePaymentState=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK% DATABASE_NAME=%DATABASE_NAME% DB_CONNECTION_URL=%DB_CONNECTION_URL% DRIVER_NAME=%DRIVER_NAME% DIALECT=%DIALECT% DB_PASSWORD=%DB_PASSWORD% DB_USERNAME=%DB_USERNAME% JAVA_OPTS=%JAVA_OPTS% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB_EVENT_TOPIC% eventHubConsumerGroup=%EVENT_HUB_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% DATABASE_KEY=sql temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.sink.error.stream=%SINK_ERROR_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% temn.msf.stream.outbox.topic=%OUTBOX_TOPIC% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER%  temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% className_createReferenceData=%CREATE_REFERENCE_DATA% className_getReferenceData=%GET_REFERENCE_DATA% JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% className_updateReferenceData=%UPDATE_REFERENCE_DATA% className_addReferenceData=%ADD_REFERENCE_DATA% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% className_deleteReferenceData=%DELETE_REFERENCE_DATA% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME%  ms_security_tokencheck_enabled=%ms_security_tokencheck_enabled% EXECUTION_ENVIRONMENT=%EXECUTION_ENVIRONMENT%  className_DoInputValidation=%DOINPUTVALIDATION% className_paymentscheduler=%PAYMENT_SCHEDULER% schedulerTime=%SCHEDULER_TIME% operationId=paymentscheduler eventHubConsumerGroup=%EVENT_HUB_EVENT_CG% temn.msf.ingest.event.processor="com.temenos.microservice.paymentorder.ingester.EventHandlerImpl" temn.msf.ingest.event.processor.POAccepted="com.temenos.microservice.paymentorder.ingester.PoHandlerImpl" temn.msf.outbox.direct.delivery.enabled=%EVENTDIRECTLYDELIVERY%
