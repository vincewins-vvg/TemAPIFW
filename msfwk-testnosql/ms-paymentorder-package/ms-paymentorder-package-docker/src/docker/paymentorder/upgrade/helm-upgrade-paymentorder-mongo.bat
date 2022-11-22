@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to upgrade Paymentorder Service
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

REM Name 			: db_Connection_Url
REM Description		: We are using mongodb by default 

REM The general form of the connection URL for shared cluster is
    REM mongodb://<hostname>:<port>,<hostname>:<port>
    REM mongodb://mongos0.example.com:27017,mongos1.example.com:27017,mongos2.example.com:27017


REM mongodb:// -- A required prefix to identify that this is a string in the standard connection format.
    
REM host[:port] -- The host (and optional port number) where mongos instance for a sharded cluster is running. You can specify a hostname, IP address, or UNIX domain socket. Specify as many hosts as appropriate for your deployment topology.If the port number is not specified, the default port 27017 is used.

REM Default value   : mongodb://mongodb-0.mongodb-svc.mongodb.svc.cluster.local:27017

SET db_Connection_Url=mongodb\://mongodb-0.mongodb-svc.mongodb.svc.cluster.local:27017\,mongodb-1.mongodb-svc.mongodb.svc.cluster.local:27017\,mongodb-2.mongodb-svc.mongodb.svc.cluster.local:27017
REM Name			 : db_Username
REM Description      : To interact with a database, you generally first need to connect to the server. You supply a username (uid) for a server login.
REM Default Value    : servicerequestusr
SET db_Username=root
REM Name			 : db_password
REM Description      : To interact with a database, you generally first need to connect to the server. You supply a password that match a server login.
REM Default Value    : servicerequestpass
SET db_Password=root
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

REM -------------------------------------------------------------
REM 
REM IMAGE PROPERTIES
REM
REM --------------------------------------------------------------
cd ../
set /p releaseVersion=<version.txt
echo ReleaseVersion=%releaseVersion%
cd upgrade
REM Name			: tag
REM Description		: Specifies the release version of the image
SET tag=%releaseVersion%
REM Name			: apiImage,ingesterImage,inboxoutboxImage,dbinitImage
REM Description 	: Specifies the name of Images for api ,ingester,eventdelivery, dbinit that are  pushed to external repositories,
REM Example			: Consider our external repository is "acr.azurecr.io" and tag is the releaseVersion. It should be like acr.azurecr.io/temenos/ms-paymentorder-service:%releaseVersion%
SET apiImage=dev.local/temenos/ms-paymentorder-service
SET ingesterImage=dev.local/temenos/ms-paymentorder-ingester
SET inboxoutboxImage=dev.local/temenos/ms-paymentorder-inboxoutbox
SET schedulerImage=dev.local/temenos/ms-paymentorder-scheduler
SET fileingesterImage=dev.local/temenos/ms-paymentorder-fileingester
SET schemaregistryImage=confluentinc/cp-schema-registry


REM Name			: entitlement_Image_Pull_Secret,dbinit_Image_Pull_Secret
REM Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htm#:~:text=To%20create%20a%20Docker%20registry%20secret%3A. adapter_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
SET ImagePullSecret=""
SET dbinit_Image_Pull_Secret=""
REM Name			: env_Name
REM Description		: specifies the environment name which will be added as a respective pod prefix.
SET env_Name=""


REM Name			: ip_Config
REM Description 	: Specifies the ip of the host machine where configuration MS runs
REM Example			: "10.92.27.159"
SET ip_Config="10.92.27.159"

REM Name			: gc_Base_Path
REM Description 	: Specifies the base URL of configuration MS
REM Example			: "http://10.92.27.159:30023/ms-genericconfig-api/api/v2.0.0/"
SET gc_Base_Path="http://%ip_Config%:30023/ms-genericconfig-api/api/v2.0.0/"

REM Name 			: rolling_Update
REM Description     : Rolling updates allow Deployments' update to take place with zero downtime by incrementally updating Pods instances with new ones
REM Default Value   : false
REM Possible Value  : true | false
SET rolling_Update="false"
REM Name 			: api_MaxSurge
REM Description		: Specifies the maximum number of pods that can be created over the desired number of pods.
REM Default Value 	: 1
SET api_MaxSurge="1"
REM Name 			: api_MaxUnavailable
REM Description		: the maximum number of pods that can be unavailable during the update process. 
REM Default Value 	: 0
SET api_MaxUnavailable="0"

REM Name 			: ingester_MaxSurge
REM Description		: Specifies the maximum number of pods that can be created over the desired number of pods in ingester.
REM Default Value 	: 1
SET ingester_MaxSurge="1"
REM Name 			: ingester_MaxUnavailable
REM Description		: the maximum number of pods that can be unavailable during the update process in ingester. 
REM Default Value 	: 0
SET ingester_MaxUnavailable="0"

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
REM Name : ms_security_tokencheck_enabled
REM Description : Indicates if JWT token is enabled
SET ms_security_tokencheck_enabled="N"

cd ../helm-chart

helm upgrade paymentorder ./svc -n paymentorder --set env.database.MONGODB_DBNAME=%database_Name% --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://ms-paymentorder-postgresqldb-service.postgresql.svc.cluster.local:5432/ms_paymentorder --set env.database.DATABASE_KEY=%database_Key%  --set env.database.MONGODB_CONNECTIONSTR=%db_Connection_Url%  --set image.paymentorderapi.repository=%apiImage% --set image.paymentorderingester.repository=%ingesterImage% --set image.paymentorderscheduler.repository=%schedulerImage% --set image.paymentorderinboxoutbox.repository=%inboxoutboxImage% --set image.fileingester.repository=%fileingesterImage% --set image.schemaregistry.repository=%schemaregistryImage% --set imagePullSecrets=%ImagePullSecret% --set image.tag=%tag% --set env.genericconfig.basepath=%gc_Base_Path% --set env.kafka.kafkabootstrapservers=%kafka_Bootstrap_Servers%  --set env.name=%env_Name% --set configmap.location=%config_Location% --set rollingupdate.enabled=%rollingUpdate% --set rollingupdate.enabled=%rolling_Update% --set rollingupdate.api.maxsurge=%api_MaxSurge% --set rollingupdate.api.maxunavailable=%api_MaxUnavailable% --set rollingupdate.ingester.maxsurge=%ingester_MaxSurge% --set rollingupdate.ingester.maxunavailable=%ingester_MaxUnavailable% --set pit.JWT_TOKEN_ISSUER=%Jwt_Token_Issuer% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%Jwt_Token_Principal_Claim% --set pit.ID_TOKEN_SIGNED=%Id_Token_Signed% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%Jwt_Token_Public_Key_Cert_Encoded% --set pit.JWT_TOKEN_PUBLIC_KEY=%Jwt_Token_Public_Key% --set pit.ms_security_tokencheck_enabled=%ms_security_tokencheck_enabled%

cd upgrade