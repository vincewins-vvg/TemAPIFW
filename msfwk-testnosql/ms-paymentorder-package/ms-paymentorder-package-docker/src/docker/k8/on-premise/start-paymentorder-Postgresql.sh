#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#
#@echo off
#REM --------------------------------------------------------------
#REM - Script to start Paymentorder Service
#REM --------------------------------------------------------------

#REM - Build paymentorder images

export DB_NAME=ms_paymentorder
export MONGODB_CONNECTIONSTR=mongodb+srv://badri0307:badri0307@mongodb01.qjebf.azure.mongodb.net
export POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb
export JWT_TOKEN_ISSUER=https://localhost:9443/oauth2/token
export JWT_TOKEN_PRINCIPAL_CLAIM=sub
export ID_TOKEN_SIGNED=true
export JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
export JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=""

export tag="DEV"
export apiImage=dev.local/temenos/ms-paymentorder-service
export ingesterImage=dev.local/temenos/ms-paymentorder-ingester
export inboxoutboxImage=dev.local/temenos/ms-paymentorder-inboxoutbox
export schedulerImage=dev.local/temenos/ms-paymentorder-scheduler
export fileingesterImage=dev.local/temenos/ms-paymentorder-fileingester
export schemaregistryImage=confluentinc/cp-schema-registry

export dbinitImage=dev.local/temenos/ms-paymentorder-dbscripts

export poImagePullSecret=""
export dbinitImagePullSecret=""

export temn_msf_db_pass_encryption_key=temenos
export temn_msf_db_pass_encryption_algorithm=PBEWithMD5AndTripleDES
export gcbasepath="http://localhost:7006/ms-genericconfig-api/api/v2.0.0/"

# -------- KAFKA
export kafkabootstrapservers="my-cluster-kafka-bootstrap.kafka:9092"

# --- To enable hostAliases, export the below variable to "Y"
export kafkaAliases="N"

# --- export the following variables for hostAliases
export kafkaip=""
export kafka0ip=""
export kafka1ip=""
export kafka2ip=""
export devdomain=""

export kafkaHostName=""
export kafka0HostName=""
export kafka1HostName=""
export kafka2HostName=""
export devdomainHostName=""

cd ../..

./build-Postgresql.sh create --build

cd k8/on-premise/db

./start-postgresqldb-scripts.sh

cd ../

kubectl create namespace paymentorder

helm install ponosql ./svc --set env.database.MONGODB_CONNECTIONSTR=$MONGODB_CONNECTIONSTR --set env.database.MONGODB_DBNAME=$DB_NAME --set env.database.POSTGRESQL_CONNECTIONURL=$POSTGRESQL_CONNECTIONURL --set env.database.DATABASE_KEY=postgresql --set pit.JWT_TOKEN_ISSUER=$JWT_TOKEN_ISSUER --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$JWT_TOKEN_PRINCIPAL_CLAIM --set pit.ID_TOKEN_SIGNED=$ID_TOKEN_SIGNED --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED --set pit.JWT_TOKEN_PUBLIC_KEY=$JWT_TOKEN_PUBLIC_KEY --set env.database.temn_msf_db_pass_encryption_key=$temn_msf_db_pass_encryption_key --set env.database.temn_msf_db_pass_encryption_algorithm=$temn_msf_db_pass_encryption_algorithm --set env.genericconfig.basepath=$gcbasepath --set image.paymentorderapi.repository=$apiImage --set image.paymentorderingester.repository=$ingesterImage --set image.paymentorderscheduler.repository=$schedulerImage --set image.paymentorderinboxoutbox.repository=$inboxoutboxImage --set image.fileingester.repository=$fileingesterImage --set image.schemaregistry.repository = $schemaregistry --set imagePullSecrets=$poImagePullSecret --set image.tag=$tag --set env.kafka.kafkabootstrapservers=$kafkabootstrapservers --set env.kafka.kafkaAliases=$kafkaAliases --set env.kafka.kafkaip=$kafkaip --set env.kafka.kafka0ip=$kafka0ip --set env.kafka.kafka1ip=$kafka1ip --set env.kafka.kafka2ip=$kafka2ip --set env.kafka.kafkaHostName=$kafkaHostName --set env.kafka.kafka0HostName=$kafka0HostName --set env.kafka.kafka1HostName=$kafka1HostName --set env.kafka.kafka2HostName=$kafka2HostName --set env.kafka.devdomainHostName=$devdomainHostName

cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f paymentorder-api-nodeport.yaml -n paymentorder

cd ../..
