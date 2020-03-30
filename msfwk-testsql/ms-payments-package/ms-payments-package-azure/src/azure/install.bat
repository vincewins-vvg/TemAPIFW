@echo on
REM configuration details
SET RESOURCE_GROUP_NAME="payments"
SET LOCATION="UK South"
SET DB_NAME_SPACE="paymentsserver"
SET DB_NAME="payments"
SET APP_NAME="paymentsapp"
SET CREATEPAYMENT=com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl
SET GETPAYMENTS=com.temenos.microservice.payments.function.GetPaymentOrdersImpl
SET UPDATEPAYMENT=com.temenos.microservice.payments.function.UpdatePaymentOrderImpl
SET GETPAYMENT=com.temenos.microservice.payments.function.GetPaymentOrderImpl
SET INVEPAYMENT=com.temenos.microservice.payments.function.InvokePaymentOrderImpl
SET HEATHCHECK=com.temenos.microservice.framework.core.function.camel.GetHealthCheckImpl
SET DATABASE_NAME="payments"
SET DB_PASSWORD="payments@123"
SET DB_USERNAME="paymentsadmin@paymentsserver"
SET DB_ADMIN_USERNAME="paymentsadmin"
SET DRIVER_NAME="com.mysql.jdbc.Driver"
SET DIALECT="org.hibernate.dialect.MySQL5InnoDBDialect"
SET DB_CONNECTION_URL="jdbc:mysql://paymentsserver.mysql.database.azure.com:3306/payments"
SET JAVA_OPTS="-Djava.net.preferIPv4Stack=true"
SET defaultExecutablePath="D:\Program Files\Java\jdk1.8.0_25\jre\bin\java"
SET AUTHZ_ENABLED="false"
SET EVENT_HUB_NAME_SPACE="payments-Kafka"
SET EVENT_HUB="paymentorder-outbox"
SET eventHubConnection="TEST"
REM SET INGEST_EVENT_INGESTER="com.temenos.microservice.framework.core.ingester.MicroserviceIngester"
SET ERROR_STREAM="error-paymentorder"
SET MSF_NAME="PaymentOrder"
SET REGISTRY_URL="IF.EVENTS.INTERFACE.TABLE,Data"
SET EXECUTION_ENV="TEST"
SET VALIDATE_PAYMENT_ORDER="false"
SET INBOX_DAO="com.temenos.microservice.framework.core.inbox.InboxDaoImpl"
SET OUTBOX_DAO="com.temenos.microservice.framework.core.outbox.OutboxDaoImpl"
SET INGEST_SOURCE_STREAM="paymentorder-outbox"
SET SINK_ERROR_STREAM="ms-paymentorder-inbox-error-topic"
REM SET GENERIC_INGESTER="com.temenos.microservice.framework.core.ingester.GenericCommandBinaryIngester"
SET GENERIC_INGESTER="com.temenos.microservice.framework.core.ingester.MSKafkaOutboxEventListener"
SET EXEC_ENV="serverless"
SET OUTBOX_TOPIC="ms-paymentorder-outbox-topic"
SET CreateNewPaymentOrder="com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl"
SET PACKAGE_NAME="com.temenos.microservice.payments.function"
SET AVRO_INGEST_EVENT="false"
SET QUEUE_IMPL="kafka"
SET KAFKA_SERVER="payments-kafka.servicebus.windows.net:9093"
SET SSL_ENABLED="true"
SET SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://payments-kafka.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=yUoa/1dlVqghGSUhf3YWUH5v7sbz9stw5ozyk8MaCx8=\";"
 

rem Create a resource resourceGroupName
call az group create --name %RESOURCE_GROUP_NAME%   --location %LOCATION%

call az mysql server create --name %DB_NAME_SPACE% --resource-group %RESOURCE_GROUP_NAME% --location %LOCATION% --admin-user %DB_ADMIN_USERNAME% --admin-password %DB_PASSWORD% --sku-name GP_Gen5_2 

call az mysql server firewall-rule create --resource-group %RESOURCE_GROUP_NAME% --server %DB_NAME_SPACE% --name AllowIps --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255

call az  mysql db create --name %DB_NAME% --resource-group %RESOURCE_GROUP_NAME% --server-name %DB_NAME_SPACE%

call az mysql server configuration set --name time_zone --resource-group %RESOURCE_GROUP_NAME% --server %DB_NAME_SPACE% --value "+8:00"

rem deployment azure package into azure enviornment
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%APP_NAME% -f pom-azure-deploy.xml -X

rem Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.
call az eventhubs namespace create --name %EVENT_HUB_NAME_SPACE% --resource-group %RESOURCE_GROUP_NAME% -l %LOCATION% --enable-kafka true

rem Create an event hub. Specify a name for the event hub. 
call az eventhubs eventhub create --name %EVENT_HUB% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

rem Reterive event hub connection string
call az eventhubs namespace authorization-rule keys list --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])" >> out.txt
set /p eventHubConnection=< out.txt
del out.txt

REM temn_msf_ingest_event_ingester=%INGEST_EVENT_INGESTER%
rem Environment variable settings
call az functionapp config appsettings set --name %APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETPAYMENTS% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokePaymentState=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK%  DATABASE_NAME=%DATABASE_NAME% DB_CONNECTION_URL=%DB_CONNECTION_URL% DRIVER_NAME=%DRIVER_NAME% DIALECT=%DIALECT% DB_PASSWORD=%DB_PASSWORD% DB_USERNAME=%DB_USERNAME% JAVA_OPTS=%JAVA_OPTS% languageWorkers:java:defaultExecutablePath=%defaultExecutablePath% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% DATABASE_KEY=sql temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.sink.error.stream=%SINK_ERROR_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% temn.msf.stream.outbox.topic=%OUTBOX_TOPIC% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER%