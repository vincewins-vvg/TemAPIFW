@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo on

CALL db/repackbuild.bat ms-paymentorder postgresql

REM Resource Group configuration details
SET RESOURCE_GROUP_NAME="paymentorderPostgres"
SET LOCATION="UK South"
SET DB_NAME_SPACE="paymentordernosql"
SET DB_NAME="paymentorder"
SET APP_NAME="paymentorderapp"
SET AVRO_APP_NAME="paymentorderavroapp"
SET EVENT_APP_NAME="paymentordereventapp"
SET COMMAND_EVENT_NAME="paymentordercommandapp"
SET OUTBOX_LISTENER_APP_NAME="paymentorderapplistener"
SET SCRIPT_FILE_PATH="target/azure-functions/%APP_NAME%/DDL.cql"
SET JAVA_OPTS="-Djava.net.preferIPv4Stack=true"


REM Class Implementation
SET PAYMENT_ORDER_CURRENCY="com.temenos.microservice.paymentorder.function.GetPaymentOrderCurrencyImpl"
SET CREATE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.CreateReferenceDataImpl"
SET GET_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataImpl"
SET UPDATE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.UpdateReferenceDataImpl"
SET ADD_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.AddReferenceDataImpl"
SET DELETE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.DeleteReferenceDataImpl"
SET UPDATE_STATUS="com.temenos.microservice.paymentorder.function.UpdatePaymentStatusImpl"
SET DELETE_CONDITION="com.temenos.microservice.paymentorder.function.DeleteWithConditionImpl"
SET CREATE_USER="com.temenos.microservice.paymentorder.function.CreateUserImpl"
SET GET_USER="com.temenos.microservice.paymentorder.function.GetUserImpl"
SET CREATE_ACCOUNT="com.temenos.microservice.paymentorder.function.CreateAccountImpl"
SET GET_ACCOUNT="com.temenos.microservice.paymentorder.function.GetAccountImpl"
SET DELETE_ACCOUNT="com.temenos.microservice.paymentorder.function.DeleteAccountImpl"
SET UPDATE_ACCOUNT="com.temenos.microservice.paymentorder.function.UpdateAccountImpl"
SET CREATE_CUSTOMER="com.temenos.microservice.paymentorder.function.CreateCustomerImpl"
SET GET_CUSTOMER="com.temenos.microservice.paymentorder.function.GetCustomerImpl"
SET GET_INPUT_VALIDATION="com.temenos.microservice.paymentorder.function.GetInputValidationImpl"
SET SEARCH_USERS="com.temenos.microservice.paymentorder.function.SearchUsersImpl"
SET GET_ACCOUNT_VALIDATE="com.temenos.microservice.payments.function.GetAccountValidateImpl"
SET CREATEPAYMENT="com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl"
SET GETpaymentorder="com.temenos.microservice.paymentorder.function.GetPaymentOrdersImpl"
SET UPDATEPAYMENT="com.temenos.microservice.paymentorder.function.UpdatePaymentOrderImpl"
SET GETPAYMENT="com.temenos.microservice.paymentorder.function.GetPaymentOrderImpl"
SET INVEPAYMENT="com.temenos.microservice.paymentorder.function.InvokePaymentOrderImpl"
SET HEATHCHECK="com.temenos.microservice.framework.core.function.camel.GetHealthCheckImpl"
SET FILE_UPLOAD="com.temenos.microservice.paymentorder.function.FileUploadImpl"
SET FILE_DOWNLOAD="com.temenos.microservice.paymentorder.function.FileDownloadImpl"
SET DOINPUTVALIDATION="com.temenos.microservice.paymentorder.function.DoInputValidationImpl"
SET PAYMENT_SCHEDULER="com.temenos.microservice.paymentorder.scheduler.PaymentOrderScheduler"
SET DELETE_PAYMENTORDER="com.temenos.microservice.paymentorder.function.DeletePaymentOrderImpl"
SET FILE_DELETE="com.temenos.microservice.payments.function.FileDeleteImpl"
 

