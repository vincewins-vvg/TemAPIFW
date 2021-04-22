@echo on

CALL db/repackbuild.bat ms-paymentorder postgresql

REM configuration details
SET RESOURCE_GROUP_NAME="paymentorder"
SET LOCATION="UK South"
SET DB_NAME_SPACE="paymentorderdb"
SET DB_NAME="paymentorderdb"
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

SET DATABASE_KEY="postgresql"
SET DATABASE_USERNAME="myadmin@paymentorderdb"
SET DATABASE_PASSWORD="Passw0rd!"
SET DATABASE_CONNECTIONURL="jdbc:postgresql://paymentorderdb.postgres.database.azure.com:5432/paymentorderdb"

SET ms_security_tokencheck_enabled=Y
SET EXECUTION_ENVIRONMENT="TEST"
SET RESOURCE_STORAGE_NAME="paymentordernosql"
SET RESOURCE_STORAGE_HOME="blob://paymentorder"
SET MAX_FILE_UPLOAD_SIZE=70
SET SCHEDULER_TIME="0 */50 * * * *"
SET JWT_TOKEN_PRINCIPAL_CLAIM="sub"
SET JWT_TOKEN_ISSUER="https://localhost:9443/oauth2/token"
SET ID_TOKEN_SIGNED="true"
SET JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
SET ENTITLEMENT_STUBBED_SERVICE_ENABLED="true"
SET INITIATE_DBMIGRATION="com.temenos.microservice.framework.dbmigration.core.InitiateDbMigrationImpl"
SET GET_DBMIGRATION="com.temenos.microservice.framework.dbmigration.core.GetDbMigrationImpl"
SET CLOUD_EVENT_FLAG="true" 

SET STREM_SSL_ENABLED="true"
SET STREAM_KAFKA_PROTOCOL=SASL_SSL
SET STREAM_KAFKA_SASL_MECHANISM=PLAIN
	
call az postgres server create --resource-group %RESOURCE_GROUP_NAME% --name %DB_NAME_SPACE%  --location %LOCATION% --admin-user "myadmin" --admin-password %DATABASE_PASSWORD% --sku-name GP_Gen5_2 

rem Create a database
call az postgres db create --resource-group %RESOURCE_GROUP_NAME% --name %DB_NAME_SPACE% --server-name %DB_NAME_SPACE%
REM call az postgres db create --resource-group %RESOURCE_GROUP_NAME% --name %DB_NAME_SPACE% --db-name %DB_NAME%

call az postgres server firewall-rule create --resource-group %RESOURCE_GROUP_NAME% --server %DB_NAME_SPACE% --name AllowMyIP --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255

rem deployment azure package into azure enviornment
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%APP_NAME% -f pom-azure-deploy.xml -X

rem OutboxListener function
call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%INBOXOUTBOXAPPNAME% -f pom-azure-deploy.xml -X

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

rem Reterive storage account connection string
call az storage account show-connection-string -g %RESOURCE_GROUP_NAME% -n %RESOURCE_STORAGE_NAME% | python -c "import json,sys;apis=json.load(sys.stdin); print(apis['connectionString'])" >> out1.txt
set /p storageconnectionString=< out1.txt
set AZURE_STORAGE_CONNECTION_STRING=%storageconnectionString%
del out1.txt

rem Environment variable settings
call az functionapp config appsettings set --name %APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETpaymentorder% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokepaymentordertate=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK% DATABASE_KEY=%DATABASE_KEY% POSTGRESQL_CONNECTIONURL=%DATABASE_CONNECTIONURL% POSTGRESQL_USERNAME=%DATABASE_USERNAME% POSTGRESQL_PASSWORD=%DATABASE_PASSWORD%  temn.msf.security.authz.enabled=%AUTHZ_ENABLED% temn_msf_name=%MSF_NAME% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB% eventHubConsumerGroup=%EVENT_HUB_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.exec.env=%EXEC_ENV% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER% temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% ms_security_tokencheck_enabled=%ms_security_tokencheck_enabled% EXECUTION_ENVIRONMENT=%EXECUTION_ENVIRONMENT% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% temn.msf.storage.home=%RESOURCE_STORAGE_HOME% className_DoInputValidation=%DOINPUTVALIDATION%  className_paymentscheduler=%PAYMENT_SCHEDULER% temn.entitlement.stubbed.service.enabled=%ENTITLEMENT_STUBBED_SERVICE_ENABLED% schedulerTime=%SCHEDULER_TIME% operationId=paymentscheduler className_initiateDbMigration=%INITIATE_DBMIGRATION% className_getDbMigration=%GET_DBMIGRATION% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% temn.keystore.database.url=%DATABASE_CONNECTIONURL% temn.keystore.database.driver=org.postgresql.Driver temn.keystore.database.user=%DATABASE_USERNAME% temn.keystore.database.password=%DATABASE_PASSWORD% temn.msf.stream.kafka.ssl.enabled=%STREM_SSL_ENABLED% temn.msf.stream.security.kafka.security.protocol=%STREAM_KAFKA_PROTOCOL% temn.msf.stream.kafka.sasl.mechanism=%STREAM_KAFKA_SASL_MECHANISM%

