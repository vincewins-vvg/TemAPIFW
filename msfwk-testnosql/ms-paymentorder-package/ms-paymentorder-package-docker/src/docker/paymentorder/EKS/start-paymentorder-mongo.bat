@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start paymentorder Service
REM --------------------------------------------------------------
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
SET nodegroupname1=ms-paymentordercluster1-nodes
SET nodegroupname2=ms-paymentordercluster2-nodes

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

REM UNCOMMENT THE BELOW LINES TO ENABLE KEYCLOAK
REM SET JWT_TOKEN_ISSUER=http://localhost:8180/auth/realms/msf
REM SET JWT_TOKEN_PRINCIPAL_CLAIM=msuser
REM SET ID_TOKEN_SIGNED=false
REM SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED="MIIClTCCAX0CBgF6etFgtDANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANNc2YwHhcNMjEwNzA2MDc1NDQwWhcNMzEwNzA2MDc1NjIwWjAOMQwwCgYDVQQDDANNc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZKa8cuSEo8cf6pYC549K2Pcpu20b173iNhgdkhV/1XLW0YktMgnxySKrcCmDbqQJDhK5FWuXN1El8UkxABibqFt8riwesglCYUspNmAszkicZAEQ/X+pu89tAXQOdg8U5kU4ZK4hzOS5D0n8ZzW2TaWCsQDoH3ng0UWGPWA7LTv+zb8f2U+SK6rkP3tkfEZVEhqUrddOeiKGFa6we4mwLPT5ZczBoVRrfpwKBL6i1JDDrWpeCZRrUjm7SFem3lLQMyF6sRQVIPLONWl7AG4ZRv7Akicag7tUeMzbIO7jRAJasrK/40e54YJ4lnVRMUXq7powEFZFigcSLSMUKrZWxAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAe9jK84bas1c+W0Ee4JfHaRPxa1x/Y+lmuWXc1kzFBRptzmQsOJXon6v1VHGTbnvpPnO8wNaxfU0iqPm4RO+LoZyxbGQpyFXYFD+fPZdK2a78oVpfi71g1aS4qjjBIPK1ERZSWalCGdaNxkjG5+wXquAo18tFbacDX41shN6CxHux8bvT9NbWlsjKj6gFhpCbN7oKsafLgTQ2+mqcQO1bQxObHj3o/LiuvIWhIyakz9SmFvh0wgAXhkVoiPvoP5LXMNdbaSv49LIt7wOMZHkbtkFWMTqKRBq32NSSKi0670Tv4IDm2I1cKVWLVy0RXSOc6CXR99G2z2PC6aPQjsXvc="
REM SET JWT_TOKEN_PUBLIC_KEY=""

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
SET db_Connection_Url="mongodb+srv://badri0307:badri0307@mongodb01.qjebf.azure.mongodb.net"

REM Name			 : db_Username
REM Description      : To interact with a database, you generally first need to connect to the server. You supply a username (uid) for a server login.
REM Default Value    : root
SET db_Username=root
REM Name			 : db_Password
REM Description      : To interact with a database, you generally first need to connect to the server. You supply a password that match a server login.
REM Default Value    : root
SET db_Password=root

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

REM Name			: po_Image_Pull_Secret,dbinit_Image_Pull_Secret
REM Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htmREM:~:text=To%20create%20a%20Docker%20registry%20secret%3A. adapter_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
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

SET schema_registry_url=http://kafka-oss-cp-schema-registry:8081

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

set storage="s3://paymentorderstorage"
set serviceAccountEnable="Y"
set serviceAccountName=paymentorder-serviceaccount
set serviceAccountPolicy=kinesis-policy

REM Repository creation in EKS for Schema Registry,Kafka and Zookeeper
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

eksctl create nodegroup --cluster=%clustername% --name=%nodegroupname1% --region %clusterregion%

eksctl create nodegroup --cluster=%clustername% --name=%nodegroupname2% --region %clusterregion%


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

REM cd db/mongo
REM kubectl apply -f create-mongo-ns.yaml
REM cd crd
REM kubectl apply -f mongo_crd.yaml
REM cd ../operator
REM kubectl apply -f operator.yaml
REM kubectl apply -f role_binding.yaml
REM kubectl apply -f role.yaml
REM kubectl apply -f service_account.yaml
REM cd ../rs
REM kubectl apply -f rs.yaml
REM kubectl apply -f mongo_services.yaml

