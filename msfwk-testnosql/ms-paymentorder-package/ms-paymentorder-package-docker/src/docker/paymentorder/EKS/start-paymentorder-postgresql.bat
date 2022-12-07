@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start paymentorder Service
REM --------------------------------------------------------------
REM AWS Configure Information
SET accountId=600670497877
SET awsRegion=eu-west-2
SET accesskeyId=ASIAYXWWANRKVVUF73P4
SET accessKey=YniIdFoTz6Y/bB47h0IeeA4BkA/yyPilRe5nt11p
SET sessionToken=IQoJb3JpZ2luX2VjELX//////////wEaCWV1LXdlc3QtMSJHMEUCIQCvBj+GEnoDIsgTHCit21RZN+VA2j3Y8n+9tFLs5n9nYwIgPWBnb67AuHWQCy8GORW2IdSkmCKRNc91swWbBnXe5xAqmgMIzv//////////ARAAGgw2MDA2NzA0OTc4NzciDNvc0fY6Ebt+gUdrHyruAsDsmbYxoP9BKaJKBnbdpRv/N5vqs6ee8ySznL15ZtUu6GjsY3STp8eEhWMAnZzvY78DYwvGYRBCxELhKjVXkZ0gsSPgfSUCAWy0qYleS+qRD9WUpGe+o079HBThSXMJMmbEW1tEgbCaGHetIa03zjR9pFRMejxEZDtg//VQ7vS1rslaRf90SYJlHPBzeWjg3l99UisKAnazTtQw+jIKnBuaTniXKgIVXEvU7cF94VfS85z9tQmj1lK1halGR6E+d6YHx/BeaiFj2mUpphaT/ZWF2ylUBFE7AOO4aAuKk31JNWh/YHWyO3p7GBi9oPBEhGI2Gd2nfXSqymbrMvbdgS9AOxR0R7aNeGBMWCDYJeVqo3Fc8AQeMa1fiadiw36joaUEf8dgsccA5717sQ5kvfQZyh7cdw4nYKMN5sbl006o1nxUYsszO/o75pAbmI31VHKTI25SwmXstQ2YQp0nkwlcL1mDRlApoFRfzSC46zC4w7CcBjqmASH392EFE/ve95I2SYVPCPIwueSpmXGWdlzKsGbG59qcE7EIluFpwvZmTVsQwQ1ypTyKJKfoPpWgTfNyslbHARLTQwF55MQR2B5s7GWDbjzR3A6O0jL9jGo46yDgLV6iyvZNFjEjYS1NyFiFow+sYg2snxMmwml86TQSOYWAskNom2hWNPn1UPZzO/RITWssAdMSPfQJP7n82am50rVFW7UHjZaBK/4=
REM kinesis Region
SET kinesisRegion=eu-west-2
SET ecrregion=%awsRegion%
REM Cluster Information
SET clustername=ms-paymentorderscluster
SET clusterregion=eu-west-2
SET nodegroupname=ms-paymentordercluster-nodes

SET repositoryname=ms-paymentorderimagerepository
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


rem UNCOMMENT THE BELOW LINES TO ENABLE KEYCLOAK

REM SET JWT_TOKEN_ISSUER=http://localhost:8180/auth/realms/msf
REM SET JWT_TOKEN_PRINCIPAL_CLAIM=msuser
REM SET ID_TOKEN_SIGNED=false
REM SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED="MIIClTCCAX0CBgF6etFgtDANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANNc2YwHhcNMjEwNzA2MDc1NDQwWhcNMzEwNzA2MDc1NjIwWjAOMQwwCgYDVQQDDANNc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZKa8cuSEo8cf6pYC549K2Pcpu20b173iNhgdkhV/1XLW0YktMgnxySKrcCmDbqQJDhK5FWuXN1El8UkxABibqFt8riwesglCYUspNmAszkicZAEQ/X+pu89tAXQOdg8U5kU4ZK4hzOS5D0n8ZzW2TaWCsQDoH3ng0UWGPWA7LTv+zb8f2U+SK6rkP3tkfEZVEhqUrddOeiKGFa6we4mwLPT5ZczBoVRrfpwKBL6i1JDDrWpeCZRrUjm7SFem3lLQMyF6sRQVIPLONWl7AG4ZRv7Akicag7tUeMzbIO7jRAJasrK/40e54YJ4lnVRMUXq7powEFZFigcSLSMUKrZWxAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAe9jK84bas1c+W0Ee4JfHaRPxa1x/Y+lmuWXc1kzFBRptzmQsOJXon6v1VHGTbnvpPnO8wNaxfU0iqPm4RO+LoZyxbGQpyFXYFD+fPZdK2a78oVpfi71g1aS4qjjBIPK1ERZSWalCGdaNxkjG5+wXquAo18tFbacDX41shN6CxHux8bvT9NbWlsjKj6gFhpCbN7oKsafLgTQ2+mqcQO1bQxObHj3o/LiuvIWhIyakz9SmFvh0wgAXhkVoiPvoP5LXMNdbaSv49LIt7wOMZHkbtkFWMTqKRBq32NSSKi0670Tv4IDm2I1cKVWLVy0RXSOc6CXR99G2z2PC6aPQjsXvc="
REM SET JWT_TOKEN_PUBLIC_KEY=""

REM Name			: db_Enable_Secret
REM Description		: A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key.If db_Enable_Secret is set to 'Y'. It will allow to fetch the DB username and DB password through k8s secrets for MySQL DB.
REM Possible values : Y | N	  
REM Default value   : N
SET db_Enable_Secret="N"

REM Name 			: database_Key
REM Description 	: specify the name of the database server.
REM Possible values :  mongodb | postgresql
REM Default Value   : postgresql
SET database_Key=postgresql
REM Name			: database_Name
REM Description		: Specify the name of the database used in mongodb.
REM Default value   : ms_paymentorder
SET database_Name=ms_paymentorder 
REM Name 			: db_Connection_Url
REM Description		: We are using mongodb by default  With JDBC, a database is represented by a URL
REM jdbc:postgresql://host:port/database
 
REM host -- The host name of the server. Defaults to localhost. To specify an IPv6 address your must enclose the host parameter with square brackets, for example:
REM jdbc:postgresql://[::1]:5740/accounting

REM port -- The port number the server is listening on. Defaults to the PostgreSQL™ standard port number (5432).
REM database -- The database name.
REM Default value   : jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb

SET db_Connection_Url=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:80/paymentorderdb
REM Name			 : db_Username
REM Description      : To interact with a database, you generally first need to connect to the server. You supply a username (uid) for a server login.
REM Default Value 	 : paymentorderusr
SET db_Username=paymentorderusr
REM Name			 : db_Password
REM Description      : To interact with a database, you generally first need to connect to the server. You supply a password that match a server login.
REM Default Value 	 : paymentorderpass
SET db_Password=paymentorderpass

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
SET appinitImage="dev.local/temenos/ms-paymentorder-appinit"

SET apiImageTag=%accountId%.dkr.ecr.%ecrregion%.amazonaws.com/%repositoryname%:apiservice
SET ingesterImageTag=%accountId%.dkr.ecr.%ecrregion%.amazonaws.com/%repositoryname%:ingesterservice
SET schedulerImageTag=%accountId%.dkr.ecr.%ecrregion%.amazonaws.com/%repositoryname%:schedulerservice
SET inboxoutboxImageTag=%accountId%.dkr.ecr.%ecrregion%.amazonaws.com/%repositoryname%:inboxoutboxservice
SET fileingesterImageTag=%accountId%.dkr.ecr.%ecrregion%.amazonaws.com/%repositoryname%:fileingesterservice
SET appinitImageTag=%accountId%.dkr.ecr.%ecrregion%.amazonaws.com/%repositoryname%:appinitservice


REM -- Kinesis consumer default polling Aconfig for multi shard

REM Name            : requesttimeout 
REM Description     : The maximum time to wait for a future request from Kinesis to complete
REM Default Value   : 30 seconds, default value provided in kcl
SET requesttimeout=30

REM Name            : maxrecords 
REM Description     : Max records to fetch from Kinesis in a single GetRecords call
REM Default Value   : 10000, default value provided in kcl
SET maxrecords=10000

REM Name            : idleinterval 
REM Description     : The value for how long the ShardConsumer should sleep in between calls to getRecords.
REM Default Value   : 1000 milliseconds, default value provided in kcl
SET idleinterval=1000

SET schema_registry_url=http://kafka-oss-cp-schema-registry:8081

aws ecr create-repository --repository-name cp-schema-registry --region %ecrregion%
aws ecr create-repository --repository-name cp-kafka --region %ecrregion%
aws ecr create-repository --repository-name cp-zookeeper --region %ecrregion%

aws ecr get-login-password --region %ecrregion% | docker login --username AWS --password-stdin %accountId%.dkr.ecr.%ecrregion%.amazonaws.com

docker pull confluentinc/cp-schema-registry:5.2.2
docker pull confluentinc/cp-kafka:5.2.2
docker pull confluentinc/cp-zookeeper:5.2.2

docker tag confluentinc/cp-schema-registry:5.2.2 %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-schema-registry:5.2.2
docker tag confluentinc/cp-kafka:5.2.2 %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-kafka:5.2.2
docker tag confluentinc/cp-zookeeper:5.2.2 %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-zookeeper:5.2.2

docker push %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-schema-registry:5.2.2
docker push %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-kafka:5.2.2
docker push %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-zookeeper:5.2.2

eksctl create cluster --name %clustername% --region %clusterregion% --fargate 

aws eks --region %clusterregion% update-kubeconfig --name %clustername%

eksctl create nodegroup --cluster=%clustername% --name=%nodegroupname% --region %clusterregion%

aws ecr create-repository --repository-name %repositoryname%  --region %ecrregion%

aws ecr get-login-password --region %ecrregion% | docker login --username AWS --password-stdin %accountId%.dkr.ecr.%ecrregion%.amazonaws.com


docker tag %apiImage%:%tag% %apiImageTag%

docker push %apiImageTag%

docker tag %ingesterImage%:%tag% %ingesterImageTag%

docker push %ingesterImageTag%

docker tag %inboxoutboxImage%:%tag% %inboxoutboxImageTag%

docker push %inboxoutboxImageTag%

docker tag %schedulerImage%:%tag% %schedulerImageTag%

docker push %schedulerImageTag%

docker tag %fileingesterImage%:%tag% %fileingesterImageTag%

docker push %fileingesterImageTag%

docker tag %appInitImage%:%tag% %appInitImageTag%

docker push %appInitImageTag%

REM Uncomment the below lines to run the postgresql db
REM docker tag ms-paymentorder-postgres:latest %accountId%.dkr.ecr.eu-west-2.amazonaws.com/%repositoryname%:postgresql
REM docker push %accountId%.dkr.ecr.eu-west-2.amazonaws.com/%repositoryname%:postgresql

aws kinesis create-stream --stream-name ms-paymentorder-inbox-topic --shard-count 1 
timeout /t 10 >nul
aws kinesis create-stream --stream-name paymentorder-event-topic --shard-count 1 
timeout /t 10 >nul
aws kinesis create-stream --stream-name ms-paymentorder-inbox-error-topic --shard-count 1 
timeout /t 10 >nul
aws kinesis create-stream --stream-name ms-paymentorder-outbox-topic --shard-count 1 
timeout /t 10 >nul
aws kinesis create-stream --stream-name error-paymentorder --shard-count 1 
timeout /t 10 >nul 
aws kinesis create-stream --stream-name table-update-paymentorder --shard-count 1 
timeout /t 10 >nul
aws kinesis create-stream --stream-name table-update --shard-count 1 
timeout /t 10 >nul
aws kinesis create-stream --stream-name multipart-1 --shard-count 1 
timeout /t 10 >nul
aws kinesis create-stream --stream-name ms-eventstore-inbox-topic --shard-count 1 
timeout /t 10 >nul
aws kinesis create-stream --stream-name multipart-topic --shard-count 1 
timeout /t 10 >nul
aws kinesis create-stream --stream-name ms-paymentorder-ingester-consumer --shard-count 1 
timeout /t 10 >nul
aws kinesis create-stream --stream-name ms-paymentorder-ingester-error-producer --shard-count 1
timeout /t 10 >nul
aws kinesis create-stream --stream-name reprocess-event --shard-count 1
timeout /t 10 >nul
aws kinesis create-stream --stream-name Test-topic --shard-count 1

REM Uncomment the below lines to run the postgresql db
REM cd db/postgresql
REM kubectl apply -f namespace.yaml
REM kubectl apply -f postgresql-db.yaml
REM kubectl apply -f db-secrets.yaml
REM cd ../..

SET storage="s3://paymentorderstorage"
SET serviceAccountEnable="Y"
SET serviceAccountName=paymentorder-serviceaccount
SET serviceAccountPolicy=kinesis-policy

