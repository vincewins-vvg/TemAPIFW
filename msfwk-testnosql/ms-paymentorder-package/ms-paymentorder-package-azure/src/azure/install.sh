#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#


# repacking db entity jar with api jar
./db/repackbuild.sh ms-paymentorder cassandra

# configuration details
export RESOURCE_GROUP_NAME="paymentorder"
export LOCATION="UK South"
export DB_NAME_SPACE="paymentorderserver"
export DB_NAME="paymentorder"
export DATABASE_KEY="cassandra"
export APP_NAME="paymentorderapp"
export INBOXOUTBOXAPPNAME="paymentorderapplistener"
export CREATEPAYMENT=com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl
export GETpaymentorder=com.temenos.microservice.paymentorder.function.GetPaymentOrdersImpl
export UPDATEPAYMENT=com.temenos.microservice.paymentorder.function.UpdatePaymentOrderImpl
export GETPAYMENT=com.temenos.microservice.paymentorder.function.GetPaymentOrderImpl
export INVEPAYMENT=com.temenos.microservice.paymentorder.function.InvokePaymentOrderImpl
export HEATHCHECK=com.temenos.microservice.framework.core.function.camel.GetHealthCheckImpl
export FILE_UPLOAD=com.temenos.microservice.paymentorder.function.FileUploadImpl
export FILE_DOWNLOAD=com.temenos.microservice.paymentorder.function.FileDownloadImpl
export DOINPUTVALIDATION=com.temenos.microservice.paymentorder.function.DoInputValidationImpl
export DATABASE_NAME="paymentorder"
export DB_PASSWORD="paymentorder@123"
export DB_USERNAME="paymentorderadmin@paymentorderserver"
export ADMIN_USER_NAME="paymentorderadmin"
export DRIVER_NAME="com.mysql.jdbc.Driver"
export DIALECT="org.hibernate.dialect.MySQL5InnoDBDialect"
export DB_CONNECTION_URL="jdbc:mysql://paymentorderserver.mysql.database.azure.com:3306/paymentorder"
export JAVA_OPTS="-Djava.net.preferIPv4Stack=true"
export defaultExecutablePath="D:\Program Files\Java\jdk1.8.0_25\jre\bin\java"
export AUTHZ_ENABLED="false"
export AVRO_INGEST_EVENT="false"
export EVENT_HUB_NAME_SPACE="paymentorder-Kafka"
export EVENT_HUB_OUTBOX="PaymentOrder-outbox"
export EVENT_HUB="paymentorder"
export EVENT_HUB_CG="paymentordercg"
export EVENT_HUB_OUTBOX_CG="paymentorderoutboxcg"
export eventHubConnection="TEST"
export INGEST_EVENT_INGESTER="com.temenos.microservice.framework.core.ingester.MicroserviceIngester"
export ERROR_STREAM="error-paymentorder"
export MSF_NAME="PaymentOrder"
export REGISTRY_URL="IF.EVENTS.INTERFACE.TABLE,Data"
export EXECUTION_ENV="serverless"
export VALIDATE_PAYMENT_ORDER="false"
export OUTBOX_DAO="com.temenos.microservice.framework.core.outbox.OutboxDaoImpl"
export INBOX_DAO="com.temenos.microservice.framework.core.inbox.InboxDaoImpl"
export INBOX_DAO="com.temenos.microservice.framework.core.inbox.InboxDaoImpl"
export OUTBOX_DAO="com.temenos.microservice.framework.core.outbox.OutboxDaoImpl"
export INGEST_SOURCE_STREAM="paymentorder-outbox"
export SINK_ERROR_STREAM="ms-paymentorder-inbox-error-topic"
export GENERIC_INGESTER="com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester"
export INBOXOUTBOX_INGESTER="com.temenos.microservice.framework.core.ingester.MSKafkaOutboxEventListener"
export EXEC_ENV="serverless"
export OUTBOX_TOPIC="ms-paymentorder-outbox-topic"
export CreateNewPaymentOrder="com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderImpl"
export PACKAGE_NAME="com.temenos.microservice.paymentorder.function"
export AVRO_INGEST_EVENT="false"
export QUEUE_IMPL="kafka"
export KAFKA_SERVER="paymentorder-kafka.servicebus.windows.net:9093"
export SSL_ENABLED="true"
export MAX_POLL_RECORDS=20
export MAX_FILE_UPLOAD_SIZE=70

export SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://paymentorder-kafka.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=yUoa/1dlVqghGSUhf3YWUH5v7sbz9stw5ozyk8MaCx8=\";"
export CREATE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.CreateReferenceDataImpl"
export ADD_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.AddReferenceDataImpl"
export UPDATE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.UpdateReferenceDataImpl"
export GET_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.GetReferenceDataImpl"
export DELETE_REFERENCE_DATA="com.temenos.microservice.framework.core.data.referencedata.DeleteReferenceDataImpl"
export ms_security_tokencheck_enabled=Y
export EXECUTION_ENVIRONMENT="TEST"
export SCHEDULER_TIME="0 */50 * * * *"
export OPERATION_ID="paymentscheduler"
export PAYMENT_SCHEDULER="com.temenos.microservice.paymentorder.scheduler.PaymentOrderScheduler"

export NOSQL_INBOX_CLEANUP_SCHEDULER_TIME="0 0/5 * * * *"
export INBOX_CLEANUP_MINUTES="60"
export NOSQL_INBOX_SCHEDULER="com.temenos.microservice.framework.scheduler.core.NoSqlInboxCatchupProcessor"

export CLOUD_EVENT_FLAG="true"

export EVENTDIRECTLYDELIVERY="true"

# Create a resource resourceGroupName
az group create --name "${RESOURCE_GROUP_NAME}"   --location "${LOCATION}"

az mysql server create --name "${DB_NAME_SPACE}" --resource-group "${RESOURCE_GROUP_NAME}" --location "${LOCATION}" --admin-user "${ADMIN_USER_NAME}" --admin-password "${DB_PASSWORD}" --sku-name GP_Gen5_4 

az mysql server firewall-rule create --resource-group "${RESOURCE_GROUP_NAME}" --server $DB_NAME_SPACE --name AllowIps --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255

az mysql db create --name "paymentorder" --resource-group "${RESOURCE_GROUP_NAME}" --server-name "${DB_NAME_SPACE}"

az mysql server configuration set --name time_zone --resource-group "${RESOURCE_GROUP_NAME}" --server "${DB_NAME_SPACE}" --value "+8:00"

# deployment azure package into azure enviornment
mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${APP_NAME}" -f pom-azure-deploy.xml -X

# OutboxListener function
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%INBOXOUTBOXAPPNAME% -f pom-azure-deploy.xml -X 

# Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.
az eventhubs namespace create --name "${EVENT_HUB_NAME_SPACE}" --resource-group "${RESOURCE_GROUP_NAME}" -l "${LOCATION}" --enable-kafka true

# Create an event hub. Specify a name for the event hub. 
az eventhubs eventhub create --name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

# Create an Event hub for OutboxEventId Topic
call az eventhubs eventhub create --name "${EVENT_HUB_OUTBOX}" --resource-group %RESOURCE_GROUP_NAME% --namespace-name "${EVENT_HUB_NAME_SPACE}"

# Create a consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_CG}"

# Create a consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_OUTBOX}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_OUTBOX_CG}"

# Reterive event hub connection string
export eventHubConnection=$(az eventhubs namespace authorization-rule keys list --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])" )