REM Postgres DB PROPERTIES
SET DATABASE_KEY="postgresql"
SET DATABASE_USERNAME="myadmin"
SET DATABASE_NAME="paymentorder"
SET DATABASE_PASSWORD="Passw0rd!"
SET DATABASE_CONNECTIONURL="jdbc:postgresql://paymentordernosql.postgres.database.azure.com:5432/paymentorder"
SET SUBSCRIPTION_ID=""

REM Hub Properties
SET MSF_NAME="ms-paymentorder"
SET EVENT_HUB_NAME_SPACE="postgres-kafka"
SET EVENT_HUB="ms-paymentorder-inbox-topic"

SET ERROR_STREAM="error-paymentorder"
SET EVENT_HUB_CG="paymentordercg"
SET EVENT_HUB_OUTBOX="ms-paymentorder-outbox-topic"
SET EVENT_HUB_OUTBOX_CG="paymentorderoutboxcg"
SET EVENT_HUB_INBOX_CG="paymentorderinboxcg"
SET EVENT_HUB_AVRO_CG="paymentorderavrocg"
SET EVENT_HUB_EVENT_CG="paymentordereventcg"
SET REGISTRY_URL="IF.EVENTS.INTERFACE.TABLE,Data"

SET eventHubConnection="TEST"
SET AVRO_INGEST_EVENT="false"

REM Inbox and outbox configurations

SET EVENT_HUB_INBOX_TOPIC="ms-paymentorder-inbox-topic"
SET EVENT_HUB_EVENT_TOPIC="paymentorder-event-topic"
SET EVENT_HUB_AVRO_TOPIC="table-update-paymentorder"

REM Ingester and Inbox/outbox related config 
SET INGEST_SOURCE_STREAM="ms-paymentorder-inbox-topic"
SET INGEST_EVENT_INGESTER="com.temenos.microservice.framework.core.ingester.MicroserviceIngester"
SET GENERIC_INGESTER="com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester"
SET COMMAND_GENERIC_INGESTER="com.temenos.microservice.paymentorder.ingester.POCommandIngester"
SET INBOXOUTBOX_INGESTER="com.temenos.microservice.framework.core.ingester.MSKafkaOutboxEventListener"
SET ERROR_STREAM="error-paymentorder"
SET VALIDATE_PAYMENT_ORDER="false"
SET OUTBOX_TOPIC="ms-paymentorder-outbox-topic"
SET SINK_ERROR_STREAM="ms-paymentorder-inbox-error-topic"
SET INBOX_DAO="com.temenos.microservice.framework.core.inbox.InboxDaoImpl"
SET OUTBOX_DAO="com.temenos.microservice.framework.core.outbox.OutboxDaoImpl"
SET PACKAGE_NAME="com.temenos.microservice.paymentorder.function"
SET CreateNewPaymentOrder="com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl"


REM KAFKA Properties
SET QUEUE_IMPL="kafka"
SET KAFKA_SERVER="postgres-kafka.servicebus.windows.net:9093"
SET SSL_ENABLED="true"
SET MAX_POLL_RECORDS=20
SET SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://postgres-kafka.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=yUoa/1dlVqghGSUhf3YWUH5v7sbz9stw5ozyk8MaCx8=\";"
SET STREM_SSL_ENABLED="true"
SET STREAM_KAFKA_PROTOCOL=SASL_SSL
SET STREAM_KAFKA_SASL_MECHANISM=PLAIN

SET NOSQL_INBOX_CLEANUP_SCHEDULER_TIME="0 0/5 * * * *"
SET INBOX_CLEANUP_MINUTES="60"
SET NOSQL_INBOX_SCHEDULER="com.temenos.microservice.framework.scheduler.core.NoSqlInboxCatchupProcessor"


REM Token and Authz config

