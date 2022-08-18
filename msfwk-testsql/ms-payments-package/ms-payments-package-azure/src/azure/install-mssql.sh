#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

export RESOURCE_GROUP_NAME="paymentsMSSQL"
export LOCATION="UK South"
export DB_NAME_SPACE="paymentssqlserver"
export DB_NAME="payments"
export APP_NAME="paymentsapp"
export AVRO_APP_NAME="paymentsavroapp"
export EVENT_APP_NAME="paymentseventapp"
export COMMAND_EVENT_NAME="paymentordercommandapp"
export OUTBOX_LISTENER_APP_NAME="paymentsapplistener"

#Class Implementation
export CREATEPAYMENT="com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl"
export GETPAYMENTS="com.temenos.microservice.payments.function.GetPaymentOrdersImpl"
export UPDATEPAYMENT="com.temenos.microservice.payments.function.UpdatePaymentOrderImpl"
export GETPAYMENT="com.temenos.microservice.payments.function.GetPaymentOrderImpl"
export INVEPAYMENT="com.temenos.microservice.payments.function.InvokePaymentOrderImpl"
export HEATHCHECK="com.temenos.microservice.framework.core.function.camel.GetHealthCheckImpl"
export CREATE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.CreateReferenceDataImpl"
export ADD_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.AddReferenceDataImpl"
export UPDATE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.UpdateReferenceDataImpl"
export GET_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataImpl"
export DELETE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.DeleteReferenceDataImpl"
export FILE_UPLOAD="com.temenos.microservice.payments.function.FileUploadImpl"
export FILE_DOWNLOAD="com.temenos.microservice.payments.function.FileDownloadImpl"
export FILE_DELETE="com.temenos.microservice.payments.function.FileDeleteImpl"
export DOINPUTVALIDATION="com.temenos.microservice.payments.function.DoInputValidationImpl"
export PAYMENT_SCHEDULER="com.temenos.microservice.payments.scheduler.PaymentOrderScheduler"
export CREATE_EMPLOYEE="com.temenos.microservice.payments.function.CreateEmployeeImpl"
export GET_EMPLOYEE="com.temenos.microservice.payments.function.GetEmployeeImpl"
export UPDATE_EMPLOYEE="com.temenos.microservice.payments.function.UpdateEmployeeImpl"
export DELETE_EMPLOYEE="com.temenos.microservice.payments.function.DeleteEmployeeImpl"
export GET_CURRENCY="com.temenos.microservice.payments.function.GetPaymentOrderCurrencyImpl"

#DB PROPERTIES

export DB_NAME="payments"
export DB_PASSWORD="payments@12345"
export DB_USERNAME="paymentsadmin"
export DB_ADMIN_USERNAME="paymentsadmin"
export DRIVER_NAME="com.microsoft.sqlserver.jdbc.SQLServerDriver"
export DIALECT="org.hibernate.dialect.SQLServerDialect"
export DB_CONNECTION_URL="jdbc:sqlserver://$DB_NAME_SPACE.database.windows.net:1433;databaseName=$DB_NAME"
export SUBSCRIPTION_ID=""

export JAVA_OPTS="-Djava.net.preferIPv4Stack=true"
export AUTHZ_ENABLED="false"

#EVENTHUB NAMES
export MSF_NAME="ms-paymentorder"
export EVENT_HUB_NAME_SPACE="posql-kafka"
export EVENT_HUB="ms-paymentorder-inbox-topic"
export EVENT_HUB_CG="paymentordercg"
export EVENT_HUB_OUTBOX="ms-paymentorder-outbox-topic"
export EVENT_HUB_OUTBOX_CG="paymentorderoutboxcg"
export EVENT_HUB_AVRO_CG="paymentorderavrocg"
export EVENT_HUB_EVENT_CG="paymentordereventcg"
export eventHubConnection="TEST"
export AVRO_INGEST_EVENT="false"
export ENVIRONMENT_CONF=test


#ingester

export GENERIC_INGESTER="com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester"
export GENERIC_COMMAND_INGESTER="com.temenos.microservice.paymentorder.ingester.POCommandIngester"
export INBOXOUTBOX_INGESTER="com.temenos.microservice.framework.core.ingester.MSKafkaOutboxEventListener"
export EXEC_ENV="serverless"
export OUTBOX_TOPIC="ms-paymentorder-outbox-topic"
export SINK_ERROR_STREAM="ms-paymentorder-inbox-error-topic"
export SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://$EVENT_HUB_NAME_SPACE.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=yUoa/1dlVqghGSUhf3YWUH5v7sbz9stw5ozyk8MaCx8=\";"

#Inbox and outbox configurations

export EVENT_HUB_INBOX_TOPIC="ms-paymentorder-inbox-topic"
export EVENT_HUB_EVENT_TOPIC="paymentorder-event-topic"
export EVENT_HUB_AVRO_TOPIC="table-update-paymentorder"

#Error Topics