# Environment variable settings
az functionapp config appsettings set --name "${APP_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETpaymentorder}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_GetPaymentOrder="${GETPAYMENT}" className_invokepaymentordertate="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}" className_createReferenceData="${CREATE_REFERENCE_DATA}" className_getReferenceData="${GET_REFERENCE_DATA}" className_updateReferenceData="${UPDATE_REFERENCE_DATA}" className_addReferenceData="${ADD_REFERENCE_DATA}" className_deleteReferenceData="${DELETE_REFERENCE_DATA}" className_FileDownload="${FILE_DOWNLOAD}" className_FileUpload="${FILE_UPLOAD}" DATABASE_NAME="${DATABASE_NAME}" DB_PASSWORD="${DB_PASSWORD}" DB_USERNAME="${DB_USERNAME}" JAVA_OPTS="${JAVA_OPTS}" DB_CONNECTION_URL="${DB_CONNECTION_URL}" DRIVER_NAME="${DRIVER_NAME}" DIALECT="${DIALECT}" languageWorkers:java:defaultExecutablePath="${defaultExecutablePath}" temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_event_ingester="${INGEST_EVENT_INGESTER}" temn_msf_ingest_sink_error_stream="${ERROR_STREAM}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" DATABASE_KEY="${DATABASE_KEY}" eventHubConnection="${eventHubConnection}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" eventHubName="${EVENT_HUB}" eventHubConsumerGroup="${EVENT_HUB_CG}" class.outbox.dao="${OUTBOX_DAO}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}" temn.msf.max.file.upload.size="${MAX_FILE_UPLOAD_SIZE}" temn.msf.outbox.direct.delivery.enabled="${EVENTDIRECTLYDELIVERY}"
temn.msf.ingest.generic.ingester="${GENERIC_INGESTER}" temn.exec.env="${EXEC_ENV}" temn.msf.stream.outbox.topic="${OUTBOX_TOPIC}" class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" temn.queue.impl="${%QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}" temn.msf.stream.vendor.outbox="${%QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" ms_security_tokencheck_enabled=$ms_security_tokencheck_enabled EXECUTION_ENVIRONMENT=$EXECUTION_ENVIRONMENT className_DoInputValidation="${DOINPUTVALIDATION}" className_paymentscheduler="${PAYMENT_SCHEDULER}" schedulerTime="${SCHEDULER_TIME}" operationId="${OPERATION_ID}" NoSqlInboxCleanupSchedulerTime="${NOSQL_INBOX_CLEANUP_SCHEDULER_TIME}" className_nosqlinboxcleanup="${NOSQL_INBOX_SCHEDULER}" temn.msf.scheduler.inboxcleanup.schedule="${INBOX_CLEANUP_MINUTES}"

# Environment variable settings
az functionapp config appsettings set --name "${INBOXOUTBOXAPPNAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETpaymentorder}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_FileDownload="${FILE_DOWNLOAD}" className_FileUpload="${FILE_UPLOAD}" className_GetPaymentOrder="${GETPAYMENT}" className_invokepaymentordertate="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}" className_createReferenceData="${CREATE_REFERENCE_DATA}" className_getReferenceData="${GET_REFERENCE_DATA}" className_updateReferenceData="${UPDATE_REFERENCE_DATA}" className_addReferenceData="${ADD_REFERENCE_DATA}" className_deleteReferenceData="${DELETE_REFERENCE_DATA}" DATABASE_NAME="${DATABASE_NAME}" DB_PASSWORD="${DB_PASSWORD}" DB_USERNAME="${DB_USERNAME}" JAVA_OPTS="${JAVA_OPTS}" DB_CONNECTION_URL="${DB_CONNECTION_URL}" DRIVER_NAME="${DRIVER_NAME}" DIALECT="${DIALECT}" languageWorkers:java:defaultExecutablePath="${defaultExecutablePath}" temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_event_ingester="${INGEST_EVENT_INGESTER}" temn_msf_ingest_sink_error_stream="${ERROR_STREAM}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" DATABASE_KEY="${DATABASE_KEY}" eventHubConnection="${eventHubConnection}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" eventHubName="${EVENT_HUB_OUTBOX}" eventHubConsumerGroup="${EVENT_HUB_OUTBOX_CG}" class.outbox.dao="${OUTBOX_DAO}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}" temn.msf.ingest.generic.ingester="${INBOXOUTBOX_INGESTER}" temn.exec.env="${EXEC_ENV}" temn.msf.stream.outbox.topic="${OUTBOX_TOPIC}" class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" temn.queue.impl="${%QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}" temn.msf.stream.vendor.outbox="${%QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" temn.msf.ingest.is.cloud.event="${CLOUD_EVENT_FLAG}" temn.msf.outbox.direct.delivery.enabled="${EVENTDIRECTLYDELIVERY}"