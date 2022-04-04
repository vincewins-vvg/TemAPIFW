#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#
# repacking db entity jar with api jar
#./db/repackbuild.sh ms-paymentorder postgresql

# Resource Group configuration details
export RESOURCE_GROUP_NAME="paymentorderPostgres"
export LOCATION="UK South"
export DB_NAME_SPACE="paymentordernosql"
export DB_NAME="paymentorder"
export APP_NAME="paymentorderapp"
export OUTBOX_LISTENER_APP_NAME="paymentorderapplistener"
export SCRIPT_FILE_PATH="db/postgresql/postgresqlinit.sql"
export JAVA_OPTS="-Djava.net.preferIPv4Stack=true"


# Class Implementation
export PAYMENT_ORDER_CURRENCY="com.temenos.microservice.paymentorder.function.GetPaymentOrderCurrencyImpl"
export CREATE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.CreateReferenceDataImpl"
export GET_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataImpl"
export UPDATE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.UpdateReferenceDataImpl"
export ADD_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.AddReferenceDataImpl"
export DELETE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.DeleteReferenceDataImpl"
export UPDATE_STATUS="com.temenos.microservice.paymentorder.function.UpdatePaymentStatusImpl"
export DELETE_CONDITION="com.temenos.microservice.paymentorder.function.DeleteWithConditionImpl"
export CREATE_USER="com.temenos.microservice.paymentorder.function.CreateUserImpl"
export GET_USER="com.temenos.microservice.paymentorder.function.GetUserImpl"
export CREATE_ACCOUNT="com.temenos.microservice.paymentorder.function.CreateAccountImpl"
export GET_ACCOUNT="com.temenos.microservice.paymentorder.function.GetAccountImpl"
export DELETE_ACCOUNT="com.temenos.microservice.paymentorder.function.DeleteAccountImpl"
export UPDATE_ACCOUNT="com.temenos.microservice.paymentorder.function.UpdateAccountImpl"
export CREATE_CUSTOMER="com.temenos.microservice.paymentorder.function.CreateCustomerImpl"
export GET_CUSTOMER="com.temenos.microservice.paymentorder.function.GetCustomerImpl"
export GET_INPUT_VALIDATION="com.temenos.microservice.paymentorder.function.GetInputValidationImpl"
export SEARCH_USERS="com.temenos.microservice.paymentorder.function.SearchUsersImpl"
export GET_ACCOUNT_VALIDATE="com.temenos.microservice.payments.function.GetAccountValidateImpl"
export CREATEPAYMENT="com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl"
export GETpaymentorder="com.temenos.microservice.paymentorder.function.GetPaymentOrdersImpl"
export UPDATEPAYMENT="com.temenos.microservice.paymentorder.function.UpdatePaymentOrderImpl"
export GETPAYMENT="com.temenos.microservice.paymentorder.function.GetPaymentOrderImpl"
export INVEPAYMENT="com.temenos.microservice.paymentorder.function.InvokePaymentOrderImpl"
export HEATHCHECK="com.temenos.microservice.framework.core.function.camel.GetHealthCheckImpl"
export FILE_UPLOAD="com.temenos.microservice.paymentorder.function.FileUploadImpl"
export FILE_DOWNLOAD="com.temenos.microservice.paymentorder.function.FileDownloadImpl"
export DOINPUTVALIDATION="com.temenos.microservice.paymentorder.function.DoInputValidationImpl"
export PAYMENT_SCHEDULER="com.temenos.microservice.paymentorder.scheduler.PaymentOrderScheduler"
export DELETE_PAYMENTORDER="com.temenos.microservice.paymentorder.function.DeletePaymentOrderImpl"
export FILE_DELETE="com.temenos.microservice.payments.function.FileDeleteImpl"
 

# Postgres DB PROPERTIES
export DATABASE_KEY="postgresql"
export DATABASE_USERNAME="myadmin"
export DATABASE_PASSWORD="Passw0rd!"
export DATABASE_CONNECTIONURL="jdbc:postgresql://$DB_NAME_SPACE.postgres.database.azure.com:5432/$DB_NAME"
export SUBSCRIPTION_ID=""

# Hub Properties
export MSF_NAME="ms-paymentorder"
export EVENT_HUB_NAME_SPACE="postgres-kafka"
export EVENT_HUB="ms-paymentorder-inbox-topic"

export ERROR_STREAM="error-paymentorder"
export EVENT_HUB_CG="paymentordercg"
export EVENT_HUB_OUTBOX="ms-paymentorder-outbox-topic"
export EVENT_HUB_OUTBOX_CG="paymentorderoutboxcg"
export EVENT_HUB_INBOX_CG="paymentorderinboxcg"
export REGISTRY_URL="IF.EVENTS.INTERFACE.TABLE,Data"

export eventHubConnection="TEST"
export AVRO_INGEST_EVENT="false"

# Inbox and outbox configurations

export EVENT_HUB_INBOX_TOPIC="ms-paymentorder-inbox-topic"
export EVENT_HUB_EVENT_TOPIC="paymentorder-event-topic"

# Ingester and Inbox/outbox related config 
export INGEST_SOURCE_STREAM="ms-paymentorder-inbox-topic"
export INGEST_EVENT_INGESTER="com.temenos.microservice.framework.core.ingester.MicroserviceIngester"
export GENERIC_INGESTER="com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester"
export INBOXOUTBOX_INGESTER="com.temenos.microservice.framework.core.ingester.MSKafkaOutboxEventListener"
export ERROR_STREAM="error-paymentorder"
export VALIDATE_PAYMENT_ORDER="false"
export OUTBOX_TOPIC="ms-paymentorder-outbox-topic"
export SINK_ERROR_STREAM="ms-paymentorder-inbox-error-topic"
export INBOX_DAO="com.temenos.microservice.framework.core.inbox.InboxDaoImpl"
export OUTBOX_DAO="com.temenos.microservice.framework.core.outbox.OutboxDaoImpl"
export PACKAGE_NAME="com.temenos.microservice.paymentorder.function"
export CreateNewPaymentOrder="com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl"


# KAFKA Properties
export QUEUE_IMPL="kafka"
export KAFKA_SERVER="postgres-kafka.servicebus.windows.net:9093"
export SSL_ENABLED="true"
export MAX_POLL_RECORDS=20
export SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://postgres-kafka.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=yUoa/1dlVqghGSUhf3YWUH5v7sbz9stw5ozyk8MaCx8=\";"
export ST#_SSL_ENABLED="true"
export STREAM_KAFKA_PROTOCOL=SASL_SSL
export STREAM_KAFKA_SASL_MECHANISM=PLAIN

export NOSQL_INBOX_CLEANUP_SCHEDULER_TIME="0 0/5 * * * *"
export INBOX_CLEANUP_MINUTES="60"
export NOSQL_INBOX_SCHEDULER="com.temenos.microservice.framework.scheduler.core.NoSqlInboxCatchupProcessor"


# Token and Authz config

export PDP_CONFIG_FILE="classpath:xacml/paymentorder-pdp-config.xml"
export AUTHZ_ENABLED="false"
export ms_security_tokencheck_enabled=Y
export JWT_TOKEN_PRINCIPAL_CLAIM="sub"
export JWT_TOKEN_ISSUER="https://localhost:9443/oauth2/token"
export ID_TOKEN_SIGNED="true"
export JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
export ENTITLEMENT_STUBBED_SERVICE_ENABLED="true"

# File Upload
export RESOURCE_STORAGE_NAME="paymentorderpostgres"
export RESOURCE_STORAGE_HOME="blob://paymentorder"
export MAX_FILE_UPLOAD_SIZE=70
export SCHEDULER_TIME="0 */50 * * * *"

# DB Migration
export INITIATE_DBMIGRATION="com.temenos.microservice.framework.dbmigration.core.InitiateDbMigrationImpl"
export GET_DBMIGRATION="com.temenos.microservice.framework.dbmigration.core.GetDbMigrationStatusImpl"
export CLOUD_EVENT_FLAG="true" 

# OTHERS CONFIG
export ENVIRONMENT_CONF=test
export METER_DISABLE="true"
export TRACER_ENABLED="false"
export EXECUTION_ENV="TEST"
export EXEC_ENV="serverless"
export EXECUTION_ENVIRONMENT="TEST"
export DB_CONNECTION_MIN_POOL_SIZE=10
export DB_CONNECTION_MAX_POOL_SIZE=150

export JAR_NAME="ms-paymentorder"
export JAR_VERSION="DEV.0.0-SNAPSHOT"

export startIP=0.0.0.0
export endIP=255.255.255.25

./ingester_creator.sh "${APP_NAME}" "${JAR_NAME}" "${JAR_VERSION}"  

#Create postgres server and database properties

