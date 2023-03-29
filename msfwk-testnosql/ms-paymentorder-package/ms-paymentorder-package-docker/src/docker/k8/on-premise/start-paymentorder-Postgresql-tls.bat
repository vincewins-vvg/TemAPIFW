@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM Name			: database_Name
REM Description		: Specify the name of the database used in mongodb.
REM Default value   : ms_paymentorder
SET database_Name=ms_paymentorder
REM Name 			: database_Key
REM Description 	: specify the name of the database server.
REM Possible values :  mongodb | postgresql
REM Default Value   : postgresql
SET database_Key=postgresql

REM Name 			: db_Connection_Url
REM Description		: We are using mongodb by default  With JDBC, a database is represented by a URL
REM jdbc:postgresql://host:port/database
 
REM host -- The host name of the server. Defaults to localhost. To specify an IPv6 address your must enclose the host parameter with square brackets, for example:
REM jdbc:postgresql://[::1]:5740/accounting

REM port -- The port number the server is listening on. Defaults to the PostgreSQL™ standard port number (5432).
REM database -- The database name.
REM Default value   : jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb

SET db_Connection_Url=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb

REM Name			 : db_Username
REM Description      : To interact with a database, you generally first need to connect to the server. You supply a username (uid) for a server login.
REM Default Value 	 : paymentorderusr
SET db_Username=paymentorderusr
REM Name			 : db_password
REM Description      : To interact with a database, you generally first need to connect to the server. You supply a password that match a server login.
REM Default Value 	 : paymentorderpass
SET db_Password=paymentorderpass


REM Name			: db_Enable_Secret
REM Description		: A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key.If db_Enable_Secret is set to 'Y'. It will allow to fetch the DB username and DB password through k8s secrets for MySQL DB.
REM Possible values : Y | N	  
REM Default value   : N
SET db_Enable_Secret="N"
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
REM Name			: apiImage,ingesterImage,schedulerImage,fileingesterImage,schemaregistryImage,appinitimage
REM Description 	: Specifies the name of Images for api ,ingester,scheduler,fileingesterImage,schemaregistryImage,appinitimage that are  pushed to external repositories,
REM Example			: Consider our external repository is "acr.azurecr.io" and tag is "DEV". It should be like acr.azurecr.io/temenos/ms-paymentorder-service:DEV
SET apiImage=dev.local/temenos/ms-paymentorder-service
SET ingesterImage=dev.local/temenos/ms-paymentorder-ingester
SET schedulerImage=dev.local/temenos/ms-paymentorder-scheduler
SET fileingesterImage=dev.local/temenos/ms-paymentorder-fileingester
SET schemaregistryImage=confluentinc/cp-schema-registry
SET APP_INIT_IMAGE="dev.local/temenos/ms-paymentorder-appinit"

REM Name			: po_Image_Pull_Secret,dbinit_Image_Pull_Secret
REM Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htm#:~:text=To%20create%20a%20Docker%20registry%20secret%3A. adapter_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
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
SET eventDirectDelivery=true

REM -- To enable the start version for DB upgradation
SET DB_UPGRADE_START_VERSION=""


REM Name		  : db_tlsEnabled
REM Description	  : Indicates 1-way TLS is enabled by default for database
SET db_tlsEnabled=true

REM Name		  : root_ca_cert_location
REM Description	  : Indicates the location of Certificate Authority File so that client verifies that it receives data from authorized server
SET root_ca_cert_location=database/postgresql/certs/ca.crt

REM Name		  : postgresql_twoWayTLSEnabled
REM Description	  : Indicates 2-way TLS has to be enforced for database
SET postgresql_twoWayTLSEnabled=false

REM Name		  : client_cert_location
REM Description	  : Indicates the location of Client Certificate File
SET client_cert_location=database/postgresql/certs/client.crt

REM Name		  : client_key_location
REM Description	  : Indicates the location of Client Key File
SET client_key_location=database/postgresql/keys/client.pk8

REM Name		  : root_ca_cert
REM Description	  : Indicates the name of Certificate Authority File
SET "root_ca_cert=%root_ca_cert_location:/=" & set "root_ca_cert=%"

REM Name		  : client_cert
REM Description	  : Indicates the name of Client Certificate File
SET "client_cert=%client_cert_location:/=" & set "client_cert=%"