export ERROR_STREAM="error-paymentorder"
export REGISTRY_URL="PAYMENT_ORDEREvent"
export EXECUTION_ENV="TEST"
export VALIDATE_PAYMENT_ORDER="false"
export INBOX_DAO="com.temenos.microservice.framework.core.inbox.InboxDaoImpl"
export OUTBOX_DAO="com.temenos.microservice.framework.core.outbox.OutboxDaoImpl"
export INGEST_SOURCE_STREAM="ms-paymentorder-inbox-topic"
export CreateNewPaymentOrder="com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl"
export PACKAGE_NAME="com.temenos.microservice.payments.function"

#AVRO INGESTER_APP_1

export INGEST_SOURCE_STREAM_AVRO="table-update-paymentorder"
export INGEST_EVENT_INGESTER="com.temenos.microservice.framework.core.ingester.MicroserviceIngester"
export PAYMENT_ORDER_EVENT="com.temenos.microservice.payments.ingester.PaymentorderIngesterUpdater"
export PAYMENT_EVENT="com.temenos.microservice.payments.entity.PaymentOrder"

#KAFKA PROPERTIES
export QUEUE_IMPL="kafka"
export KAFKA_SERVER="$EVENT_HUB_NAME_SPACE.servicebus.windows.net:9093"
export SSL_ENABLED="true"
export MAX_POLL_RECORDS=20

export RESOURCE_STORAGE_NAME="paymentordersqllolp"
export RESOURCE_STORAGE_HOME="blob://paymentorder"

#JVVT Token Config
export JWT_TOKEN_PRINCIPAL_CLAIM="sub"
export JWT_TOKEN_ISSUER="https://localhost:9443/oauth2/token"
export ID_TOKEN_SIGNED="true"
export JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"

#DB Migration config
export INITIATE_DBMIGRATION="com.temenos.microservice.framework.dbmigration.core.InitiateDbMigrationImpl"
export GET_DBMIGRATION="com.temenos.microservice.framework.dbmigration.core.GetDbMigrationStatusImpl"

#Consumer group for Inbox/outbox events 

export EVENT_HUB_EVENT_CG="paymentordereventcg"
export EVENT_HUB_INBOX_CG="paymentorderinboxcg"
export JAR_NAME="ms-paymentorder"
export JAR_VERSION="DEV.0.0-SNAPSHOT"
export EVENT_HUB_AVRO_CG="tableupdatepaymentcg"

#OTHERS
export ms_security_tokencheck_enabled=Y
export EXECUTION_ENVIRONMENT="TEST"
export MAX_FILE_UPLOAD_SIZE=70
export SCHEDULER_TIME="0 */50 * * * *"
export ENTITLEMENT_STUBBED_SERVICE_ENABLED="true"
export CLOUD_EVENT_FLAG="true"
export SCRIPTPATH="db/initdb.sql"
export DB_CONNECTION_MIN_POOL_SIZE=10
export DB_CONNECTION_MAX_POOL_SIZE=150
export METER_DISABLE="true"
export TRACER_ENABLED="false"
export startIP=0.0.0.0
export endIP=255.255.255.255

export SQL_INBOX_CLEANUP_SCHEDULER_TIME="0 0/5 * * * *"
export INBOX_CLEANUP_MINUTES="60"
export SQL_INBOX_SCHEDULER="com.temenos.microservice.framework.scheduler.core.SqlInboxCatchupProcessor"
export EVENT_HUB_COMMAND_EVENT_CG="paymentordercommandeventcg"
export EVENT_HUB_COMMAND_EVENT_TOPIC="paymentorder-inbox-topic"
export EVENTDIRECTLYDELIVERY="true"
export ms_security_tokencheck_command_enabled=N

# APPINIT Environment variables 
export APPINT_NAME="appinit"
export TEM_APPINIT_DISABLEINBOX="true"
export APPINIT_AUTHZ_ENABLED="false"
export JPA_ENABLED="none"
export DB_AUTO_UPGRADE="N"

#Audit Enabling
export ENABLE_AUDIT=true 
export ENABLE_AUDIT_FOR_GET_API=true
export ENABLE_AUDIT_TO_CAPTURE_RESPONSE=true

./ingester_creator.sh "${APP_NAME}" "${JAR_NAME}" "${JAR_VERSION}" 

./ingester_creator.sh "${APP_NAME}" "${AVRO_APP_NAME}" "${JAR_NAME}" "${JAR_VERSION}"

./ingester_creator.sh "${APP_NAME}" "${EVENT_APP_NAME}" "${JAR_NAME}" "${JAR_VERSION}"  

./ingester_creator.sh "${APP_NAME}" "${COMMAND_EVENT_NAME}" "${JAR_NAME}" "${JAR_VERSION}"  

# Create a resource resourceGroupName

az group create --name "${RESOURCE_GROUP_NAME}"   --location "${LOCATION}"

az sql server create --name "${DB_NAME_SPACE}" --resource-group "${RESOURCE_GROUP_NAME}" --location "${LOCATION}" --admin-user "${DB_ADMIN_USERNAME}" --admin-password "${DB_PASSWORD}"

