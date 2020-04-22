#!/bin/bash -x
# configuration details
export RESOURCE_GROUP_NAME="payments"
export LOCATION="UK South"
export DB_NAME_SPACE="paymentsserver"
export DB_NAME="payments"
export APP_NAME="paymentsapp"
export OUTBOX_LISTENER_APP_NAME="paymentsapplistener"
export CREATEPAYMENT=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl
export GETPAYMENTS=com.temenos.microservice.payments.function.GetPaymentOrdersImpl
export UPDATEPAYMENT=com.temenos.microservice.payments.function.UpdatePaymentOrderImpl
export GETPAYMENT=com.temenos.microservice.payments.function.GetPaymentOrderImpl
export INVEPAYMENT=com.temenos.microservice.payments.function.InvokePaymentOrderImpl
export HEATHCHECK=com.temenos.microservice.framework.core.function.camel.GetHealthCheckImpl
export DATABASE_NAME="payments"
export DB_PASSWORD="payments@123"
export DB_USERNAME="paymentsadmin@paymentsserver"
export ADMIN_USER_NAME="paymentsadmin"
export DRIVER_NAME="com.mysql.jdbc.Driver"
export DIALECT="org.hibernate.dialect.MySQL5InnoDBDialect"
export DB_CONNECTION_URL="jdbc:mysql://paymentsserver.mysql.database.azure.com:3306/payments"
export JAVA_OPTS="-Djava.net.preferIPv4Stack=true"
export defaultExecutablePath="D:\Program Files\Java\jdk1.8.0_25\jre\bin\java"
export AUTHZ_ENABLED="false"
export EVENT_HUB_NAME_SPACE="payments-Kafka"
export EVENT_HUB_OUTBOX="PaymentOrder-outbox"
export EVENT_HUB="payments"
export eventHubConnection="TEST"
export INGEST_EVENT_INGESTER="com.temenos.microservice.framework.core.ingester.MicroserviceIngester"
export ERROR_STREAM="error-paymentorder"
export MSF_NAME="PaymentOrder"
export REGISTRY_URL="IF.EVENTS.INTERFACE.TABLE,Data"
export EXECUTION_ENV="TEST"
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
export CreateNewPaymentOrder="com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl"
export PACKAGE_NAME="com.temenos.microservice.payments.function"
export AVRO_INGEST_EVENT="false"
export QUEUE_IMPL="kafka"
export KAFKA_SERVER="payments-kafka.servicebus.windows.net:9093"
export SSL_ENABLED="true"
export MAX_POLL_RECORDS=20
export SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://payments-kafka.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=yUoa/1dlVqghGSUhf3YWUH5v7sbz9stw5ozyk8MaCx8=\";"

# Create a resource resourceGroupName
az group create --name "${RESOURCE_GROUP_NAME}"   --location "${LOCATION}"

az mysql server create --name "${DB_NAME_SPACE}" --resource-group "${RESOURCE_GROUP_NAME}" --location "${LOCATION}" --admin-user "${ADMIN_USER_NAME}" --admin-password "${DB_PASSWORD}" --sku-name GP_Gen5_4 

az mysql server firewall-rule create --resource-group "${RESOURCE_GROUP_NAME}" --server $DB_NAME_SPACE --name AllowIps --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255

az mysql db create --name "payments" --resource-group "${RESOURCE_GROUP_NAME}" --server-name "${DB_NAME_SPACE}"

az mysql server configuration set --name time_zone --resource-group "${RESOURCE_GROUP_NAME}" --server "${DB_NAME_SPACE}" --value "+8:00"

# deployment azure package into azure enviornment
mvn -Pdeploy azure-functions:deploy -Dazure.region="${LOCATION}" -Dazure.resourceGroup="${RESOURCE_GROUP_NAME}" -DappName="${APP_NAME}" -f pom-azure-deploy.xml -X

# OutboxListener function
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%OUTBOX_LISTENER_APP_NAME% -f pom-azure-deploy.xml -X 

# Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.
az eventhubs namespace create --name "${EVENT_HUB_NAME_SPACE}" --resource-group "${RESOURCE_GROUP_NAME}" -l "${LOCATION}" --enable-kafka true

# Create an event hub. Specify a name for the event hub. 
az eventhubs eventhub create --name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

# Create an Event hub for OutboxEventId Topic
call az eventhubs eventhub create --name "${EVENT_HUB_OUTBOX}" --resource-group %RESOURCE_GROUP_NAME% --namespace-name "${EVENT_HUB_NAME_SPACE}"