SET PDP_CONFIG_FILE="classpath:xacml/paymentorder-pdp-config.xml"
SET AUTHZ_ENABLED="false"
SET ms_security_tokencheck_enabled=Y
SET ms_security_tokencheck_command_enabled=N
SET JWT_TOKEN_PRINCIPAL_CLAIM="sub"
SET JWT_TOKEN_ISSUER="https://localhost:9443/oauth2/token"
SET ID_TOKEN_SIGNED="true"
SET JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
SET ENTITLEMENT_STUBBED_SERVICE_ENABLED="true"

REM File Upload
SET RESOURCE_STORAGE_NAME="paymentorderpostgres"
SET RESOURCE_STORAGE_HOME="blob://paymentorder"
SET MAX_FILE_UPLOAD_SIZE=70
SET SCHEDULER_TIME="0 */50 * * * *"

REM DB Migration
SET INITIATE_DBMIGRATION="com.temenos.microservice.framework.dbmigration.core.InitiateDbMigrationImpl"
SET GET_DBMIGRATION="com.temenos.microservice.framework.dbmigration.core.GetDbMigrationStatusImpl"
SET CLOUD_EVENT_FLAG="true" 

REM OTHERS CONFIG
SET ENVIRONMENT_CONF=test
SET METER_DISABLE="true"
SET TRACER_ENABLED="false"
SET EXECUTION_ENV="TEST"
SET EXEC_ENV="serverless"
SET EXECUTION_ENVIRONMENT="TEST"
SET DB_CONNECTION_MIN_POOL_SIZE=10
SET DB_CONNECTION_MAX_POOL_SIZE=150


rem SET INGESTER_APP_1="paymentinboxpinknosql"
rem SET INGESTER_APP_2="paymenteventpinknosql"
SET JAR_NAME="ms-paymentorder"
SET JAR_VERSION="DEV.0.0-SNAPSHOT"
SET EVENT_HUB_COMMAND_EVENT_CG="paymentordercommandeventcg"
SET EVENT_HUB_COMMAND_EVENT_TOPIC="paymentorder-inbox-topic"

SET EVENTDIRECTLYDELIVERY="true"

call ingester_creator %APP_NAME% %JAR_NAME% %JAR_VERSION% 

call ingester_creator %APP_NAME% %AVRO_APP_NAME% %JAR_NAME% %JAR_VERSION% 

call ingester_creator %APP_NAME% %EVENT_APP_NAME% %JAR_NAME% %JAR_VERSION% 

call ingester_creator %APP_NAME% %COMMAND_EVENT_NAME% %JAR_NAME% %JAR_VERSION% 


REM Create postgres server and database properties

call az group create --name %RESOURCE_GROUP_NAME% --location %LOCATION%

call az postgres flexible-server create --public-access all --resource-group %RESOURCE_GROUP_NAME% --name %DB_NAME_SPACE% --location "UK South" --admin-user %DATABASE_USERNAME% --admin-password %DATABASE_PASSWORD% --sku-name Standard_D4s_v3 --tier GeneralPurpose --version 13

call az postgres flexible-server db create --resource-group %RESOURCE_GROUP_NAME% --database-name %DB_NAME% --server-name %DB_NAME_SPACE%

call az postgres flexible-server firewall-rule create --resource-group %RESOURCE_GROUP_NAME% --name %DB_NAME_SPACE% --rule-name allowip --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255


REM Create app/InboxoutboxListenerApp/Ingester App1 

if NOT [%SUBSCRIPTION_ID%] == [] ( call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%APP_NAME% -Dsubscription.id=%SUBSCRIPTION_ID% -f pom-azure-deploy.xml -X ) else ( call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%APP_NAME% -f pom-azure-deploy.xml -X )


if NOT [%SUBSCRIPTION_ID%] == [] ( call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%AVRO_APP_NAME% -Dsubscription.id=%SUBSCRIPTION_ID% -f pom-azure-deploy.xml -X ) else ( call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%AVRO_APP_NAME% -f pom-azure-deploy.xml -X )

if NOT [%SUBSCRIPTION_ID%] == [] ( call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%EVENT_APP_NAME% -Dsubscription.id=%SUBSCRIPTION_ID% -f pom-azure-deploy.xml -X ) else ( call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%EVENT_APP_NAME% -f pom-azure-deploy.xml -X )

if NOT [%SUBSCRIPTION_ID%] == [] ( call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%COMMAND_EVENT_NAME% -Dsubscription.id=%SUBSCRIPTION_ID% -f pom-azure-deploy.xml -X ) else ( call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%COMMAND_EVENT_NAME% -f pom-azure-deploy.xml -X )

rem OutboxListener function
if NOT [%SUBSCRIPTION_ID%] == [] ( call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%OUTBOX_LISTENER_APP_NAME% -Dsubscription.id=%SUBSCRIPTION_ID% -f pom-azure-deploy.xml -X ) else ( call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%OUTBOX_LISTENER_APP_NAME% -f pom-azure-deploy.xml -X )

REM PROPERTIES FOR TOPICS AND HUB NAME/CONSUMERGROUP NAME CREATION

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

call az eventhubs eventhub create --name %EVENT_HUB_AVRO_TOPIC% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

call az eventhubs eventhub create --name %EVENT_HUB_COMMAND_EVENT_TOPIC% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

call az eventhubs eventhub create --name %ERROR_STREAM% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%


rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_CG%

rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB_OUTBOX% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_OUTBOX_CG%

rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB_INBOX_TOPIC% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_INBOX_CG%

call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB_AVRO_TOPIC% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_AVRO_CG%


call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB_EVENT_TOPIC% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_EVENT_CG%

call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB_COMMAND_EVENT_TOPIC% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_COMMAND_EVENT_CG%

REM EVENT HUB CONNECTION STRING

Rem Reterive event hub connection string
call az eventhubs namespace authorization-rule keys list --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])" >> out.txt
set /p eventHubConnection=< out.txt
del out.txt

SET SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password='%eventHubConnection%';"

REM create new Storage
call az storage account create -n %RESOURCE_STORAGE_NAME% -g %RESOURCE_GROUP_NAME% -l %LOCATION% --sku Standard_LRS

rem Reterive storage account connection string
call az storage account show-connection-string -g %RESOURCE_GROUP_NAME% -n %RESOURCE_STORAGE_NAME% | python -c "import json,sys;apis=json.load(sys.stdin); print(apis['connectionString'])" >> out1.txt
set /p storageconnectionString=< out1.txt
set AZURE_STORAGE_CONNECTION_STRING=%storageconnectionString%
del out1.txt

REM CREATING APP/LISTENERS/INGESTERS APP
 
