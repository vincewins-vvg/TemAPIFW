@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM DB PROPERTIES
SET DB_NAME=ms_paymentorder
SET DATABASE_KEY=postgresql
SET POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb

REM Set the below to 'Y' to fetch the DB username and DB password through k8s secrets
SET POSTGRESQL_CRED="N"

REM - Build paymentorder images
SET JWT_TOKEN_ISSUER=https://localhost:9443/oauth2/token
SET JWT_TOKEN_PRINCIPAL_CLAIM=sub
SET ID_TOKEN_SIGNED=true
SET JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=""

SET tag="DEV"
SET apiImage=dev.local/temenos/ms-paymentorder-service
SET ingesterImage=dev.local/temenos/ms-paymentorder-ingester
SET inboxoutboxImage=dev.local/temenos/ms-paymentorder-inboxoutbox
SET schedulerImage=dev.local/temenos/ms-paymentorder-scheduler
SET fileingesterImage=dev.local/temenos/ms-paymentorder-fileingester
SET schemaregistryImage=confluentinc/cp-schema-registry

SET dbinitImage=dev.local/temenos/ms-paymentorder-dbscripts

SET poImagePullSecret=""
SET dbinitImagePullSecret=""

SET POSTGRESQL_USERNAME=paymentorderusr
SET POSTGRESQL_PASSWORD=paymentorderpass

SET temn_msf_db_pass_encryption_key=temenos
SET temn_msf_db_pass_encryption_algorithm=PBEWithMD5AndTripleDES
SET gcbasepath="http://localhost:7006/ms-genericconfig-api/api/v2.0.0/"

REM -------- KAFKA
SET kafkabootstrapservers="my-cluster-kafka-bootstrap.kafka:9092"

REM --- To enable hostAliases, set the below variable to "Y"
SET kafkaAliases="N"

REM --- Set the following variables for hostAliases
SET kafkaip=""
SET kafka0ip=""
SET kafka1ip=""
SET kafka2ip=""
SET devdomain=""

SET kafkaHostName=""
SET kafka0HostName=""
SET kafka1HostName=""
SET kafka2HostName=""
SET devdomainHostName=""

cd ../..

call build-Postgresql.bat build

cd k8/on-premise/db

IF EXIST "start-postgresqldb-scripts-k8.bat" DEL start-postgresqldb-scripts-k8.bat
setLocal EnableDelayedExpansion
For /f "tokens=* delims= " %%a in (start-postgresqldb-scripts.bat) do (
Set str=%%a
set str=!str:docker-compose=REM!
echo !str!>>start-postgresqldb-scripts-k8.bat
)
ENDLOCAL

call start-postgresqldb-scripts-k8.bat


cd ../

kubectl create namespace paymentorder

helm install ponosql ./svc --set env.database.POSTGRESQL_CONNECTIONURL=%POSTGRESQL_CONNECTIONURL% --set env.database.MONGODB_DBNAME=%DB_NAME% --set env.database.DATABASE_KEY=%DATABASE_KEY% --set pit.JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% --set pit.ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED% --set pit.JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% --set env.database.temn_msf_db_pass_encryption_key=%temn_msf_db_pass_encryption_key% --set env.database.temn_msf_db_pass_encryption_algorithm=%temn_msf_db_pass_encryption_algorithm% --set env.genericconfig.basepath=%gcbasepath% --set image.paymentorderapi.repository=%apiImage% --set image.paymentorderingester.repository=%ingesterImage% --set image.paymentorderscheduler.repository=%schedulerImage% --set image.paymentorderinboxoutbox.repository=%inboxoutboxImage% --set image.fileingester.repository=%fileingesterImage% --set image.schemaregistry.repository=%schemaregistry% --set imagePullSecrets=%poImagePullSecret% --set image.tag=%tag% --set env.kafka.kafkabootstrapservers=%kafkabootstrapservers% --set env.kafka.kafkaAliases=%kafkaAliases% --set env.kafka.kafkaip=%kafkaip% --set env.kafka.kafka0ip=%kafka0ip% --set env.kafka.kafka1ip=%kafka1ip% --set env.kafka.kafka2ip=%kafka2ip% --set env.kafka.kafkaHostName=%kafkaHostName% --set env.kafka.kafka0HostName=%kafka0HostName% --set env.kafka.kafka1HostName=%kafka1HostName% --set env.kafka.kafka2HostName=%kafka2HostName% --set env.kafka.devdomainHostName=%devdomainHostName% --set env.database.POSTGRESQL_USERNAME=%POSTGRESQL_USERNAME% --set env.database.POSTGRESQL_PASSWORD=%POSTGRESQL_PASSWORD% --set env.database.POSTGRESQL_CRED=%POSTGRESQL_CRED%  


cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f paymentorder-api-nodeport.yaml -n paymentorder

cd ../..