az group create --name "${RESOURCE_GROUP_NAME}" --location "${LOCATION}"

az postgres flexible-server create --public-access all --resource-group "${RESOURCE_GROUP_NAME}" --name "${DB_NAME_SPACE}" --location "${LOCATION}" --admin-user "${DATABASE_USERNAME}" --admin-password "${DATABASE_PASSWORD}" --sku-name Standard_D4s_v3 --tier GeneralPurpose --version 13

az postgres flexible-server db create --resource-group "${RESOURCE_GROUP_NAME}" --database-name "${DB_NAME}" --server-name "${DB_NAME_SPACE}"

az postgres flexible-server firewall-rule create --resource-group "${RESOURCE_GROUP_NAME}" --name "${DB_NAME_SPACE}" --rule-name allowip --start-ip-address "${startIP}" --end-ip-address "${endIP}"

# deployment azure package into azure enviornment

if [ $SUBSCRIPTION_ID != "" ]; then
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dsubscription.id="${SUBSCRIPTION_ID}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${APP_NAME}" -f pom-azure-deploy.xml -X
else
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${APP_NAME}" -f pom-azure-deploy.xml -X
fi

# OutboxListener function
if [ $SUBSCRIPTION_ID != "" ]; then
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}"  -Dsubscription.id="${SUBSCRIPTION_ID}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${OUTBOX_LISTENER_APP_NAME}" -f pom-azure-deploy.xml -X
else
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${OUTBOX_LISTENER_APP_NAME}" -f pom-azure-deploy.xml -X
fi 


#PROPERTIES FOR TOPICS AND HUB NAME/CONSUMERGROUP NAME CREATION

# Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.
az eventhubs namespace create --name "${EVENT_HUB_NAME_SPACE}" --resource-group "${RESOURCE_GROUP_NAME}" -l "${LOCATION}" --enable-kafka true

# Create an event hub. Specify a name for the event hub. //GENERIC_INGESTER
az eventhubs eventhub create --name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

# Outbox EventListener EventHub //Outbox Listener
az eventhubs eventhub create --name "${EVENT_HUB_OUTBOX}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

# Create an event hub. Specify a name for the event hub. 
az eventhubs eventhub create --name "${EVENT_HUB_INBOX_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

# Outbox EventListener EventHub //Outbox Listener
az eventhubs eventhub create --name "${EVENT_HUB_EVENT_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

# Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_CG}"

# Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_OUTBOX}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_OUTBOX_CG}"

# Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_INBOX_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_INBOX_CG}"

#Reterive event hub connection string
export eventHubConnection=$(az eventhubs namespace authorization-rule keys list --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])" )


echo "event hub : "$eventHubConnection
export string='"$ConnectionString"'
export SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=$string password=\"$eventHubConnection\";"
echo "SASL_JASS_CONFIG : "$SASL_JASS_CONFIG

#  Read the jar name of the respective release
export MS_AZURE=$(basename ./target/azure-functions/${APP_NAME}/lib/microservice-package-azure*)


#create new Storage
az storage account create -n "${RESOURCE_STORAGE_NAME}" -g "${RESOURCE_GROUP_NAME}" -l "${LOCATION}" --sku Standard_LRS

#Reterive storage account connection string
export storageconnectionString=$(az storage account show-connection-string -g "${RESOURCE_GROUP_NAME}" -n "${RESOURCE_STORAGE_NAME}" | python -c "import json,sys;apis=json.load(sys.stdin); print(apis['connectionString'])") 

export string='"$storageconnectionString"'
export AZURE_STORAGE_CONNECTION_STRING="${storageconnectionString}"
echo "AZURE_STORAGE_CONNECTION_STRING : "$AZURE_STORAGE_CONNECTION_STRING