az sql server firewall-rule create --resource-group "${RESOURCE_GROUP_NAME}" --server "${DB_NAME_SPACE}" -n AllowYourIp --start-ip-address "${startIP}" --end-ip-address "${endIP}"

az sql db create --resource-group "${RESOURCE_GROUP_NAME}" --server "${DB_NAME_SPACE}" --name "${DB_NAME}" --service-objective S0

# deployment azure package into azure enviornment

if [ $SUBSCRIPTION_ID != "" ]; then
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dsubscription.id="${SUBSCRIPTION_ID}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${APP_NAME}" -f pom-azure-deploy.xml -X
else
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${APP_NAME}" -f pom-azure-deploy.xml -X
fi


if [ $SUBSCRIPTION_ID != "" ]; then
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dsubscription.id="${SUBSCRIPTION_ID}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${AVRO_APP_NAME}" -f pom-azure-deploy.xml -X
else
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${AVRO_APP_NAME}" -f pom-azure-deploy.xml -X
fi

if [ $SUBSCRIPTION_ID != "" ]; then
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dsubscription.id="${SUBSCRIPTION_ID}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${EVENT_APP_NAME}" -f pom-azure-deploy.xml -X
else
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${EVENT_APP_NAME}" -f pom-azure-deploy.xml -X
fi


if [ $SUBSCRIPTION_ID != "" ]; then
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dsubscription.id="${SUBSCRIPTION_ID}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${COMMAND_EVENT_NAME}" -f pom-azure-deploy.xml -X
else
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${COMMAND_EVENT_NAME}" -f pom-azure-deploy.xml -X
fi



# OutboxListener function
if [ $SUBSCRIPTION_ID != "" ]; then
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}"  -Dsubscription.id="${SUBSCRIPTION_ID}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${OUTBOX_LISTENER_APP_NAME}" -f pom-azure-deploy.xml -X
else
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${OUTBOX_LISTENER_APP_NAME}" -f pom-azure-deploy.xml -X
fi 

# AppInit function
if [ $SUBSCRIPTION_ID != "" ]; then
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}"  -Dsubscription.id="${SUBSCRIPTION_ID}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${APPINT_NAME}" -f pom-azure-deploy.xml -X
else
	mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${APPINT_NAME}" -f pom-azure-deploy.xml -X
fi 

#Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.
az eventhubs namespace create --name "${EVENT_HUB_NAME_SPACE}" --resource-group "${RESOURCE_GROUP_NAME}" -l "${LOCATION}" --enable-kafka true

#Create an event hub. Specify a name for the event hub. //GENERIC_INGESTER
az eventhubs eventhub create --name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

#Outbox EventListener EventHub //Outbox Listener
az eventhubs eventhub create --name "${EVENT_HUB_OUTBOX}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

#Create an event hub. Specify a name for the event hub. 
az eventhubs eventhub create --name "${EVENT_HUB_INBOX_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

#Outbox EventListener EventHub //Outbox Listener
az eventhubs eventhub create --name "${EVENT_HUB_EVENT_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_AVRO_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_COMMAND_EVENT_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

#Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_CG}"

#Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_OUTBOX}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_OUTBOX_CG}"

#Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_INBOX_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_INBOX_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_EVENT_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_EVENT_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_AVRO_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_AVRO_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_COMMAND_EVENT_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_COMMAND_EVENT_CG}"

#Reterive event hub connection string
export eventHubConnection=$(az eventhubs namespace authorization-rule keys list --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])" )


echo "event hub : "$eventHubConnection
export string='"$ConnectionString"'
export SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=$string password=\"$eventHubConnection\";"
echo "SASL_JASS_CONFIG : "$SASL_JASS_CONFIG

#create new Storage
az storage account create -n "${RESOURCE_STORAGE_NAME}" -g "${RESOURCE_GROUP_NAME}" -l "${LOCATION}" --sku Standard_LRS

#Reterive storage account connection string
export storageconnectionString=$(az storage account show-connection-string -g "${RESOURCE_GROUP_NAME}" -n "${RESOURCE_STORAGE_NAME}" | python -c "import json,sys;apis=json.load(sys.stdin); print(apis['connectionString'])") 

export string='"$storageconnectionString"'
export AZURE_STORAGE_CONNECTION_STRING="${storageconnectionString}"
echo "AZURE_STORAGE_CONNECTION_STRING : "$AZURE_STORAGE_CONNECTION_STRING

# Exporting master key from appinit function app
export MASTER_KEY=$(az functionapp keys list -g "${RESOURCE_GROUP_NAME}" -n "${APPINT_NAME}" --query masterKey)

