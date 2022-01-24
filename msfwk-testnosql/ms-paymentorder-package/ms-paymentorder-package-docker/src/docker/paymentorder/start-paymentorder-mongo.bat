@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start paymentorder Service
REM --------------------------------------------------------------

SET JWT_TOKEN_ISSUER=https://localhost:9443/oauth2/token
SET JWT_TOKEN_PRINCIPAL_CLAIM=sub
SET ID_TOKEN_SIGNED=true
SET JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=""

REM UNCOMMENT THE BELOW LINES TO ENABLE KEYCLOAK
REM SET JWT_TOKEN_ISSUER=http://localhost:8180/auth/realms/msf
REM SET JWT_TOKEN_PRINCIPAL_CLAIM=msuser
REM SET ID_TOKEN_SIGNED=false
REM SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED="MIIClTCCAX0CBgF6etFgtDANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANNc2YwHhcNMjEwNzA2MDc1NDQwWhcNMzEwNzA2MDc1NjIwWjAOMQwwCgYDVQQDDANNc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZKa8cuSEo8cf6pYC549K2Pcpu20b173iNhgdkhV/1XLW0YktMgnxySKrcCmDbqQJDhK5FWuXN1El8UkxABibqFt8riwesglCYUspNmAszkicZAEQ/X+pu89tAXQOdg8U5kU4ZK4hzOS5D0n8ZzW2TaWCsQDoH3ng0UWGPWA7LTv+zb8f2U+SK6rkP3tkfEZVEhqUrddOeiKGFa6we4mwLPT5ZczBoVRrfpwKBL6i1JDDrWpeCZRrUjm7SFem3lLQMyF6sRQVIPLONWl7AG4ZRv7Akicag7tUeMzbIO7jRAJasrK/40e54YJ4lnVRMUXq7powEFZFigcSLSMUKrZWxAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAe9jK84bas1c+W0Ee4JfHaRPxa1x/Y+lmuWXc1kzFBRptzmQsOJXon6v1VHGTbnvpPnO8wNaxfU0iqPm4RO+LoZyxbGQpyFXYFD+fPZdK2a78oVpfi71g1aS4qjjBIPK1ERZSWalCGdaNxkjG5+wXquAo18tFbacDX41shN6CxHux8bvT9NbWlsjKj6gFhpCbN7oKsafLgTQ2+mqcQO1bQxObHj3o/LiuvIWhIyakz9SmFvh0wgAXhkVoiPvoP5LXMNdbaSv49LIt7wOMZHkbtkFWMTqKRBq32NSSKi0670Tv4IDm2I1cKVWLVy0RXSOc6CXR99G2z2PC6aPQjsXvc="
REM SET JWT_TOKEN_PUBLIC_KEY=""

REM DB PROPERTIES
SET DATABASE_KEY=mongodb
SET DATABASE_NAME=ms_paymentorder 
SET MONGODB_CONNECTIONSTR="mongodb+srv://badri0307:badri0307@mongodb01.qjebf.azure.mongodb.net"
SET DB_USERNAME=root
SET DB_PASSWORD=root

REM IMAGE PROPERTIES
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

cd helm-chart

kubectl create namespace mongopaymentorder

helm install appinit ./appinit -n mongopaymentorder --set env.appinit.databaseKey=%DATABASE_KEY% --set env.appinit.databaseName=%DATABASE_NAME% --set env.appinit.dbUserName=%DB_USERNAME% --set env.appinit.dbPassword=%DB_PASSWORD% --set env.appinit.dbautoupgrade="N"

helm install dbinit ./dbinit -n mongopaymentorder --set image.mongoinit.repository=%dbinitImage% --set env.mongoinit.migration=../migration --set imagePullSecrets=%dbinitImagePullSecret% --set image.tag=%tag% --set env.mongoinit.dbConnectionUrl=%MONGODB_CONNECTIONSTR%

timeout /t 90 >nul

kubectl create namespace paymentorder

helm install paymentorder ./svc -n paymentorder --set env.database.DATABASE_KEY=%DATABASE_KEY% --set env.database.MONGODB_DBNAME=%DATABASE_NAME% --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://ent-postgresqldb-service.postgresql.svc.cluster.local:5432/ms_paymentorder --set pit.JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% --set pit.ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED% --set pit.JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% --set env.database.temn_msf_db_pass_encryption_key=%temn_msf_db_pass_encryption_key% --set env.database.temn_msf_db_pass_encryption_algorithm=%temn_msf_db_pass_encryption_algorithm% --set env.genericconfig.basepath=%gcbasepath% --set image.paymentorderapi.repository=%apiImage% --set image.paymentorderingester.repository=%ingesterImage% --set image.paymentorderscheduler.repository=%schedulerImage% --set image.paymentorderinboxoutbox.repository=%inboxoutboxImage% --set image.fileingester.repository=%fileingesterImage% --set image.schemaregistry.repository = %schemaregistry% --set imagePullSecrets=%poImagePullSecret% --set image.tag=%tag --set env.kafka.kafkabootstrapservers=%kafkabootstrapservers% --set env.kafka.kafkaAliases=%kafkaAliases% --set env.kafka.kafkaip=%kafkaip% --set env.kafka.kafka0ip=%kafka0ip% --set env.kafka.kafka1ip=%kafka1ip% --set env.kafka.kafka2ip=%kafka2ip% --set env.kafka.kafkaHostName=%kafkaHostName% --set env.kafka.kafka0HostName=%kafka0HostName% --set env.kafka.kafka1HostName=%kafka1HostName% --set env.kafka.kafka2HostName=%kafka2HostName% --set env.kafka.devdomainHostName=%devdomainHostName%


cd ../