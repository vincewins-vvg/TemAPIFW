@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images

SET DB_NAME=ms_paymentorder 
SET JWT_TOKEN_ISSUER=https://localhost:9443/oauth2/token
SET JWT_TOKEN_PRINCIPAL_CLAIM=sub
SET ID_TOKEN_SIGNED=true
SET JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=""
SET HOSTNAME=127.0.0.1

cd ../..

call build.bat build

cd k8/on-premise/db

call start-podb-scripts.bat

REM call start-opm.bat

REM call start-mongo-operator.bat

cd ../

kubectl create namespace paymentorder

helm install ponosql ./svc --set env.database.MONGODB_DBNAME=%DB_NAME% --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb --set env.database.DATABASE_KEY=mongodb --set pit.JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% --set pit.ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED% --set pit.JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY% --set env.kafka.kafkabootstrapservers=%HOSTNAME%:29092 --set env.kafka.schema_registry_url=http://%HOSTNAME%:8081 --set env.kafka.generic_ip=%HOSTNAME%

cd samples/external

kubectl apply -f paymentorder-api-nodeport.yaml -n paymentorder 

cd ../..