#Environment variable settings
az functionapp config appsettings set --name "${APP_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETPAYMENTS}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_GetPaymentOrder="${GETPAYMENT}" className_invokePaymentState="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}" className_GetPaymentOrderCurrency="${GET_CURRENCY}" DATABASE_NAME="${DATABASE_NAME}" DB_CONNECTION_URL="${DB_CONNECTION_URL}" DRIVER_NAME="${DRIVER_NAME}" DIALECT="${DIALECT}" DB_PASSWORD="${DB_PASSWORD}" DB_USERNAME="${DB_USERNAME}" JAVA_OPTS="${JAVA_OPTS}" temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_sink_error_stream="${ERROR_STREAM}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" eventHubConnection="${eventHubConnection}" eventHubName="${EVENT_HUB}" eventHubConsumerGroup="${EVENT_HUB_CG}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" DATABASE_KEY=sql temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}" temn.msf.ingest.generic.ingester="${GENERIC_INGESTER}" temn.exec.env="${EXEC_ENV}" temn.msf.stream.outbox.topic="${OUTBOX_TOPIC}" class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" temn.queue.impl="${QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}" temn.msf.stream.vendor.outbox="${QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}" MIN_POOL_SIZE="${DB_CONNECTION_MIN_POOL_SIZE}" MAX_POOL_SIZE="${DB_CONNECTION_MAX_POOL_SIZE}" temn.msf.azure.storage.connection.string="${AZURE_STORAGE_CONNECTION_STRING}" className_createReferenceData="${CREATE_REFERENCE_DATA}" className_getReferenceData="${GET_REFERENCE_DATA}" JWT_TOKEN_PRINCIPAL_CLAIM="${JWT_TOKEN_PRINCIPAL_CLAIM}" JWT_TOKEN_ISSUER="${JWT_TOKEN_ISSUER}" ID_TOKEN_SIGNED="${ID_TOKEN_SIGNED}" JWT_TOKEN_PUBLIC_KEY="${JWT_TOKEN_PUBLIC_KEY}" className_updateReferenceData="${UPDATE_REFERENCE_DATA}" className_addReferenceData="${ADD_REFERENCE_DATA}" className_FileDownload="${FILE_DOWNLOAD}" className_FileDelete="${FILE_DELETE}" className_FileUpload="${FILE_UPLOAD}" className_deleteReferenceData="${DELETE_REFERENCE_DATA}" temn.msf.max.file.upload.size="${MAX_FILE_UPLOAD_SIZE}" temn.msf.storage.home="${RESOURCE_STORAGE_HOME}" ms_security_tokencheck_enabled="${ms_security_tokencheck_enabled}" EXECUTION_ENVIRONMENT="${EXECUTION_ENVIRONMENT}" className_DoInputValidation="${DOINPUTVALIDATION}" className_paymentscheduler="${PAYMENT_SCHEDULER}" schedulerTime="${SCHEDULER_TIME}" operationId=paymentscheduler className_CreateEmployee="${CREATE_EMPLOYEE}" className_GetEmployee="${GET_EMPLOYEE}" className_UpdateEmployee="${UPDATE_EMPLOYEE}" className_DeleteEmployee="${DELETE_EMPLOYEE}" temn.entitlement.stubbed.service.enabled="${ENTITLEMENT_STUBBED_SERVICE_ENABLED}" className_initiateDbMigration="${INITIATE_DBMIGRATION}" className_getDbMigrationStatus="${GET_DBMIGRATION}" SqlInboxCleanupSchedulerTime="${SQL_INBOX_CLEANUP_SCHEDULER_TIME}" className_sqlinboxcleanup="${SQL_INBOX_SCHEDULER}" temn.msf.scheduler.inboxcleanup.schedule="${INBOX_CLEANUP_MINUTES}" ENVIRONMENT_CONF="${ENVIRONMENT_CONF}" operationId=paymentscheduler temn.meter.disabled="${METER_DISABLE}" temn.msf.tracer.enabled="${TRACER_ENABLED}" className_ReprocessEvents=com.temenos.microservice.framework.core.error.function.ReprocessEventsImpl className_GetErrorEvents=com.temenos.microservice.framework.core.error.function.GetErrorEventsImpl temn.msf.ingest.reprocess.source.stream=reprocess-event temn.msf.outbox.direct.delivery.enabled="${EVENTDIRECTLYDELIVERY}" temn.msf.audit.enabled="${ENABLE_AUDIT}" temn.msf.audit.get.enabled="${ENABLE_AUDIT_FOR_GET_API}" temn.msf.audit.response.enabled="${ENABLE_AUDIT_TO_CAPTURE_RESPONSE}"