REM timeout /t 180 >nul

REM cd ../../../

helm install kafka-oss cp-helm-charts --version 0.5.0 -n kafka --set cp-zookeeper.image=%accountId%.dkr.ecr.eu-west-2.amazonaws.com/cp-zookeeper --set cp-zookeeper.imageTag=5.2.2 --set cp-kafka.image=%accountId%.dkr.ecr.eu-west-2.amazonaws.com/cp-kafka --set cp-kafka.imageTag=5.2.2 --set cp-schema-registry.image=%accountId%.dkr.ecr.eu-west-2.amazonaws.com/cp-schema-registry --set cp-schema-registry.imageTag=5.2.2 --create-namespace

kubectl create ns poappinit

helm install poappinit ./appinit -n poappinit --set env.appinit.databaseKey=%database_Key% --set env.appinit.databaseName=%database_Name% --set env.appinit.dbautoupgrade="N" --set image.tag=%tag% --set image.appinit.repository=%appInitImageTag%

timeout /t 90 >nul

kubectl create namespace paymentorder

if %serviceAccountEnable% == "Y" (
eksctl utils associate-iam-oidc-provider --cluster %clustername% --approve --region %clusterregion%

eksctl create iamserviceaccount --cluster %clustername% --name %serviceAccountName% --namespace paymentorder --attach-policy-arn arn:aws:iam::%accountId%:policy/%serviceAccountPolicy% --approve --region %clusterregion%
)

helm install paymentorder ./svc -n paymentorder --set env.database.DATABASE_KEY=%database_Key% --set env.database.MONGODB_DBNAME=%database_Name% --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://ent-postgresqldb-service.postgresql.svc.cluster.local:5432/ms_paymentorder --set pit.JWT_TOKEN_ISSUER=%Jwt_Token_Issuer% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%Jwt_Token_Principal_Claim% --set pit.ID_TOKEN_SIGNED=%Id_Token_Signed% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%Jwt_Token_Public_Key_Cert_Encoded% --set pit.JWT_TOKEN_PUBLIC_KEY=%Jwt_Token_Public_Key% --set env.database.temn_msf_db_pass_encryption_key=%encryption_Key% --set env.database.temn_msf_db_pass_encryption_algorithm=%encryption_Algorithm% --set image.paymentorderapi.repository=%apiImageTag% --set image.paymentorderingester.repository=%ingesterImageTag% --set image.paymentorderscheduler.repository=%schedulerImageTag% --set image.paymentorderinboxoutbox.repository=%inboxoutboxImageTag% --set image.fileingester.repository=%fileingesterImageTag% --set imagePullSecrets=%po_Image_Pull_Secret% --set image.tag=%tag% --set env.kafka.kafkabootstrapservers=%kafka_Bootstrap_Servers% --set env.kafka.kafkaAliases=%kafka_Aliases% --set env.kafka.kafkaip=%kafkaip% --set env.kafka.kafka0ip=%kafka0ip% --set env.kafka.kafka1ip=%kafka1ip% --set env.kafka.kafka2ip=%kafka2ip% --set env.kafka.kafkaHostName=%kafka_Host_Name% --set env.kafka.kafka0HostName=%kafka0_Host_Name% --set env.kafka.kafka1HostName=%kafka1_Host_Name% --set env.kafka.kafka2HostName=%kafka2_Host_Name% --set env.kafka.devdomainHostName=%devdomain_Host_Name% --set env.eventdelivery.outboxdirectdeliveryenabled=%eventDirectDelivery% --set env.scheduler.temn_msf_scheduler_inboxcleanup_schedule=%inbox_Cleanup% --set env.scheduler.schedule=%schedule% --set env.aws.region=%awsRegion% --set env.aws.accesskeyid=%accesskeyId% --set env.aws.accesskey=%accessKey% --set env.aws.sessionToken=%sessionToken% --set env.aws.kinesisregion=%kinesisRegion% --set env.storage.home=%storage% --set serviceaccount.enabled=%serviceAccountEnable% --set serviceaccount.name=%serviceAccountName% --set env.kinesis.requesttimeout=%requesttimeout% --set env.kinesis.maxrecords=%maxrecords% --set env.kinesis.idleinterval=%idleinterval%