# Environment variable settings
#Environment variable settings
az functionapp config appsettings set --name "${APP_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETpaymentorder}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_GetPaymentOrder="${GETPAYMENT}" className_deletePaymentOrder="${DELETE_PAYMENTORDER}" className_invokepaymentordertate="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}" className_GetPaymentOrderCurrency="${PAYMENT_ORDER_CURRENCY}" className_createReferenceData="${CREATE_REFERENCE_DATA}" className_updateReferenceData="${UPDATE_REFERENCE_DATA}" className_addReferenceData="${ADD_REFERENCE_DATA}" className_deleteReferenceData="${DELETE_REFERENCE_DATA}" className_UpdateStatus="${UPDATE_STATUS}" className_DeleteWithCondition="${DELETE_CONDITION}" className_CreateUser="${CREATE_USER}" className_GetUser="${GET_USER}" className_CreateAccount="${CREATE_ACCOUNT}" className_GetAccount="${GET_ACCOUNT}" className_DeleteAccount="${DELETE_ACCOUNT}" className_UpdateAccount="${UPDATE_ACCOUNT}" className_createCustomer="${CREATE_CUSTOMER}" className_getCustomers="${GET_CUSTOMER}" className_GetInputValidation="${GET_INPUT_VALIDATION}" className_searchUsers="${SEARCH_USERS}" className_GetAccountValidate="${GET_ACCOUNT_VALIDATE}" DATABASE_NAME="${DATABASE_NAME}" DATABASE_KEY="${DATABASE_KEY}" POSTGRESQL_CONNECTIONURL="${DATABASE_CONNECTIONURL}" POSTGRESQL_USERNAME="${DATABASE_USERNAME}" POSTGRESQL_PASSWORD="${DATABASE_PASSWORD}" JAVA_OPTS="${JAVA_OPTS}" temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" temn_msf_ingest_sink_error_stream="${ERROR_STREAM}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" eventHubConnection="${eventHubConnection}" eventHubName="${EVENT_HUB}" eventHubConsumerGroup="${EVENT_HUB_CG}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}" temn.msf.ingest.generic.ingester="${GENERIC_INGESTER}" temn.exec.env="${EXEC_ENV}" class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.queue.impl="${QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}" temn.msf.stream.vendor.outbox="${QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}" MIN_POOL_SIZE="${DB_CONNECTION_MIN_POOL_SIZE}" MAX_POOL_SIZE="${DB_CONNECTION_MAX_POOL_SIZE}" JWT_TOKEN_PRINCIPAL_CLAIM="${JWT_TOKEN_PRINCIPAL_CLAIM}" JWT_TOKEN_ISSUER="${JWT_TOKEN_ISSUER}" ID_TOKEN_SIGNED="${ID_TOKEN_SIGNED}" JWT_TOKEN_PUBLIC_KEY="${JWT_TOKEN_PUBLIC_KEY}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" className_FileDownload="${FILE_DOWNLOAD}" className_FileUpload="${FILE_UPLOAD}" className_FileDelete="${FILE_DELETE}" ms_security_tokencheck_enabled="${ms_security_tokencheck_enabled}" EXECUTION_ENVIRONMENT="${EXECUTION_ENVIRONMENT}" temn.msf.max.file.upload.size="${MAX_FILE_UPLOAD_SIZE}" temn.msf.storage.home="${RESOURCE_STORAGE_HOME}" className_DoInputValidation="${DOINPUTVALIDATION}" className_paymentscheduler="${PAYMENT_SCHEDULER}" temn.entitlement.stubbed.service.enabled="${ENTITLEMENT_STUBBED_SERVICE_ENABLED}" schedulerTime="${SCHEDULER_TIME}" operationId=paymentscheduler className_initiateDbMigration="${INITIATE_DBMIGRATION}" className_getDbMigrationStatus="${GET_DBMIGRATION}" temn.msf.azure.storage.connection.string="${AZURE_STORAGE_CONNECTION_STRING}" temn.keystore.database.url="${DATABASE_CONNECTIONURL}" temn.keystore.database.driver=org.postgresql.Driver temn.keystore.database.user="${DATABASE_USERNAME}" temn.keystore.database.password="${DATABASE_PASSWORD}" temn.msf.stream.kafka.ssl.enabled="${STREM_SSL_ENABLED}" temn.msf.stream.security.kafka.security.protocol="${STREAM_KAFKA_PROTOCOL}" temn.msf.stream.kafka.sasl.mechanism="${STREAM_KAFKA_SASL_MECHANISM}" SqlInboxCleanupSchedulerTime="${SQL_INBOX_CLEANUP_SCHEDULER_TIME}" className_sqlinboxcleanup="${SQL_INBOX_SCHEDULER}" temn.msf.scheduler.inboxcleanup.schedule="${INBOX_CLEANUP_MINUTES}" ENVIRONMENT_CONF="${ENVIRONMENT_CONF}" operationId=paymentscheduler temn.meter.disabled="${METER_DISABLE}" temn.msf.tracer.enabled="${TRACER_ENABLED}"