az functionapp config appsettings set --name "${COMMAND_EVENT_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETPAYMENTS}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_GetPaymentOrder="${GETPAYMENT}" className_invokePaymentState="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}" className_GetPaymentOrderCurrency="${GET_CURRENCY}" DATABASE_NAME="${DATABASE_NAME}" DB_CONNECTION_URL="${DB_CONNECTION_URL}" DRIVER_NAME="${DRIVER_NAME}" DIALECT="${DIALECT}" DB_PASSWORD="${DB_PASSWORD}" DB_USERNAME="${DB_USERNAME}" JAVA_OPTS="${JAVA_OPTS}" temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_sink_error_stream="${ERROR_STREAM}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" eventHubConnection="${eventHubConnection}" eventHubName="${EVENT_HUB_COMMAND_EVENT_TOPIC}" eventHubConsumerGroup="${EVENT_HUB_COMMAND_EVENT_CG}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" DATABASE_KEY=sql temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}" temn.msf.ingest.generic.ingester="${GENERIC_COMMAND_INGESTER}" temn.exec.env="${EXEC_ENV}" temn.msf.stream.outbox.topic="${OUTBOX_TOPIC}" class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" temn.queue.impl="${QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}" temn.msf.stream.vendor.outbox="${QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}" MIN_POOL_SIZE="${DB_CONNECTION_MIN_POOL_SIZE}" MAX_POOL_SIZE="${DB_CONNECTION_MAX_POOL_SIZE}" temn.msf.azure.storage.connection.string="${AZURE_STORAGE_CONNECTION_STRING}" className_createReferenceData="${CREATE_REFERENCE_DATA}" className_getReferenceData="${GET_REFERENCE_DATA}" JWT_TOKEN_PRINCIPAL_CLAIM="${JWT_TOKEN_PRINCIPAL_CLAIM}" JWT_TOKEN_ISSUER="${JWT_TOKEN_ISSUER}" ID_TOKEN_SIGNED="${ID_TOKEN_SIGNED}" JWT_TOKEN_PUBLIC_KEY="${JWT_TOKEN_PUBLIC_KEY}" className_updateReferenceData="${UPDATE_REFERENCE_DATA}" className_addReferenceData="${ADD_REFERENCE_DATA}" className_FileDownload="${FILE_DOWNLOAD}" className_FileDelete="${FILE_DELETE}" className_FileUpload="${FILE_UPLOAD}" className_deleteReferenceData="${DELETE_REFERENCE_DATA}" temn.msf.max.file.upload.size="${MAX_FILE_UPLOAD_SIZE}" temn.msf.storage.home="${RESOURCE_STORAGE_HOME}" ms_security_tokencheck_enabled="${ms_security_tokencheck_command_enabled}" EXECUTION_ENVIRONMENT="${EXECUTION_ENVIRONMENT}" className_DoInputValidation="${DOINPUTVALIDATION}" className_paymentscheduler="${PAYMENT_SCHEDULER}" schedulerTime="${SCHEDULER_TIME}" operationId=paymentscheduler className_CreateEmployee="${CREATE_EMPLOYEE}" className_GetEmployee="${GET_EMPLOYEE}" className_UpdateEmployee="${UPDATE_EMPLOYEE}" className_DeleteEmployee="${DELETE_EMPLOYEE}" temn.entitlement.stubbed.service.enabled="${ENTITLEMENT_STUBBED_SERVICE_ENABLED}" className_initiateDbMigration="${INITIATE_DBMIGRATION}" className_getDbMigrationStatus="${GET_DBMIGRATION}" SqlInboxCleanupSchedulerTime="${SQL_INBOX_CLEANUP_SCHEDULER_TIME}" className_sqlinboxcleanup="${SQL_INBOX_SCHEDULER}" temn.msf.scheduler.inboxcleanup.schedule="${INBOX_CLEANUP_MINUTES}" ENVIRONMENT_CONF="${ENVIRONMENT_CONF}" operationId=paymentscheduler temn.meter.disabled="${METER_DISABLE}" temn.msf.tracer.enabled="${TRACER_ENABLED}" className_ReprocessEvents=com.temenos.microservice.framework.core.error.function.ReprocessEventsImpl className_GetErrorEvents=com.temenos.microservice.framework.core.error.function.GetErrorEventsImpl temn.msf.ingest.reprocess.source.stream=reprocess-event temn.msf.outbox.direct.delivery.enabled="${EVENTDIRECTLYDELIVERY}" temn.msf.audit.enabled="${ENABLE_AUDIT}" temn.msf.audit.get.enabled="${ENABLE_AUDIT_FOR_GET_API}" temn.msf.audit.response.enabled="${ENABLE_AUDIT_TO_CAPTURE_RESPONSE}"


