@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

SET JWT_TOKEN_ISSUER=https://localhost:9443/oauth2/token
SET JWT_TOKEN_PRINCIPAL_CLAIM=sub
SET ID_TOKEN_SIGNED=true
SET JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=""

REM Database properties
SET DATABASE_KEY=sql
SET DB_HOST=paymentorder-db-service-np
SET DATABASE_NAME=payments
SET DB_USERNAME=root
SET DB_PASSWORD=password
SET DRIVER_NAME=com.mysql.jdbc.Driver
SET DIALECT=org.hibernate.dialect.MySQL5InnoDBDialect
SET DB_CONNECTION_URL=jdbc:mysql://paymentorder-db-service:3306/payments
SET MIN_POOL_SIZE="10"
SET MAX_POOL_SIZE="150"

REM -------- KAFKA
SET kafkabootstrapservers="my-cluster-kafka-bootstrap.kafka:9092"
SET schema_registry_url="http://schema-registry-svc.kafka.svc.cluster.local" 
SET schedulertime="59 * * ? * *"

REM --- To enable hostAliases, set the below variable to "Y"
SET kafkaAliases="N"

REM --- Set the following variables for hostAliases
SET kafkaip=""
SET kafka0ip=""
SET kafka1ip=""
SET kafka2ip=""

SET kafkaHostName=""
SET kafka0HostName=""
SET kafka1HostName=""
SET kafka2HostName=""

REM ------- IMAGE PROPERTIES
SET tag=DEV
SET apiImage=temenos/ms-paymentorder-service
SET ingesterImage=temenos/ms-paymentorder-ingester
SET inboxoutboxImage=temenos/ms-paymentorder-inboxoutbox
SET schemaregistryImage=confluentinc/cp-schema-registry
SET schedulerImage=temenos/ms-paymentorder-scheduler
SET fileingesterImage=temenos/ms-paymentorder-fileingester
SET mysqlImage=ms-paymentorder-mysql

SET esImagePullSecret=""

cd ../..

call build.bat build

cd k8/on-premise/db

IF EXIST "start-sqldb-scripts-k8.bat" DEL start-sqldb-scripts-k8.bat
setLocal EnableDelayedExpansion
For /f "tokens=* delims= " %%a in (start-sqldb-scripts.bat) do (
Set str=%%a
set str=!str:docker-compose=REM!
echo !str!>>start-sqldb-scripts-k8.bat
)
ENDLOCAL

call start-sqldb-scripts-k8.bat

cd ../

helm install svc ./svc -n payments --set env.database.host=%DB_HOST% --set env.database.db_username=%DB_USERNAME% --set env.database.db_password=%DB_PASSWORD% --set env.database.database_key=%DATABASE_KEY% --set env.database.database_name=%DATABASE_NAME% --set env.database.driver_name=%DRIVER_NAME% --set env.database.dialect=%DIALECT% --set env.database.db_connection_url=%DB_CONNECTION_URL% --set pit.JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% --set pit.ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED% --set pit.JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% --set env.database.max_pool_size=%MAX_POOL_SIZE% --set env.database.min_pool_size=%MIN_POOL_SIZE% --set env.kafka.kafkabootstrapservers=%kafkabootstrapservers% --set env.kafka.schema_registry_url=%schema_registry_url% --set env.kafka.kafkaAliases=%kafkaAliases% --set env.kafka.kafkaip=%kafkaip% --set env.kafka.kafka0ip=%kafka0ip% --set env.kafka.kafka1ip=%kafka1ip% --set env.kafka.kafka2ip=%kafka2ip% --set env.kafka.kafkaHostName=%kafkaHostName% --set env.kafka.kafka0HostName=%kafka0HostName% --set env.kafka.kafka1HostName=%kafka1HostName% --set env.kafka.kafka2HostName=%kafka2HostName% --set env.scheduler.time=%schedulertime% --set image.tag=%tag% --set image.paymentsapi.repository=%apiImage% --set image.paymentsingester.repository=%ingesterImage% --set image.paymentseventdelivery.repository=%inboxoutboxImage% --set image.schemaregistry.repository=%schemaregistryImage% --set image.paymentorderscheduler.repository=%schedulerImage% --set image.fileingester.repository=%fileingesterImage% --set image.mysql.repository=%mysqlImage% --set imagePullSecrets=%esImagePullSecret%

REM docker-compose -f kafka.yml -f paymentorder-nuo.yml %*


cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f payments-nodeport.yaml -n payments 

cd ../..