rem Environment variable settings
call az functionapp config appsettings set --name %APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETpaymentorder% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_deletePaymentOrder=%DELETE_PAYMENTORDER% className_invokepaymentordertate=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK% className_GetPaymentOrderCurrency=%PAYMENT_ORDER_CURRENCY% className_createReferenceData=%CREATE_REFERENCE_DATA% className_updateReferenceData=%UPDATE_REFERENCE_DATA% className_addReferenceData=%ADD_REFERENCE_DATA% className_deleteReferenceData=%DELETE_REFERENCE_DATA% className_UpdateStatus=%UPDATE_STATUS% className_DeleteWithCondition=%DELETE_CONDITION%  className_CreateUser=%CREATE_USER% className_GetUser=%GET_USER% className_CreateAccount=%CREATE_ACCOUNT% className_GetAccount=%GET_ACCOUNT% className_DeleteAccount=%DELETE_ACCOUNT% className_UpdateAccount=%UPDATE_ACCOUNT% className_createCustomer=%CREATE_CUSTOMER% className_getCustomers=%GET_CUSTOMER% className_GetInputValidation=%GET_INPUT_VALIDATION% className_searchUsers=%SEARCH_USERS% className_GetAccountValidate=%GET_ACCOUNT_VALIDATE% DATABASE_NAME=%DATABASE_NAME% DATABASE_KEY=%DATABASE_KEY% POSTGRESQL_CONNECTIONURL=%DATABASE_CONNECTIONURL% POSTGRESQL_USERNAME=%DATABASE_USERNAME% POSTGRESQL_PASSWORD=%DATABASE_PASSWORD% JAVA_OPTS=%JAVA_OPTS% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB% eventHubConsumerGroup=%EVENT_HUB_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.sink.error.stream=%SINK_ERROR_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER% temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% className_FileDelete=%FILE_DELETE% ms_security_tokencheck_enabled=%ms_security_tokencheck_enabled% EXECUTION_ENVIRONMENT=%EXECUTION_ENVIRONMENT% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME% className_paymentscheduler=%PAYMENT_SCHEDULER% temn.entitlement.stubbed.service.enabled=%ENTITLEMENT_STUBBED_SERVICE_ENABLED%  operationId=paymentscheduler className_initiateDbMigration=%INITIATE_DBMIGRATION% className_getDbMigrationStatus=%GET_DBMIGRATION% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% temn.keystore.database.url=%DATABASE_CONNECTIONURL% temn.keystore.database.driver=org.postgresql.Driver temn.keystore.database.user=%DATABASE_USERNAME% temn.keystore.database.password=%DATABASE_PASSWORD% temn.msf.stream.kafka.ssl.enabled=%STREM_SSL_ENABLED% temn.msf.stream.security.kafka.security.protocol=%STREAM_KAFKA_PROTOCOL% temn.msf.stream.kafka.sasl.mechanism=%STREAM_KAFKA_SASL_MECHANISM% SqlInboxCleanupSchedulerTime=%SQL_INBOX_CLEANUP_SCHEDULER_TIME% className_sqlinboxcleanup=%SQL_INBOX_SCHEDULER% temn.msf.scheduler.inboxcleanup.schedule=%INBOX_CLEANUP_MINUTES% ENVIRONMENT_CONF=%ENVIRONMENT_CONF% operationId=paymentscheduler temn.meter.disabled=%METER_DISABLE% temn.msf.tracer.enabled=%TRACER_ENABLED% schedulerTime=%SCHEDULER_TIME% className_DoInputValidation=%DOINPUTVALIDATION% className_ReprocessEvents=com.temenos.microservice.framework.core.error.function.ReprocessEventsImpl className_GetErrorEvents=com.temenos.microservice.framework.core.error.function.GetErrorEventsImpl temn.msf.ingest.reprocess.source.stream=reprocess-event  temn.msf.outbox.direct.delivery.enabled=%EVENTDIRECTLYDELIVERY%