az functionapp config appsettings set --name "${AVRO_APP_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETpaymentorder}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_GetPaymentOrder="${GETPAYMENT}" className_deletePaymentOrder="${DELETE_PAYMENTORDER}" className_invokepaymentordertate="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}" className_GetPaymentOrderCurrency="${PAYMENT_ORDER_CURRENCY}" className_createReferenceData="${CREATE_REFERENCE_DATA}" className_updateReferenceData="${UPDATE_REFERENCE_DATA}" className_addReferenceData="${ADD_REFERENCE_DATA}" className_deleteReferenceData="${DELETE_REFERENCE_DATA}" className_UpdateStatus="${UPDATE_STATUS}" className_DeleteWithCondition="${DELETE_CONDITION}" className_CreateUser="${CREATE_USER}" className_GetUser="${GET_USER}" className_CreateAccount="${CREATE_ACCOUNT}" className_GetAccount="${GET_ACCOUNT}" className_DeleteAccount="${DELETE_ACCOUNT}" className_UpdateAccount="${UPDATE_ACCOUNT}" className_createCustomer="${CREATE_CUSTOMER}" className_getCustomers="${GET_CUSTOMER}" className_GetInputValidation="${GET_INPUT_VALIDATION}" className_searchUsers="${SEARCH_USERS}" className_GetAccountValidate="${GET_ACCOUNT_VALIDATE}" DATABASE_NAME="${DATABASE_NAME}" DATABASE_KEY="${DATABASE_KEY}" POSTGRESQL_CONNECTIONURL="${DATABASE_CONNECTIONURL}" POSTGRESQL_USERNAME="${DATABASE_USERNAME}" POSTGRESQL_PASSWORD="${DATABASE_PASSWORD}" JAVA_OPTS="${JAVA_OPTS}" temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" temn_msf_ingest_sink_error_stream="${ERROR_STREAM}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" eventHubConnection="${eventHubConnection}" eventHubName="${EVENT_HUB_AVRO_TOPIC}" eventHubConsumerGroup="${EVENT_HUB_AVRO_CG}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}" temn.msf.ingest.generic.ingester="${GENERIC_INGESTER}" temn.exec.env="${EXEC_ENV}" class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.queue.impl="${QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}" temn.msf.stream.vendor.outbox="${QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}" MIN_POOL_SIZE="${DB_CONNECTION_MIN_POOL_SIZE}" MAX_POOL_SIZE="${DB_CONNECTION_MAX_POOL_SIZE}" JWT_TOKEN_PRINCIPAL_CLAIM="${JWT_TOKEN_PRINCIPAL_CLAIM}" JWT_TOKEN_ISSUER="${JWT_TOKEN_ISSUER}" ID_TOKEN_SIGNED="${ID_TOKEN_SIGNED}" JWT_TOKEN_PUBLIC_KEY="${JWT_TOKEN_PUBLIC_KEY}" temn.msf.ingest.is.avro.event.ingester=true className_FileDownload="${FILE_DOWNLOAD}" className_FileUpload="${FILE_UPLOAD}" className_FileDelete="${FILE_DELETE}" ms_security_tokencheck_enabled="${ms_security_tokencheck_enabled}" EXECUTION_ENVIRONMENT="${EXECUTION_ENVIRONMENT}" temn.msf.max.file.upload.size="${MAX_FILE_UPLOAD_SIZE}" temn.msf.storage.home="${RESOURCE_STORAGE_HOME}" className_DoInputValidation="${DOINPUTVALIDATION}" className_paymentscheduler="${PAYMENT_SCHEDULER}" temn.entitlement.stubbed.service.enabled="${ENTITLEMENT_STUBBED_SERVICE_ENABLED}" schedulerTime="${SCHEDULER_TIME}" operationId=paymentscheduler className_initiateDbMigration="${INITIATE_DBMIGRATION}" className_getDbMigrationStatus="${GET_DBMIGRATION}" temn.msf.azure.storage.connection.string="${AZURE_STORAGE_CONNECTION_STRING}" temn.keystore.database.url="${DATABASE_CONNECTIONURL}" temn.keystore.database.driver=org.postgresql.Driver temn.keystore.database.user="${DATABASE_USERNAME}" temn.keystore.database.password="${DATABASE_PASSWORD}" temn.msf.stream.kafka.ssl.enabled="${STREM_SSL_ENABLED}" temn.msf.stream.security.kafka.security.protocol="${STREAM_KAFKA_PROTOCOL}" temn.msf.stream.kafka.sasl.mechanism="${STREAM_KAFKA_SASL_MECHANISM}" SqlInboxCleanupSchedulerTime="${SQL_INBOX_CLEANUP_SCHEDULER_TIME}" className_sqlinboxcleanup="${SQL_INBOX_SCHEDULER}" temn.msf.scheduler.inboxcleanup.schedule="${INBOX_CLEANUP_MINUTES}" ENVIRONMENT_CONF="${ENVIRONMENT_CONF}" operationId=paymentscheduler temn.meter.disabled="${METER_DISABLE}" temn.msf.tracer.enabled="${TRACER_ENABLED}" temn.msf.ingest.event.ingester=com.temenos.microservice.framework.core.ingester.MicroserviceIngester PAYMENT_ORDEREvent=com.temenos.microservice.paymentorder.ingester.PaymentorderIngesterUpdater temn.msf.outbox.direct.delivery.enabled="${EVENTDIRECTLYDELIVERY}" temn.msf.audit.enabled="${ENABLE_AUDIT}" temn.msf.audit.get.enabled="${ENABLE_AUDIT_FOR_GET_API}" temn.msf.audit.response.enabled="${ENABLE_AUDIT_TO_CAPTURE_RESPONSE}"