rem Environment variable settings
call az functionapp config appsettings set --name %INBOXOUTBOXAPPNAME% --resource-group %RESOURCE_GROUP_NAME% --settings className_CreateNewPaymentOrder=%CREATEPAYMENT% className_GetPaymentOrders=%GETpaymentorder% className_UpdatePaymentOrder=%UPDATEPAYMENT% className_GetPaymentOrder=%GETPAYMENT% className_invokepaymentordertate=%INVEPAYMENT% className_getHealthCheck=%HEATHCHECK% DATABASE_KEY=%DATABASE_KEY% POSTGRESQL_CONNECTIONURL=%DATABASE_CONNECTIONURL% POSTGRESQL_USERNAME=%DATABASE_USERNAME% POSTGRESQL_PASSWORD=%DATABASE_PASSWORD%  temn.msf.security.authz.enabled=%AUTHZ_ENABLED% temn_msf_name=%MSF_NAME% EXECUTION_ENV=%EXECUTION_ENV% eventHubConnection=%eventHubConnection% eventHubName=%EVENT_HUB_OUTBOX% eventHubConsumerGroup=%EVENT_HUB_OUTBOX_CG% VALIDATE_PAYMENT_ORDER=%VALIDATE_PAYMENT_ORDER% class.outbox.dao=%OUTBOX_DAO% class.inbox.dao=%INBOX_DAO% temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.generic.ingester=%INBOXOUTBOX_INGESTER% temn.exec.env=%EXEC_ENV% class.package.name=%PACKAGE_NAME% temn.msf.function.class.CreateNewPaymentOrder=%CreateNewPaymentOrder% temn.queue.impl=%QUEUE_IMPL% temn.msf.stream.kafka.sasl.enabled=%SSL_ENABLED% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% temn.msf.stream.kafka.bootstrap.servers=%KAFKA_SERVER% temn.msf.stream.vendor.outbox=%QUEUE_IMPL% temn.msf.ingest.consumer.max.poll.records=%MAX_POLL_RECORDS% temn.msf.ingest.is.avro.event.ingester=%AVRO_INGEST_EVENT% className_FileDownload=%FILE_DOWNLOAD% className_FileUpload=%FILE_UPLOAD% temn.msf.storage.home=%RESOURCE_STORAGE_HOME% className_initiateDbMigration=%INITIATE_DBMIGRATION% className_getDbMigration=%GET_DBMIGRATION% temn.msf.azure.storage.connection.string=%AZURE_STORAGE_CONNECTION_STRING% temn.msf.ingest.is.cloud.event=%CLOUD_EVENT_FLAG% temn.keystore.database.url=%DATABASE_CONNECTIONURL% temn.keystore.database.driver=org.postgresql.Driver temn.keystore.database.user=%DATABASE_USERNAME% temn.keystore.database.password=%DATABASE_PASSWORD% temn.msf.stream.kafka.ssl.enabled=%STREM_SSL_ENABLED% temn.msf.stream.security.kafka.security.protocol=%STREAM_KAFKA_PROTOCOL% temn.msf.stream.kafka.sasl.mechanism=%STREAM_KAFKA_SASL_MECHANISM%

call java -cp target/azure-functions/%APP_NAME%/lib/microservice-package-azure-resources-DEV.0.0-SNAPSHOT.jar -Drds_instance_host=%DATABASE_CONNECTIONURL% -Drds_instance_username="myadmin@paymentorderdb" -Drds_instance_password=%DATABASE_PASSWORD% -DScript_Path=db/postgresql/postgresqlinit.sql com.temenos.microservice.azure.query.execution.AzurePostgresqlScriptExecution