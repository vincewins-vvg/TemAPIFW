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

REM UNCOMMENT THE BELOW LINES TO ENABLE KEYCLOAK

REM SET JWT_TOKEN_ISSUER=http://localhost:8180/auth/realms/msf
REM SET JWT_TOKEN_PRINCIPAL_CLAIM=msuser
REM SET ID_TOKEN_SIGNED=false
REM SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED="MIIClTCCAX0CBgF6etFgtDANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANNc2YwHhcNMjEwNzA2MDc1NDQwWhcNMzEwNzA2MDc1NjIwWjAOMQwwCgYDVQQDDANNc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZKa8cuSEo8cf6pYC549K2Pcpu20b173iNhgdkhV/1XLW0YktMgnxySKrcCmDbqQJDhK5FWuXN1El8UkxABibqFt8riwesglCYUspNmAszkicZAEQ/X+pu89tAXQOdg8U5kU4ZK4hzOS5D0n8ZzW2TaWCsQDoH3ng0UWGPWA7LTv+zb8f2U+SK6rkP3tkfEZVEhqUrddOeiKGFa6we4mwLPT5ZczBoVRrfpwKBL6i1JDDrWpeCZRrUjm7SFem3lLQMyF6sRQVIPLONWl7AG4ZRv7Akicag7tUeMzbIO7jRAJasrK/40e54YJ4lnVRMUXq7powEFZFigcSLSMUKrZWxAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAe9jK84bas1c+W0Ee4JfHaRPxa1x/Y+lmuWXc1kzFBRptzmQsOJXon6v1VHGTbnvpPnO8wNaxfU0iqPm4RO+LoZyxbGQpyFXYFD+fPZdK2a78oVpfi71g1aS4qjjBIPK1ERZSWalCGdaNxkjG5+wXquAo18tFbacDX41shN6CxHux8bvT9NbWlsjKj6gFhpCbN7oKsafLgTQ2+mqcQO1bQxObHj3o/LiuvIWhIyakz9SmFvh0wgAXhkVoiPvoP5LXMNdbaSv49LIt7wOMZHkbtkFWMTqKRBq32NSSKi0670Tv4IDm2I1cKVWLVy0RXSOc6CXR99G2z2PC6aPQjsXvc="
REM SET JWT_TOKEN_PUBLIC_KEY=""

REM Database properties
SET DATABASE_KEY=sql
SET DB_HOST=paymentorder-db-service
SET DATABASE_NAME=payments
SET DB_USERNAME=sa
SET DB_PASSWORD=Rootroot@12345
SET DRIVER_NAME=com.microsoft.sqlserver.jdbc.SQLServerDriver
SET DIALECT=org.hibernate.dialect.SQLServer2012Dialect
SET DB_CONNECTION_URL=jdbc:sqlserver://paymentorder-db-service:1433;databaseName=payments
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

kubectl create namespace dbinitpayments

kubectl create namespace payments

kubectl create namespace appinitpayments

cd helm-chart

helm install dbinit ./dbinit -n dbinitpayments --set env.sqlinit.databaseKey=%DATABASE_KEY% --set env.sqlinit.databaseName=%DATABASE_NAME% --set env.sqlinit.dbdialect=%DIALECT% --set env.sqlinit.dbusername=%DB_USERNAME% --set env.sqlinit.dbpassword=%DB_PASSWORD% --set env.sqlinit.dbconnectionurl=jdbc:sqlserver://paymentorder-db-service.payments.svc.cluster.local:1433

helm install appinit ./appinit -n appinitpayments --set env.sqlinit.databaseKey=%DATABASE_KEY% --set env.sqlinit.databaseName=%DATABASE_NAME% --set env.sqlinit.dbdialect=%DIALECT% --set env.sqlinit.dbusername=%DB_USERNAME% --set env.sqlinit.dbpassword=%DB_PASSWORD% --set env.sqlinit.dbconnectionurl=jdbc:sqlserver://paymentorder-db-service.payments.svc.cluster.local:1433 --set env.sqlinit.dbdriver=%DRIVER_NAME% --set env.sqlinit.dbautoupgrade="N"


helm install payments ./svc -n payments --set env.database.host=%DB_HOST% --set env.database.db_username=%DB_USERNAME% --set env.database.db_password=%DB_PASSWORD% --set env.database.database_key=%DATABASE_KEY%  --set env.database.database_name=%DATABASE_NAME% --set env.database.driver_name=%DRIVER_NAME% --set env.database.dialect=%DIALECT% --set env.database.db_connection_url=%DB_CONNECTION_URL% --set pit.JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% --set pit.ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED% --set pit.JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% --set env.database.max_pool_size=%MAX_POOL_SIZE% --set env.database.min_pool_size=%MIN_POOL_SIZE% --set env.kafka.kafkabootstrapservers=%kafkabootstrapservers% --set env.kafka.schema_registry_url=%schema_registry_url% --set env.kafka.kafkaAliases=%kafkaAliases% --set env.kafka.kafkaip=%kafkaip% --set env.kafka.kafka0ip=%kafka0ip% --set env.kafka.kafka1ip=%kafka1ip% --set env.kafka.kafka2ip=%kafka2ip% --set env.kafka.kafkaHostName=%kafkaHostName% --set env.kafka.kafka0HostName=%kafka0HostName% --set env.kafka.kafka1HostName=%kafka1HostName% --set env.kafka.kafka2HostName=%kafka2HostName% --set env.scheduler.time=%schedulertime% --set image.tag=%tag% --set image.paymentsapi.repository=%apiImage% --set image.paymentsingester.repository=%ingesterImage% --set image.paymentseventdelivery.repository=%inboxoutboxImage% --set image.schemaregistry.repository=%schemaregistryImage% --set image.paymentorderscheduler.repository=%schedulerImage% --set image.fileingester.repository=%fileingesterImage% --set image.mysql.repository=%mysqlImage% --set imagePullSecrets=%esImagePullSecret%  

cd ../

cd samples/streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd external

kubectl apply -f payments-nodeport.yaml -n payments 

cd ../..