# Reterive event hub connection string
export eventHubConnection=$(az eventhubs namespace authorization-rule keys list --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])" )

# Environment variable settings
az functionapp config appsettings set --name "${APP_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETPAYMENTS}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_GetPaymentOrder="${GETPAYMENT}" className_invokePaymentState="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}"  DATABASE_NAME="${DATABASE_NAME}" DB_PASSWORD="${DB_PASSWORD}" DB_USERNAME="${DB_USERNAME}" JAVA_OPTS="${JAVA_OPTS}" DB_CONNECTION_URL="${DB_CONNECTION_URL}" DRIVER_NAME="${DRIVER_NAME}" DIALECT="${DIALECT}" languageWorkers:java:defaultExecutablePath="${defaultExecutablePath}" temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_event_ingester="${INGEST_EVENT_INGESTER}" temn_msf_ingest_sink_error_stream="${ERROR_STREAM}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" DATABASE_KEY=sql eventHubConnection="${eventHubConnection}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" eventHubName="${EVENT_HUB}" class.outbox.dao="${OUTBOX_DAO}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" DATABASE_KEY=sql temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}"
temn.msf.ingest.generic.ingester="${GENERIC_INGESTER}" temn.exec.env="${EXEC_ENV}" temn.msf.stream.outbox.topic="${OUTBOX_TOPIC}" class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" temn.queue.impl="${%QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}" temn.msf.stream.vendor.outbox="${%QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}"

# Environment variable settings
az functionapp config appsettings set --name "${OUTBOX_LISTENER_APP_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --settings className_CreateNewPaymentOrder="${CREATEPAYMENT}" className_GetPaymentOrders="${GETPAYMENTS}" className_UpdatePaymentOrder="${UPDATEPAYMENT}" className_GetPaymentOrder="${GETPAYMENT}" className_invokePaymentState="${INVEPAYMENT}" className_getHealthCheck="${HEATHCHECK}"  DATABASE_NAME="${DATABASE_NAME}" DB_PASSWORD="${DB_PASSWORD}" DB_USERNAME="${DB_USERNAME}" JAVA_OPTS="${JAVA_OPTS}" DB_CONNECTION_URL="${DB_CONNECTION_URL}" DRIVER_NAME="${DRIVER_NAME}" DIALECT="${DIALECT}" languageWorkers:java:defaultExecutablePath="${defaultExecutablePath}" temn.msf.security.authz.enabled="${AUTHZ_ENABLED}" WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_event_ingester="${INGEST_EVENT_INGESTER}" temn_msf_ingest_sink_error_stream="${ERROR_STREAM}" temn_msf_name="${MSF_NAME}" temn_msf_schema_registry_url="${REGISTRY_URL}" EXECUTION_ENV="${EXECUTION_ENV}" DATABASE_KEY=sql eventHubConnection="${eventHubConnection}" VALIDATE_PAYMENT_ORDER="${VALIDATE_PAYMENT_ORDER}" eventHubName="${EVENT_HUB_OUTBOX}" class.outbox.dao="${OUTBOX_DAO}" class.outbox.dao="${OUTBOX_DAO}" class.inbox.dao="${INBOX_DAO}" DATABASE_KEY=sql temn.msf.ingest.source.stream="${INGEST_SOURCE_STREAM}" temn.msf.ingest.sink.error.stream="${SINK_ERROR_STREAM}"
temn.msf.ingest.generic.ingester="${INBOXOUTBOX_INGESTER}" temn.exec.env="${EXEC_ENV}" temn.msf.stream.outbox.topic="${OUTBOX_TOPIC}" class.package.name="${PACKAGE_NAME}" temn.msf.function.class.CreateNewPaymentOrder="${CreateNewPaymentOrder}" temn.msf.ingest.is.avro.event.ingester="${AVRO_INGEST_EVENT}" temn.queue.impl="${%QUEUE_IMPL}" temn.msf.stream.kafka.sasl.enabled="${SSL_ENABLED}" temn.msf.stream.kafka.sasl.jaas.config="${SASL_JASS_CONFIG}" temn.msf.stream.kafka.bootstrap.servers="${KAFKA_SERVER}" temn.msf.stream.vendor.outbox="${%QUEUE_IMPL}" temn.msf.ingest.consumer.max.poll.records="${MAX_POLL_RECORDS}"