call az functionapp config appsettings set --name %COMMAND_EVENT_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETpaymentorder% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_deletePaymentOrder=%DELETE_PAYMENTORDER% className_invokepaymentordertate=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK% className_GetPaymentOrderCurrency=%PAYMENT_ORDER_CURRENCY% className_createReferenceData=%CREATE_REFERENCE_DATA% className_updateReferenceData=%UPDATE_REFERENCE_DATA% className_addReferenceData=%ADD_REFERENCE_DATA% className_deleteReferenceData=%DELETE_REFERENCE_DATA% className_UpdateStatus=%UPDATE_STATUS% className_DeleteWithCondition=%DELETE_CONDITION%  className_CreateUser=%CREATE_USER% className_GetUser=%GET_USER% className_CreateAccount=%CREATE_ACCOUNT% className_GetAccount=%GET_ACCOUNT% className_DeleteAccount=%DELETE_ACCOUNT% className_UpdateAccount=%UPDATE_ACCOUNT% className_createCustomer=%CREATE_CUSTOMER% className_getCustomers=%GET_CUSTOMER% className_GetInputValidation=%GET_INPUT_VALIDATION% className_searchUsers=%SEARCH_USERS% className_GetAccountValidate=%GET_ACCOUNT_VALIDATE% DATABASE_NAME=%DATABASE_NAME% DATABASE_KEY=%DATABASE_KEY% POSTGRESQL_CONNECTIONURL=%DATABASE_CONNECTIONURL% POSTGRESQL_USERNAME=%DATABASE_USERNAME% POSTGRESQL_PASSWORD=%DATABASE_PASSWORD% JAVA_OPTS=%JAVA_OPTS% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB% eventHubConsumerGroup=%EVENT_HUB_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.sink.error.stream=%SINK_ERROR_STREAM% temn.msf.ingest.generic.ingester=%COMMAND_GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER% temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% className_FileDelete=%FILE_DELETE% ms_security_tokencheck_enabled=%ms_security_tokencheck_command_enabled% EXECUTION_ENVIRONMENT=%EXECUTION_ENVIRONMENT% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME% className_paymentscheduler=%PAYMENT_SCHEDULER% temn.entitlement.stubbed.service.enabled=%ENTITLEMENT_STUBBED_SERVICE_ENABLED%  operationId=paymentscheduler className_initiateDbMigration=%INITIATE_DBMIGRATION% className_getDbMigrationStatus=%GET_DBMIGRATION% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% temn.keystore.database.url=%DATABASE_CONNECTIONURL% temn.keystore.database.driver=org.postgresql.Driver temn.keystore.database.user=%DATABASE_USERNAME% temn.keystore.database.password=%DATABASE_PASSWORD% temn.msf.stream.kafka.ssl.enabled=%STREM_SSL_ENABLED% temn.msf.stream.security.kafka.security.protocol=%STREAM_KAFKA_PROTOCOL% temn.msf.stream.kafka.sasl.mechanism=%STREAM_KAFKA_SASL_MECHANISM% SqlInboxCleanupSchedulerTime=%SQL_INBOX_CLEANUP_SCHEDULER_TIME% className_sqlinboxcleanup=%SQL_INBOX_SCHEDULER% temn.msf.scheduler.inboxcleanup.schedule=%INBOX_CLEANUP_MINUTES% ENVIRONMENT_CONF=%ENVIRONMENT_CONF% operationId=paymentscheduler temn.meter.disabled=%METER_DISABLE% temn.msf.tracer.enabled=%TRACER_ENABLED% schedulerTime=%SCHEDULER_TIME% className_DoInputValidation=%DOINPUTVALIDATION% className_ReprocessEvents=com.temenos.microservice.framework.core.error.function.ReprocessEventsImpl className_GetErrorEvents=com.temenos.microservice.framework.core.error.function.GetErrorEventsImpl temn.msf.ingest.reprocess.source.stream=reprocess-event  temn.msf.outbox.direct.delivery.enabled=%EVENTDIRECTLYDELIVERY%


call az functionapp config appsettings set --name %AVRO_APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings DATABASE_NAME=%DATABASE_NAME% DATABASE_KEY=%DATABASE_KEY% POSTGRESQL_CONNECTIONURL=%DATABASE_CONNECTIONURL% POSTGRESQL_USERNAME=%DATABASE_USERNAME% POSTGRESQL_PASSWORD=%DATABASE_PASSWORD% JAVA_OPTS=%JAVA_OPTS% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB_AVRO_TOPIC% eventHubConsumerGroup=%EVENT_HUB_AVRO_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER% temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% temn.msf.ingest.is.avro.event.ingester=true className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% className_FileDelete=%FILE_DELETE% ms_security_tokencheck_enabled=%ms_security_tokencheck_enabled% EXECUTION_ENVIRONMENT=%EXECUTION_ENVIRONMENT% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME% className_paymentscheduler=%PAYMENT_SCHEDULER% temn.entitlement.stubbed.service.enabled=%ENTITLEMENT_STUBBED_SERVICE_ENABLED%  operationId=paymentscheduler className_initiateDbMigration=%INITIATE_DBMIGRATION% className_getDbMigrationStatus=%GET_DBMIGRATION% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% temn.keystore.database.url=%DATABASE_CONNECTIONURL% temn.keystore.database.driver=org.postgresql.Driver temn.keystore.database.user=%DATABASE_USERNAME% temn.keystore.database.password=%DATABASE_PASSWORD% temn.msf.stream.kafka.ssl.enabled=%STREM_SSL_ENABLED% temn.msf.stream.security.kafka.security.protocol=%STREAM_KAFKA_PROTOCOL% temn.msf.stream.kafka.sasl.mechanism=%STREAM_KAFKA_SASL_MECHANISM% SqlInboxCleanupSchedulerTime=%SQL_INBOX_CLEANUP_SCHEDULER_TIME% className_sqlinboxcleanup=%SQL_INBOX_SCHEDULER% temn.msf.scheduler.inboxcleanup.schedule=%INBOX_CLEANUP_MINUTES% ENVIRONMENT_CONF=%ENVIRONMENT_CONF% operationId=paymentscheduler temn.meter.disabled=%METER_DISABLE% temn.msf.tracer.enabled=%TRACER_ENABLED% schedulerTime=%SCHEDULER_TIME% className_DoInputValidation=%DOINPUTVALIDATION% temn.msf.ingest.event.ingester=com.temenos.microservice.framework.core.ingester.MicroserviceIngester PAYMENT_ORDEREvent=com.temenos.microservice.paymentorder.ingester.PaymentorderIngesterUpdater  temn.msf.outbox.direct.delivery.enabled=%EVENTDIRECTLYDELIVERY%