#Environment variable settings
az functionapp config appsettings set --name "${OUTBOX_LISTENER_APP_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETpaymentorder}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_GetPaymentOrder="${GETPAYMENT}" className_deletePaymentOrder="${DELETE_PAYMENTORDER}" className_invokepaymentordertate="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}" className_GetPaymentOrderCurrency="${PAYMENT_ORDER_CURRENCY}" className_createReferenceData="${CREATE_REFERENCE_DATA}" className_updateReferenceData="${UPDATE_REFERENCE_DATA}" className_addReferenceData="${ADD_REFERENCE_DATA}" className_deleteReferenceData="${DELETE_REFERENCE_DATA}" className_UpdateStatus="${UPDATE_STATUS}" className_DeleteWithCondition="${DELETE_CONDITION}"className_CreateUser="${CREATE_USER}" className_GetUser="${GET_USER}" className_CreateAccount="${CREATE_ACCOUNT}" className_GetAccount="${GET_ACCOUNT}" className_DeleteAccount="${DELETE_ACCOUNT}" className_UpdateAccount="${UPDATE_ACCOUNT}" className_createCustomer="${CREATE_CUSTOMER}" className_getCustomers="${GET_CUSTOMER}" className_GetInputValidation="${GET_INPUT_VALIDATION}" className_searchUsers="${SEARCH_USERS}" className_GetAccountValidate="${GET_ACCOUNT_VALIDATE}" DATABASE_NAME="${DATABASE_NAME}" DATABASE_KEY="${DATABASE_KEY}" POSTGRESQL_CONNECTIONURL="${DATABASE_CONNECTIONURL}" POSTGRESQL_USERNAME="${DATABASE_USERNAME}" POSTGRESQL_PASSWORD="${DATABASE_PASSWORD}"  temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" eventHubConnection="${eventHubConnection}" eventHubName="${EVENT_HUB_OUTBOX}" eventHubConsumerGroup="${EVENT_HUB_OUTBOX_CG}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}" temn.msf.ingest.generic.ingester="${GENERIC_INGESTER}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.generic.ingester="${INBOXOUTBOX_INGESTER}" temn.exec.env="${EXEC_ENV}" class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.queue.impl="${QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}" temn.msf.stream.vendor.outbox="${QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}" MIN_POOL_SIZE="${DB_CONNECTION_MIN_POOL_SIZE}" MAX_POOL_SIZE="${DB_CONNECTION_MAX_POOL_SIZE}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" className_FileDownload="${FILE_DOWNLOAD}" className_FileUpload="${FILE_UPLOAD}" className_FileDelete="${FILE_DELETE}" temn.msf.storage.home="${RESOURCE_STORAGE_HOME}" className_DoInputValidation="${DOINPUTVALIDATION}"  className_paymentscheduler="${PAYMENT_SCHEDULER}" temn.entitlement.stubbed.service.enabled="${ENTITLEMENT_STUBBED_SERVICE_ENABLED}" schedulerTime="${SCHEDULER_TIME}" operationId=paymentscheduler className_initiateDbMigration="${INITIATE_DBMIGRATION}" className_getDbMigrationStatus="${GET_DBMIGRATION}" temn.msf.azure.storage.connection.string="${AZURE_STORAGE_CONNECTION_STRING}" temn.msf.ingest.is.cloud.event="${CLOUD_EVENT_FLAG}" temn.keystore.database.url="${DATABASE_CONNECTIONURL}" temn.keystore.database.driver=org.postgresql.Driver temn.keystore.database.user="${DATABASE_USERNAME}" temn.keystore.database.password="${DATABASE_PASSWORD}" temn.msf.stream.kafka.ssl.enabled="${STREM_SSL_ENABLED}" temn.msf.stream.security.kafka.security.protocol="${STREAM_KAFKA_PROTOCOL}" temn.msf.stream.kafka.sasl.mechanism="${STREAM_KAFKA_SASL_MECHANISM}" temn.meter.disabled="${METER_DISABLE}" temn.msf.tracer.enabled="${TRACER_ENABLED}"

#Command to execute DB scripts
java -cp target/azure-functions/$APP_NAME/lib/$MS_AZURE -Drds_instance_host=$DATABASE_CONNECTIONURL -Drds_instance_username=${DATABASE_USERNAME} -Drds_instance_password=$DATABASE_PASSWORD -DScript_Path=$SCRIPT_FILE_PATH com.temenos.microservice.azure.query.execution.AzurePostgresqlScriptExecution