REM Name		  : client_key
REM Description	  : Indicates the name of Client Key File
SET "client_key=%client_key_location:/=" & set "client_key=%"

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

if "%postgresql_twoWayTLSEnabled%"=="true" (		
	call start-postgresqldb-scripts-k8.bat ssl mutual
) else (
	call start-postgresqldb-scripts-k8.bat ssl
)
if "%postgresql_twoWayTLSEnabled%"=="true" (		
	kubectl create namespace paymentorder	
	kubectl create secret generic postgresql-ssl-secret --from-file=%root_ca_cert_location% --from-file=%client_cert_location% --from-file=%client_key_location% -n paymentorder	
) else (
	kubectl create namespace paymentorder
	kubectl create secret generic postgresql-ssl-secret --from-file=%root_ca_cert_location%  -n paymentorder
)


cd ../


REM kubectl create ns poappinit

REM helm install poappinit ./appinit -n poappinit --set env.appinit.databaseKey=%database_Key% --set env.appinit.databaseName=%database_Name% --set env.appinit.dbUserName=%db_Username% --set env.appinit.dbPassword=%db_Password% --set env.appinit.dbautoupgrade="N" --set image.tag=%tag% --set env.appinit.dbConnectionUrl=%db_Connection_Url% --set image.appinit.repository=%APP_INIT_IMAGE%

REM kubectl create namespace paymentorder



helm install ponosql ./svc -n paymentorder --create-namespace -n paymentorder --set env.database.POSTGRESQL_CONNECTIONURL=%db_Connection_Url% --set env.database.MONGODB_DBNAME=%database_Name% --set env.database.DATABASE_KEY=%database_Key% --set pit.JWT_TOKEN_ISSUER=%Jwt_Token_Issuer% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%Jwt_Token_Principal_Claim% --set pit.ID_TOKEN_SIGNED=%Id_Token_Signed% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%Jwt_Token_Public_Key_Cert_Encoded% --set pit.JWT_TOKEN_PUBLIC_KEY=%Jwt_Token_Public_Key% --set env.database.temn_msf_db_pass_encryption_key=%encryption_Key% --set env.database.temn_msf_db_pass_encryption_algorithm=%encryption_Algorithm% --set env.genericconfig.basepath=%gc_Base_Path% --set image.paymentorderapi.repository=%apiImage% --set image.paymentorderingester.repository=%ingesterImage% --set image.paymentorderscheduler.repository=%schedulerImage% --set image.fileingester.repository=%fileingesterImage% --set image.schemaregistry.repository=%schemaregistryImage% --set imagePullSecrets=%po_Image_Pull_Secret% --set image.tag=%tag% --set env.kafka.kafkabootstrapservers=%kafka_Bootstrap_Servers% --set env.kafka.kafkaAliases=%kafka_Aliases% --set env.kafka.kafkaip=%kafkaip% --set env.kafka.kafka0ip=%kafka0ip% --set env.kafka.kafka1ip=%kafka1ip% --set env.kafka.kafka2ip=%kafka2ip% --set env.kafka.kafkaHostName=%kafka_Host_Name% --set env.kafka.kafka0HostName=%kafka0_Host_Name% --set env.kafka.kafka1HostName=%kafka1_Host_Name% --set env.kafka.kafka2HostName=%kafka2_Host_Name% --set env.kafka.devdomainHostName=%devdomain_Host_Name% --set env.database.POSTGRESQL_USERNAME=%db_Username% --set env.database.POSTGRESQL_PASSWORD=%db_Password% --set env.database.POSTGRESQL_CRED=%db_Enable_Secret%  --set env.eventdelivery.outboxdirectdeliveryenabled=%eventDirectDelivery% --set env.scheduler.temn_msf_scheduler_inboxcleanup_schedule=%inbox_Cleanup% --set env.scheduler.schedule=%schedule% --set image.appinit.repository=%APP_INIT_IMAGE% --set env.appinit.dbUpgradeStartVersion=%DB_UPGRADE_START_VERSION% --set env.database.tlsEnabled=%db_tlsEnabled% --set env.database.POSTGRESQL_SERVER_CA_CERT=%root_ca_cert% --set env.database.POSTGRESQL_CLIENT_CERT=%client_cert% --set env.database.POSTGRESQL_CLIENT_KEY=%client_key%


cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f paymentorder-api-nodeport.yaml -n paymentorder

cd ../..