az functionapp config appsettings set --name "${EVENT_APP_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETpaymentorder}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_GetPaymentOrder="${GETPAYMENT}" className_deletePaymentOrder="${DELETE_PAYMENTORDER}" className_invokepaymentordertate="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}" className_GetPaymentOrderCurrency="${PAYMENT_ORDER_CURRENCY}" className_createReferenceData="${CREATE_REFERENCE_DATA}" className_updateReferenceData="${UPDATE_REFERENCE_DATA}" className_addReferenceData="${ADD_REFERENCE_DATA}" className_deleteReferenceData="${DELETE_REFERENCE_DATA}" className_UpdateStatus="${UPDATE_STATUS}" className_DeleteWithCondition="${DELETE_CONDITION}" className_CreateUser="${CREATE_USER}" className_GetUser="${GET_USER}" className_CreateAccount="${CREATE_ACCOUNT}" className_GetAccount="${GET_ACCOUNT}" className_DeleteAccount="${DELETE_ACCOUNT}" className_UpdateAccount="${UPDATE_ACCOUNT}" className_createCustomer="${CREATE_CUSTOMER}" className_getCustomers="${GET_CUSTOMER}" className_GetInputValidation="${GET_INPUT_VALIDATION}" className_searchUsers="${SEARCH_USERS}" className_GetAccountValidate="${GET_ACCOUNT_VALIDATE}" DATABASE_NAME="${DATABASE_NAME}" DATABASE_KEY="${DATABASE_KEY}" POSTGRESQL_CONNECTIONURL="${DATABASE_CONNECTIONURL}" POSTGRESQL_USERNAME="${DATABASE_USERNAME}" POSTGRESQL_PASSWORD="${DATABASE_PASSWORD}" JAVA_OPTS="${JAVA_OPTS}" temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" temn_msf_ingest_sink_error_stream="${ERROR_STREAM}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" eventHubConnection="${eventHubConnection}" eventHubName="${EVENT_HUB_EVENT_TOPIC}" eventHubConsumerGroup="${EVENT_HUB_EVENT_CG}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}" temn.msf.ingest.generic.ingester="${GENERIC_INGESTER}" temn.exec.env="${EXEC_ENV}" class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.queue.impl="${QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}" temn.msf.stream.vendor.outbox="${QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}" MIN_POOL_SIZE="${DB_CONNECTION_MIN_POOL_SIZE}" MAX_POOL_SIZE="${DB_CONNECTION_MAX_POOL_SIZE}" JWT_TOKEN_PRINCIPAL_CLAIM="${JWT_TOKEN_PRINCIPAL_CLAIM}" JWT_TOKEN_ISSUER="${JWT_TOKEN_ISSUER}" ID_TOKEN_SIGNED="${ID_TOKEN_SIGNED}" JWT_TOKEN_PUBLIC_KEY="${JWT_TOKEN_PUBLIC_KEY}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" className_FileDownload="${FILE_DOWNLOAD}" className_FileUpload="${FILE_UPLOAD}" className_FileDelete="${FILE_DELETE}" ms_security_tokencheck_enabled="${ms_security_tokencheck_enabled}" EXECUTION_ENVIRONMENT="${EXECUTION_ENVIRONMENT}" temn.msf.max.file.upload.size="${MAX_FILE_UPLOAD_SIZE}" temn.msf.storage.home="${RESOURCE_STORAGE_HOME}" className_DoInputValidation="${DOINPUTVALIDATION}" className_paymentscheduler="${PAYMENT_SCHEDULER}" temn.entitlement.stubbed.service.enabled="${ENTITLEMENT_STUBBED_SERVICE_ENABLED}" schedulerTime="${SCHEDULER_TIME}" operationId=paymentscheduler className_initiateDbMigration="${INITIATE_DBMIGRATION}" className_getDbMigrationStatus="${GET_DBMIGRATION}" temn.msf.azure.storage.connection.string="${AZURE_STORAGE_CONNECTION_STRING}" temn.keystore.database.url="${DATABASE_CONNECTIONURL}" temn.keystore.database.driver=org.postgresql.Driver temn.keystore.database.user="${DATABASE_USERNAME}" temn.keystore.database.password="${DATABASE_PASSWORD}" temn.msf.stream.kafka.ssl.enabled="${STREM_SSL_ENABLED}" temn.msf.stream.security.kafka.security.protocol="${STREAM_KAFKA_PROTOCOL}" temn.msf.stream.kafka.sasl.mechanism="${STREAM_KAFKA_SASL_MECHANISM}" SqlInboxCleanupSchedulerTime="${SQL_INBOX_CLEANUP_SCHEDULER_TIME}" className_sqlinboxcleanup="${SQL_INBOX_SCHEDULER}" temn.msf.scheduler.inboxcleanup.schedule="${INBOX_CLEANUP_MINUTES}" ENVIRONMENT_CONF="${ENVIRONMENT_CONF}" operationId=paymentscheduler temn.meter.disabled="${METER_DISABLE}" temn.msf.tracer.enabled="${TRACER_ENABLED}" temn.msf.ingest.event.ingester=com.temenos.microservice.framework.core.ingester.MicroserviceIngester PAYMENT_ORDEREvent=com.temenos.microservice.paymentorder.ingester.PaymentorderIngesterUpdater temn.msf.ingest.event.processor=com.temenos.microservice.paymentorder.ingester.EventHandlerImpl temn.msf.ingest.event.processor.POAccepted=com.temenos.microservice.paymentorder.ingester.PoHandlerImpl temn.msf.outbox.direct.delivery.enabled="${EVENTDIRECTLYDELIVERY}" temn.msf.audit.enabled="${ENABLE_AUDIT}" temn.msf.audit.get.enabled="${ENABLE_AUDIT_FOR_GET_API}" temn.msf.audit.response.enabled="${ENABLE_AUDIT_TO_CAPTURE_RESPONSE}"



