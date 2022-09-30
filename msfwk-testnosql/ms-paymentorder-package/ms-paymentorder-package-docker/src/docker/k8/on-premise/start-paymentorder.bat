@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM Name 			: database_Key
REM Description 	: specify the name of the database server.
REM Possible values :  mongodb | postgresql
REM Default Value   : mongodb
SET database_Key=mongodb
REM Name			: database_Name
REM Description		: Specify the name of the database used in mongodb.
REM Default value   : ms_paymentorder
SET database_Name=ms_paymentorder 

REM Name			: db_Connection_Url
REM Description		: The general form of the connection URL is
REM  ex.  oracle:          jdbc:oracle:thin:@<host_or_ip>:1521:<db_name>
REM  ex.  db2:             jdbc:db2://<host_or_ip>:50000/<db_name>
REM  ex.  ms-sql:          jdbc:sqlserver://<host_or_ip>:1433;databaseName=<db_name>
REM  ex.  mongodb:         mongodb://[username:password@]host1[:port1][,...hostN[:portN]][/[defaultauthdb][?options]]


REM Name 			: db_Connection_Url
REM Description		: We are using mongodb by default 

REM The general form of the connection URL for shared cluster is
    REM mongodb://<hostname>:<port>,<hostname>:<port>
    REM mongodb://mongos0.example.com:27017,mongos1.example.com:27017,mongos2.example.com:27017


REM mongodb:// -- A required prefix to identify that this is a string in the standard connection format.
    
REM host[:port] -- The host (and optional port number) where mongos instance for a sharded cluster is running. You can specify a hostname, IP address, or UNIX domain socket. Specify as many hosts as appropriate for your deployment topology.If the port number is not specified, the default port 27017 is used.
SET db_Connection_Url="mongodb://mongodb-0.mongodb-svc.mongodb.svc.cluster.local:27017"


REM Name : Jwt_Token_Issuer
REM Description : Identifies the issuer of the authentication token.
REM Default Value : https://localhost:9443/oauth2/token
SET Jwt_Token_Issuer=https://localhost:9443/oauth2/token
REM Name : Jwt_Token_Principal_Claim
REM Description : Indicates the claim in which the user principal is provided.
REM Default Value : sub
SET Jwt_Token_Principal_Claim=sub
REM Name : Id_Token_Signed
REM Description : Enables the JWT signature validation along with the header and payload
REM Default Value : true
SET Id_Token_Signed=true
REM Name : Jwt_Token_Public_Key
REM Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
SET Jwt_Token_Public_Key="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
REM Name : Jwt_Token_Public_Key_Cert_Encoded
REM Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate
SET Jwt_Token_Public_Key_Cert_Encoded=""
REM -------------------------------------------------------------
REM 
REM IMAGE PROPERTIES
REM
REM --------------------------------------------------------------
REM Name			: tag
REM Description		: Specifies the release version of the image
SET tag="DEV"
REM Name			: apiImage,ingesterImage,inboxoutboxImage,schedulerImage,fileingesterImage,schemaregistryImage,dbinitImage
REM Description 	: Specifies the name of Images for api ,ingester,scheduler,fileingesterImage,schemaregistryImage,dbinitImage that are  pushed to external repositories,
REM Example			: Consider our external repository is "acr.azurecr.io" and tag is "DEV". It should be like acr.azurecr.io/temenos/ms-paymentorder-service:DEV
SET apiImage=dev.local/temenos/ms-paymentorder-service
SET ingesterImage=dev.local/temenos/ms-paymentorder-ingester
SET inboxoutboxImage=dev.local/temenos/ms-paymentorder-inboxoutbox
SET schedulerImage=dev.local/temenos/ms-paymentorder-scheduler
SET fileingesterImage=dev.local/temenos/ms-paymentorder-fileingester
SET schemaregistryImage=confluentinc/cp-schema-registry

SET dbinitImage=dev.local/temenos/ms-paymentorder-dbscripts
REM Name			: po_Image_Pull_Secret,dbinit_Image_Pull_Secret
REM Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htmREM:~:text=To%20create%20a%20Docker%20registry%20secret%3A. adapter_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
SET po_Image_Pull_Secret=""
SET dbinit_Image_Pull_Secret=""
REM Name			: encryption_Key,encryption_Algorithm
REM Description 	: For encrypting the plain text's, need some inputs i.e., Password and an Algorithm which is used to encrypt/decrypt an given input. These two values are mandatory to encrypt the plain text.
REM Default value 	: temenos for key and PBEWithMD5AndTripleDES for algorithm.
SET encryption_Key=temenos
SET encryption_Algorithm=PBEWithMD5AndTripleDES

REM Name 			: gc_Base_Path
REM Description		: Specify the url to connect generic configuration microservice.
REM Default Value	: http://localhost:7006/ms-genericconfig-api/api/v2.0.0/
SET gc_Base_Path="http://localhost:7006/ms-genericconfig-api/api/v2.0.0/"
REM -------------------------------------------------------------
REM 
REM Kafka properties
REM
REM --------------------------------------------------------------
REM Name 			: kafka_Bootstrap_Servers
REM Description		: It contains a list of host/port pairs for establishing the initial connection to the Kafka cluster.A host and port pair uses : as the separator.
REM Example			: localhost:9092,localhost:9092,another.host:9092
REM Default Value	: my-cluster-kafka-bootstrap.kafka:9092
SET kafka_Bootstrap_Servers="my-cluster-kafka-bootstrap.kafka:9092"



