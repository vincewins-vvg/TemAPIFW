@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------
SET MYSQL_CRED="N"
SET DATABASE_KEY=sql

SET DB_USERNAME=root
SET DB_PASSWORD=password
SET DB_NAME=payments
SET DB_DRIVER=com.mysql.jdbc.Driver
SET DB_DIALECT=org.hibernate.dialect.MySQL5InnoDBDialect
SET DB_CONNECTION_URL=jdbc:mysql://paymentorder-db-service:3306/payments
SET MIN_POOL_SIZE=5
SET MAX_POOL_SIZE=1
SET DB_HOST=paymentorder-db-service-np



SET DB_INIT_CONNECTION_URL="jdbc:mysql://paymentorder-db-service.payments.svc.cluster.local:3306/payments"

REM -------- KAFKA
SET kafkabootstrapservers="my-cluster-kafka-bootstrap.kafka:9092"
SET schema_registry_url="http://schema-registry-svc.kafka.svc.cluster.local" 
SET schedulertime="59 * * ? * *"
REM ------- IMAGE PROPERTIES
cd ../
set /p releaseVersion=<version.txt
echo ReleaseVersion=%releaseVersion%
SET tag=%releaseVersion%
cd upgrade

SET apiImage=temenos/ms-paymentorder-service
SET ingesterImage=temenos/ms-paymentorder-ingester
SET inboxoutboxImage=temenos/ms-paymentorder-inboxoutbox
SET schemaregistryImage=confluentinc/cp-schema-registry
SET schedulerImage=temenos/ms-paymentorder-scheduler
SET fileingesterImage=temenos/ms-paymentorder-fileingester
SET mysqlImage=ms-paymentorder-mysql
SET ENV_NAME=""

SET soImagePullSecret=""
SET dbinitImagePullSecret=""


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

REM -- Minutes required to delete ms_inbox_events in table

SET inboxcleanup="60"
SET schedule="5"

REM ---- Rolling Update Env Variables
SET rollingUpdate="false"
SET apiMaxSurge="1"
SET apiMaxUnavailable="0"
SET ingesterMaxSurge="1"
SET ingesterMaxUnavailable="0"


cd ../helm-chart

helm upgrade payments ./svc -n payments --set env.database.MYSQL_CRED=%MYSQL_CRED% --set env.database.host=%DB_HOST% --set env.database.db_username=%DB_USERNAME% --set env.database.db_password=%DB_PASSWORD% --set env.database.database_key=%DATABASE_KEY% --set env.database.database_name=%DB_NAME% --set env.database.driver_name=%DB_DRIVER% --set env.database.dialect=%DB_DIALECT% --set env.database.db_connection_url=%DB_CONNECTION_URL% --set env.database.max_pool_size=%MAX_POOL_SIZE% --set env.database.min_pool_size=%MIN_POOL_SIZE% --set env.kafka.kafkabootstrapservers=%kafkabootstrapservers% --set env.kafka.schema_registry_url=%schema_registry_url% --set image.tag=%tag% --set image.paymentsapi.repository=%apiImage% --set image.paymentsingester.repository=%ingesterImage% --set image.paymentseventdelivery.repository=%inboxoutboxImage% --set image.schemaregistry.repository=%schemaregistryImage% --set image.paymentorderscheduler.repository=%schedulerImage% --set image.fileingester.repository=%fileingesterImage% --set image.mysql.repository=%mysqlImage% --set imagePullSecrets=%soImagePullSecret% --set env.kafka.kafkaAliases=%kafkaAliases% --set env.kafka.kafkaip=%kafkaip% --set env.kafka.kafka0ip=%kafka0ip% --set env.kafka.kafka1ip=%kafka1ip% --set env.kafka.kafka2ip=%kafka2ip% --set env.kafka.kafkaHostName=%kafkaHostName% --set env.kafka.kafka0HostName=%kafka0HostName% --set env.kafka.kafka1HostName=%kafka1HostName% --set env.kafka.kafka2HostName=%kafka2HostName% --set env.scheduler.time=%schedulertime% --set env.scheduler.temn_msf_scheduler_inboxcleanup_schedule=%inboxcleanup% --set env.scheduler.schedule=%schedule% --set env.name=%ENV_NAME% --set configmap.location=%configLocation% --set rollingupdate.enabled=%rollingUpdate% --set rollingupdate.api.maxsurge=%apiMaxSurge% --set rollingupdate.api.maxunavailable=%apiMaxUnavailable% --set rollingupdate.ingester.maxsurge=%ingesterMaxSurge% --set rollingupdate.ingester.maxunavailable=%ingesterMaxUnavailable%

cd ../upgrade