REM Name			: po_Image_Pull_Secret,dbinit_Image_Pull_Secret
REM Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htm#:~:text=To%20create%20a%20Docker%20registry%20secret%3A. adapter_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
SET po_Image_Pull_Secret=""
SET dbinit_Image_Pull_Secret=""
REM Name			: encryption_Key,encryption_Algorithm
REM Description 	: For encrypting the plain text's, need some inputs i.e., Password and an Algorithm which is used to encrypt/decrypt an given input. These two values are mandatory to encrypt the plain text.
REM Default value 	: temenos for key and PBEWithMD5AndTripleDES for algorithm.
SET encryption_Key=temenos
SET encryption_Algorithm=PBEWithMD5AndTripleDES

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

helm install kafka-oss cp-helm-charts --version 0.5.0 -n kafka --set cp-zookeeper.image=600670497877.dkr.ecr.eu-west-2.amazonaws.com/cp-zookeeper --set cp-zookeeper.imageTag=5.2.2 --set cp-kafka.image=600670497877.dkr.ecr.eu-west-2.amazonaws.com/cp-kafka --set cp-kafka.imageTag=5.2.2 --set cp-schema-registry.image=600670497877.dkr.ecr.eu-west-2.amazonaws.com/cp-schema-registry --set cp-schema-registry.imageTag=5.2.2 --create-namespace

kubectl create ns poappinit

helm install poappinit ./appinit -n poappinit --set env.appinit.databaseKey=%database_Key% --set env.appinit.databaseName=%database_Name% --set env.appinit.dbUserName=%db_Username% --set env.appinit.dbPassword=%db_Password% --set env.appinit.dbautoupgrade="N" --set image.tag=%tag% --set env.appinit.dbConnectionUrl=%db_Connection_Url% --set image.appinit.repository=%appInitImageTag%

timeout /t 90 >nul

kubectl create namespace paymentorder

if %serviceAccountEnable% == "Y" (
eksctl utils associate-iam-oidc-provider --cluster %clustername% --approve --region %clusterregion%

eksctl create iamserviceaccount --cluster %clustername% --name %serviceAccountName% --namespace paymentorder --attach-policy-arn arn:aws:iam::%accountId%:policy/%serviceAccountPolicy% --approve --region %clusterregion%
)

helm install paymentorder ./svc -n paymentorder --set env.database.DATABASE_KEY=%database_Key% --set env.database.MONGODB_DBNAME=%database_Name% --set env.database.POSTGRESQL_CONNECTIONURL=%db_Connection_Url% --set pit.JWT_TOKEN_ISSUER=%Jwt_Token_Issuer% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%Jwt_Token_Principal_Claim% --set pit.ID_TOKEN_SIGNED=%Id_Token_Signed% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%Jwt_Token_Public_Key_Cert_Encoded% --set pit.JWT_TOKEN_PUBLIC_KEY=%Jwt_Token_Public_Key% --set env.database.temn_msf_db_pass_encryption_key=%encryption_Key% --set env.database.temn_msf_db_pass_encryption_algorithm=%encryption_Algorithm% --set image.paymentorderapi.repository=%apiImageTag% --set image.paymentorderingester.repository=%ingesterImageTag% --set image.paymentorderscheduler.repository=%schedulerImageTag% --set image.paymentorderinboxoutbox.repository=%inboxoutboxImageTag% --set image.fileingester.repository=%fileingesterImageTag% --set imagePullSecrets=%po_Image_Pull_Secret% --set image.tag=%tag% --set env.kafka.kafkabootstrapservers=%kafka_Bootstrap_Servers% --set env.kafka.kafkaAliases=%kafka_Aliases% --set env.kafka.schema_registry_url=%schema_registry_url% --set env.database.POSTGRESQL_USERNAME=%db_Username% --set env.database.POSTGRESQL_PASSWORD=%db_Password% --set env.database.POSTGRESQL_CRED=%db_Enable_Secret% --set env.eventdelivery.outboxdirectdeliveryenabled=%eventDirectDelivery% --set env.scheduler.temn_msf_scheduler_inboxcleanup_schedule=%inbox_Cleanup% --set env.scheduler.schedule=%schedule% --set env.aws.region=%awsRegion% --set env.aws.accesskeyid=%accesskeyId% --set env.aws.accesskey=%accessKey% --set env.aws.sessionToken=%sessionToken% --set env.aws.kinesisregion=%kinesisRegion% --set env.storage.home=%storage% --set serviceaccount.enabled=%serviceAccountEnable% --set serviceaccount.name=%serviceAccountName% --set env.kinesis.requesttimeout=%requesttimeout% --set env.kinesis.maxrecords=%maxrecords% --set env.kinesis.idleinterval=%idleinterval%