REM Name 			: kafka_Aliases
REM Description		: hostAliases is used to overwrite the resolution of the host name and ip at the pod level when adding entries to the /etc/hosts file of the pod.(https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/). To enable hostAliases, set the below variable to "Y"
REM Possible values : Y | N	 
REM Default Value	: N
SET kafka_Aliases="N"

REM Name			: kafkaip,kafka0ip,kafka1ip,kafka2ip,devdomain
REM Description		: Set the following variables of kafka ip for hostAliases
SET kafkaip=""
SET kafka0ip=""
SET kafka1ip=""
SET kafka2ip=""
SET devdomain=""

REM Name			: kafka_Host_Name,kafka0_Host_Name,kafka1_Host_Name,kafka2_Host_Name,devdomain_Host_Name
REM Description		: Set the following variables of kafka hostname for hostAliases
SET kafka_Host_Name=""
SET kafka0_Host_Name=""
SET kafka1_Host_Name=""
SET kafka2_Host_Name=""
SET devdomain_Host_Name=""

REM scheduler Property
REM Name            : inbox_Cleanup
REM Descripton        : Specifies No of Minutes required to hold the records inside ms_inbox_events table before automatic deletion.
REM Default Value    : 60
SET inbox_Cleanup="60"
REM Name             : schedule
REM Description        : Specify the Frequency to trigger the scheduler job is set in this property.
REM Default Value    : 5
SET schedule="5"

REM Name             : eventDirectDelivery
REM Description      : If the value is true. Framework will directly deliver the events to respective topics. It skip the <msf>-outbox topic. If the value is false. It will delivers the events to <msf>-outbox topic and event delivery service will delivers the events to respective topic.
SET eventDirectDelivery=\"true\"	


cd ../..

call build.bat build

cd k8/on-premise/db

IF EXIST "start-paymentorder-k8.bat" DEL start-paymentorder-k8.bat
setLocal EnableDelayedExpansion
For /f "tokens=* delims= " %%a in (start-podb-scripts.bat) do (
Set str=%%a
set str=!str:docker-compose=REM!
echo !str!>>start-paymentorder-k8.bat
)
ENDLOCAL

call start-paymentorder-k8.bat

REM call start-opm.bat

REM call start-mongo-operator.bat

cd ../

kubectl create ns poappinit

SET APP_INIT_IMAGE="dev.local/temenos/ms-paymentorder-appinit"

helm install poappinit ./appinit -n poappinit --set env.appinit.databaseKey=%database_Key% --set env.appinit.databaseName=%database_Name% --set env.appinit.dbautoupgrade="N" --set image.tag=%tag% --set image.appinit.repository=%APP_INIT_IMAGE%


kubectl create namespace paymentorder

helm install ponosql ./svc --set env.database.MONGODB_DBNAME=%database_Name% --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb --set env.database.DATABASE_KEY=%database_Key% --set pit.JWT_TOKEN_ISSUER=%Jwt_Token_Issuer% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%Jwt_Token_Principal_Claim% --set pit.ID_TOKEN_SIGNED=%Id_Token_Signed% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%Jwt_Token_Public_Key_Cert_Encoded% --set pit.JWT_TOKEN_PUBLIC_KEY=%Jwt_Token_Public_Key% --set env.database.temn_msf_db_pass_encryption_key=%encryption_Key% --set env.database.temn_msf_db_pass_encryption_algorithm=%encryption_Algorithm% --set env.genericconfig.basepath=%gc_Base_Path% --set image.paymentorderapi.repository=%apiImage% --set image.paymentorderingester.repository=%ingesterImage% --set image.paymentorderscheduler.repository=%schedulerImage% --set image.paymentorderinboxoutbox.repository=%inboxoutboxImage% --set image.fileingester.repository=%fileingesterImage% --set image.schemaregistry.repository=%schemaregistryImage% --set imagePullSecrets=%po_Image_Pull_Secret% --set image.tag=%tag% --set env.kafka.kafkabootstrapservers=%kafka_Bootstrap_Servers% --set env.kafka.kafkaAliases=%kafka_Aliases% --set env.kafka.kafkaip=%kafkaip% --set env.kafka.kafka0ip=%kafka0ip% --set env.kafka.kafka1ip=%kafka1ip% --set env.kafka.kafka2ip=%kafka2ip% --set env.kafka.kafkaHostName=%kafka_Host_Name% --set env.kafka.kafka0HostName=%kafka0_Host_Name% --set env.kafka.kafka1HostName=%kafka1_Host_Name% --set env.kafka.kafka2HostName=%kafka2_Host_Name% --set env.kafka.devdomainHostName=%devdomain_Host_Name% --set env.eventdelivery.outboxdirectdeliveryenabled=%eventDirectDelivery%

cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f paymentorder-api-nodeport.yaml -n paymentorder

cd ../..