#Environment variable settings for paymentslistenerapp functionapp
az functionapp config appsettings set --name "${OUTBOX_LISTENER_APP_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETPAYMENTS}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_GetPaymentOrder="${GETPAYMENT}" className_invokePaymentState="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}" className_GetPaymentOrderCurrency="${GET_CURRENCY}" DATABASE_NAME="${DATABASE_NAME}" DB_CONNECTION_URL="${DB_CONNECTION_URL}" DRIVER_NAME="${DRIVER_NAME}" DIALECT="${DIALECT}" DB_PASSWORD="${DB_PASSWORD}" DB_USERNAME="${DB_USERNAME}" JAVA_OPTS="${JAVA_OPTS}" temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_sink_error_stream="${ERROR_STREAM}" temn.msf.ingest.generic.ingester="${GENERIC_INGESTER}" temn.msf.azure.storage.connection.string="${AZURE_STORAGE_CONNECTION_STRING}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" eventHubConnection="${eventHubConnection}" eventHubName="${EVENT_HUB_OUTBOX}" eventHubConsumerGroup="${EVENT_HUB_OUTBOX_CG}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" DATABASE_KEY=sql temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}" temn.msf.ingest.generic.ingester="${INBOXOUTBOX_INGESTER}" temn.exec.env="${EXEC_ENV}" temn.msf.stream.outbox.topic="${OUTBOX_TOPIC}"class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" temn.queue.impl="${QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}"  temn.msf.stream.vendor.outbox="${QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}" MIN_POOL_SIZE="${DB_CONNECTION_MIN_POOL_SIZE}" MAX_POOL_SIZE="${DB_CONNECTION_MAX_POOL_SIZE}" className_FileDownload="${FILE_DOWNLOAD}" className_FileDelete="${FILE_DELETE}" className_FileUpload="${FILE_UPLOAD}" temn.msf.storage.home="${RESOURCE_STORAGE_HOME}" temn.msf.ingest.is.cloud.event="${CLOUD_EVENT_FLAG}" EXECUTION_ENVIRONMENT="${EXECUTION_ENVIRONMENT}" SqlInboxCleanupSchedulerTime="${SQL_INBOX_CLEANUP_SCHEDULER_TIME}" className_sqlinboxcleanup="${SQL_INBOX_SCHEDULER}" temn.msf.scheduler.inboxcleanup.schedule="${INBOX_CLEANUP_MINUTES}" ENVIRONMENT_CONF="${ENVIRONMENT_CONF}" operationId=paymentscheduler temn.meter.disabled="${METER_DISABLE}" temn.msf.tracer.enabled="${TRACER_ENABLED}" temn.msf.outbox.direct.delivery.enabled="${EVENTDIRECTLYDELIVERY}" temn.msf.audit.enabled="${ENABLE_AUDIT}" temn.msf.audit.get.enabled="${ENABLE_AUDIT_FOR_GET_API}" temn.msf.audit.response.enabled="${ENABLE_AUDIT_TO_CAPTURE_RESPONSE}"

# Set environment variables for appinit function app
az functionapp config appsettings set --name "${APPINT_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings DATABASE_NAME="${DATABASE_NAME}" DB_CONNECTION_URL="${DB_CONNECTION_URL}" DRIVER_NAME="${DRIVER_NAME}" DIALECT="${DIALECT}" DB_PASSWORD="${DB_PASSWORD}" DB_USERNAME="${DB_USERNAME}" DATABASE_KEY=sql  temn_msf_name="${MSF_NAME}"  EXECUTION_ENV="${EXECUTION_ENV}" class_package_name="${PACKAGE_NAME}"  tem_msf_disableInbox="${TEM_APPINIT_DISABLEINBOX}" temn_msf_security_authz_enabled="${APPINIT_AUTHZ_ENABLED}" temn_msf_database_auto_upgrade="${DB_AUTO_UPGRADE}" JPA_ENABLED="${JPA_ENABLED}" MIN_POOL_SIZE="${DB_CONNECTION_MIN_POOL_SIZE}" MAX_POOL_SIZE="${DB_CONNECTION_MAX_POOL_SIZE}"

sleep 10

#Execute appinit api which internally creates tables and indexes for first time and also executes scripts for DB upgrade.
curl -H "Content-Type: application/json" -X POST https://${APPINT_NAME}.azurewebsites.net/api/v1.0.0/dbmigration?code=${MASTER_KEY}