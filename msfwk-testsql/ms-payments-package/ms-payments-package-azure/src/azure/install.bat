@echo on
REM configuration details
SET RESOURCE_GROUP_NAME="payments"
SET LOCATION="UK South"
SET DB_NAME_SPACE="paymentsserver"
SET DB_NAME="payments"
SET APP_NAME="paymentsapp"
SET OUTBOX_LISTENER_APP_NAME="paymentsapplistener"
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
SET DOINPUTVALIDATION="com.temenos.microservice.payments.function.DoInputValidationImpl"
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
SET EVENT_HUB_OUTBOX="PaymentOrder-outbox"
SET EVENT_HUB="payments"
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
SET ms_security_tokencheck_enabled=Y
SET EXECUTION_ENVIRONMENT="TEST"
SET MAX_FILE_UPLOAD_SIZE=70


rem Create a resource resourceGroupName
call az group create --name %RESOURCE_GROUP_NAME%   --location %LOCATION%

call az mysql server create --name %DB_NAME_SPACE% --resource-group %RESOURCE_GROUP_NAME% --location %LOCATION% --admin-user %DB_ADMIN_USERNAME% --admin-password %DB_PASSWORD% --sku-name GP_Gen5_2 

call az mysql server firewall-rule create --resource-group %RESOURCE_GROUP_NAME% --server %DB_NAME_SPACE% --name AllowIps --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255

call az  mysql db create --name %DB_NAME% --resource-group %RESOURCE_GROUP_NAME% --server-name %DB_NAME_SPACE%

call az mysql server configuration set --name time_zone --resource-group %RESOURCE_GROUP_NAME% --server %DB_NAME_SPACE% --value "+8:00"

rem deployment azure package into azure enviornment //Payments App
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%APP_NAME% -f pom-azure-deploy.xml -X

rem OutboxListener function
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%OUTBOX_LISTENER_APP_NAME% -f pom-azure-deploy.xml -X 

rem Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.
call az eventhubs namespace create --name %EVENT_HUB_NAME_SPACE% --resource-group %RESOURCE_GROUP_NAME% -l %LOCATION% --enable-kafka true

rem Create an event hub. Specify a name for the event hub. //GENERIC_INGESTER
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

rem create new Storage
call az storage account create -n %RESOURCE_STORAGE_NAME% -g %RESOURCE_GROUP_NAME% -l %LOCATION% --sku Standard_LRS

rem Reterive storage account connection string
call az storage account show-connection-string -g %RESOURCE_GROUP_NAME% -n %RESOURCE_STORAGE_NAME% | python -c "import json,sys;apis=json.load(sys.stdin); print(apis['connectionString'])" >> out1.txt
set /p storageconnectionString=< out1.txt
set AZURE_STORAGE_CONNECTION_STRING=%storageconnectionString%
del out1.txt

rem Environment variable settings
call az functionapp config appsettings set --name %APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETPAYMENTS% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokePaymentState=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK%  DATABASE_NAME=%DATABASE_NAME% DB_CONNECTION_URL=%DB_CONNECTION_URL% DRIVER_NAME=%DRIVER_NAME% DIALECT=%DIALECT% DB_PASSWORD=%DB_PASSWORD% DB_USERNAME=%DB_USERNAME% JAVA_OPTS=%JAVA_OPTS% languageWorkers:java:defaultExecutablePath=%defaultExecutablePath% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% DATABASE_KEY=sql temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.sink.error.stream=%SINK_ERROR_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% temn.msf.stream.outbox.topic=%OUTBOX_TOPIC% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER%  temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% className_createReferenceData=%CREATE_REFERENCE_DATA% className_getReferenceData=%GET_REFERENCE_DATA% className_updateReferenceData=%UPDATE_REFERENCE_DATA% className_addReferenceData=%ADD_REFERENCE_DATA% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% className_deleteReferenceData=%DELETE_REFERENCE_DATA% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% temn.msf.storage.home %RESOURCE_STORAGE_NAME%  ms_security_tokencheck_enabled=%ms_security_tokencheck_enabled% EXECUTION_ENVIRONMENT=%EXECUTION_ENVIRONMENT% className_DoInputValidation=%DOINPUTVALIDATION%

rem Environment variable settings for paymentslistenerapp functionapp
call az functionapp config appsettings set --name %OUTBOX_LISTENER_APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETPAYMENTS% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokePaymentState=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK%  DATABASE_NAME=%DATABASE_NAME% DB_CONNECTION_URL=%DB_CONNECTION_URL% DRIVER_NAME=%DRIVER_NAME% DIALECT=%DIALECT% DB_PASSWORD=%DB_PASSWORD% DB_USERNAME=%DB_USERNAME% JAVA_OPTS=%JAVA_OPTS% languageWorkers:java:defaultExecutablePath=%defaultExecutablePath% temn.msf.security.authz.enabled=%AUTHZ_ENABLED% WEBSITE_USE_PLACEHOLDER=0 temn_msf_ingest_sink_error_stream=%ERROR_STREAM% temn_msf_name=%MSF_NAME% temn_msf_schema_registry_url=%REGISTRY_URL% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB_OUTBOX% eventHubConsumerGroup=%EVENT_HUB_OUTBOX_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% DATABASE_KEY=sql temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.sink.error.stream=%SINK_ERROR_STREAM% temn.msf.ingest.generic.ingester=%INBOXOUTBOX_INGESTER% temn.exec.env=%EXEC_ENV% temn.msf.stream.outbox.topic=%OUTBOX_TOPIC% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER%  temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% MIN_POOL_SIZE=%DB_CONNECTION_MIN_POOL_SIZE% MAX_POOL_SIZE=%DB_CONNECTION_MAX_POOL_SIZE% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% 