call az functionapp config appsettings set --name %EVENT_APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings DATABASE_NAME=%DATABASE_NAME% DATABASE_KEY=%DATABASE_KEY% POSTGRESQL_CONNECTIONURL=%DATABASE_CONNECTIONURL% POSTGRESQL_USERNAME=%DATABASE_USERNAME% POSTGRESQL_PASSWORD=%DATABASE_PASSWORD% JAVA_OPTS=%JAVA_OPTS% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB_EVENT_TOPIC% eventHubConsumerGroup=%EVENT_HUB_EVENT_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER% temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% temn.msf.ingest.is.avro.event.ingester=false className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% className_FileDelete=%FILE_DELETE% ms_security_tokencheck_enabled=%ms_security_tokencheck_enabled% EXECUTION_ENVIRONMENT=%EXECUTION_ENVIRONMENT% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME% className_paymentscheduler=%PAYMENT_SCHEDULER% temn.entitlement.stubbed.service.enabled=%ENTITLEMENT_STUBBED_SERVICE_ENABLED%  operationId=paymentscheduler className_initiateDbMigration=%INITIATE_DBMIGRATION% className_getDbMigrationStatus=%GET_DBMIGRATION% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% temn.keystore.database.url=%DATABASE_CONNECTIONURL% temn.keystore.database.driver=org.postgresql.Driver temn.keystore.database.user=%DATABASE_USERNAME% temn.keystore.database.password=%DATABASE_PASSWORD% temn.msf.stream.kafka.ssl.enabled=%STREM_SSL_ENABLED% temn.msf.stream.security.kafka.security.protocol=%STREAM_KAFKA_PROTOCOL% temn.msf.stream.kafka.sasl.mechanism=%STREAM_KAFKA_SASL_MECHANISM% SqlInboxCleanupSchedulerTime=%SQL_INBOX_CLEANUP_SCHEDULER_TIME% className_sqlinboxcleanup=%SQL_INBOX_SCHEDULER% temn.msf.scheduler.inboxcleanup.schedule=%INBOX_CLEANUP_MINUTES% ENVIRONMENT_CONF=%ENVIRONMENT_CONF% operationId=paymentscheduler temn.meter.disabled=%METER_DISABLE% temn.msf.tracer.enabled=%TRACER_ENABLED% schedulerTime=%SCHEDULER_TIME% className_DoInputValidation=%DOINPUTVALIDATION% temn.msf.ingest.event.ingester=com.temenos.microservice.framework.core.ingester.MicroserviceIngester PAYMENT_ORDEREvent=com.temenos.microservice.paymentorder.ingester.PaymentorderIngesterUpdater temn.msf.ingest.event.processor=com.temenos.microservice.paymentorder.ingester.EventHandlerImpl temn.msf.ingest.event.processor.POAccepted=com.temenos.microservice.paymentorder.ingester.PoHandlerImpl  temn.msf.outbox.direct.delivery.enabled=%EVENTDIRECTLYDELIVERY%


rem Environment variable settings
call az functionapp config appsettings set --name %OUTBOX_LISTENER_APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETpaymentorder% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_deletePaymentOrder=%DELETE_PAYMENTORDER% className_invokepaymentordertate=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK% className_GetPaymentOrderCurrency=%PAYMENT_ORDER_CURRENCY% className_createReferenceData=%CREATE_REFERENCE_DATA% className_updateReferenceData=%UPDATE_REFERENCE_DATA% className_addReferenceData=%ADD_REFERENCE_DATA% className_deleteReferenceData=%DELETE_REFERENCE_DATA% className_UpdateStatus=%UPDATE_STATUS% className_DeleteWithCondition=%DELETE_CONDITION% className_CreateUser=%CREATE_USER% className_GetUser=%GET_USER% className_CreateAccount=%CREATE_ACCOUNT% className_GetAccount=%GET_ACCOUNT% className_DeleteAccount=%DELETE_ACCOUNT% className_UpdateAccount=%UPDATE_ACCOUNT% className_createCustomer=%CREATE_CUSTOMER% className_getCustomers=%GET_CUSTOMER% className_GetInputValidation=%GET_INPUT_VALIDATION% className_searchUsers=%SEARCH_USERS% className_GetAccountValidate=%GET_ACCOUNT_VALIDATE% DATABASE_NAME=%DATABASE_NAME% DATABASE_KEY=%DATABASE_KEY% POSTGRESQL_CONNECTIONURL=%DATABASE_CONNECTIONURL% POSTGRESQL_USERNAME=%DATABASE_USERNAME% POSTGRESQL_PASSWORD=%DATABASE_PASSWORD%  temn.msf.security.authz.enabled=%AUTHZ_ENABLED% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB_OUTBOX% eventHubConsumerGroup=%EVENT_HUB_OUTBOX_CG%  temn.msf.ingest.sink.error.stream=%SINK_ERROR_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.generic.ingester=%INBOXOUTBOX_INGESTER% temn.exec.env=%EXEC_ENV% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER% temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% className_FileDelete=%FILE_DELETE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME% schedulerTime=%SCHEDULER_TIME%	className_paymentscheduler=%PAYMENT_SCHEDULER% temn.entitlement.stubbed.service.enabled=%ENTITLEMENT_STUBBED_SERVICE_ENABLED%  className_initiateDbMigration=%INITIATE_DBMIGRATION% className_getDbMigrationStatus=%GET_DBMIGRATION% temn.msf.ingest.is.cloud.event=%CLOUD_EVENT_FLAG% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% temn.keystore.database.url=%DATABASE_CONNECTIONURL% temn.keystore.database.password=%DATABASE_PASSWORD% temn.keystore.database.user=%DATABASE_USERNAME%  temn.msf.stream.security.kafka.security.protocol=%STREAM_KAFKA_PROTOCOL% temn.msf.stream.kafka.sasl.mechanism=%STREAM_KAFKA_SASL_MECHANISM% temn.meter.disabled=%METER_DISABLE% temn.msf.tracer.enabled=%TRACER_ENABLED% className_DoInputValidation=%DOINPUTVALIDATION% temn.msf.stream.kafka.ssl.enabled=%STREM_SSL_ENABLED% temn.keystore.database.driver=org.postgresql.Driver  operationId=paymentscheduler temn.msf.outbox.direct.delivery.enabled=%EVENTDIRECTLYDELIVERY%

Rem Command to execute DB scripts
call java -cp target/azure-functions/%APP_NAME%/lib/microservice-package-azure-resources-DEV.0.0-SNAPSHOT.jar -Drds_instance_host=%DATABASE_CONNECTIONURL% -Drds_instance_username=%DATABASE_USERNAME% -Drds_instance_password=%DATABASE_PASSWORD% -DScript_Path=db/postgresql/postgresqlinit.sql com.temenos.microservice.azure.query.execution.AzurePostgresqlScriptExecution