@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------
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
REM Name : ENABLE_AUDIT
REM Description : Enable the audit log feature.
REM Default Value : true
SET ENABLE_AUDIT=false
REM Name : ENABLE_AUDIT_FOR_GET_API
REM Description : Capture audit logs for get APIs.
REM Default Value : true
SET ENABLE_AUDIT_FOR_GET_API=true
REM Name : ENABLE_AUDIT_TO_CAPTURE_RESPONSE
REM Description : Capture response in the audit logs.
REM Default Value : true
SET ENABLE_AUDIT_TO_CAPTURE_RESPONSE=true
REM Name : Jwt_Token_Public_Key
REM Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
SET Jwt_Token_Public_Key="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
REM Name : Jwt_Token_Public_Key_Cert_Encoded
REM Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
SET Jwt_Token_Public_Key_Cert_Encoded=""


REM Uncomment the below lines to enable Keycloak
REM SET JWT_TOKEN_ISSUER=http://localhost:8180/auth/realms/msf
REM SET JWT_TOKEN_PRINCIPAL_CLAIM=msuser
REM SET ID_TOKEN_SIGNED=false
REM SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED="MIIClTCCAX0CBgF6etFgtDANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANNc2YwHhcNMjEwNzA2MDc1NDQwWhcNMzEwNzA2MDc1NjIwWjAOMQwwCgYDVQQDDANNc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZKa8cuSEo8cf6pYC549K2Pcpu20b173iNhgdkhV/1XLW0YktMgnxySKrcCmDbqQJDhK5FWuXN1El8UkxABibqFt8riwesglCYUspNmAszkicZAEQ/X+pu89tAXQOdg8U5kU4ZK4hzOS5D0n8ZzW2TaWCsQDoH3ng0UWGPWA7LTv+zb8f2U+SK6rkP3tkfEZVEhqUrddOeiKGFa6we4mwLPT5ZczBoVRrfpwKBL6i1JDDrWpeCZRrUjm7SFem3lLQMyF6sRQVIPLONWl7AG4ZRv7Akicag7tUeMzbIO7jRAJasrK/40e54YJ4lnVRMUXq7powEFZFigcSLSMUKrZWxAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAe9jK84bas1c+W0Ee4JfHaRPxa1x/Y+lmuWXc1kzFBRptzmQsOJXon6v1VHGTbnvpPnO8wNaxfU0iqPm4RO+LoZyxbGQpyFXYFD+fPZdK2a78oVpfi71g1aS4qjjBIPK1ERZSWalCGdaNxkjG5+wXquAo18tFbacDX41shN6CxHux8bvT9NbWlsjKj6gFhpCbN7oKsafLgTQ2+mqcQO1bQxObHj3o/LiuvIWhIyakz9SmFvh0wgAXhkVoiPvoP5LXMNdbaSv49LIt7wOMZHkbtkFWMTqKRBq32NSSKi0670Tv4IDm2I1cKVWLVy0RXSOc6CXR99G2z2PC6aPQjsXvc="
REM SET JWT_TOKEN_PUBLIC_KEY=""
REM -------------------------------------------------------------
REM 
REM Database properties
REM
REM --------------------------------------------------------------
REM Name 			: database_Key
REM Description 	: specify the name of the database server.
REM Possible values : orcl | sql
REM Default Value   : sql
SET database_Key=sql
REM Name			: db_Host
REM Description		: Specifies the host name of the sql server.
REM Default value   : paymentorder-db-service-np
SET db_Host=paymentorder-db-service-np
REM Name			: database_Name
REM Description		: Specify the name of the database used in sql server.
REM Default value   : payments
SET database_Name=payments
REM Name			 : db_Username
REM Description      : To run a SQL query or otherwise interact with a database, you generally first need to connect to the server. You supply a username (uid) for a server login.
REM Default value    : sa
SET db_Username=root
REM Name			 : db_password
REM Description      : To run a SQL query or otherwise interact with a database, you generally first need to connect to the server. You supply a password that match a server login.
REM Default value    : password
SET db_Password=password
REM Name 			: driver_Name
REM Description		: Driver provides Java database connectivity from any Java application, application server, or Java-enabled applet.The MySQL JDBC Driver enables users to connect with live MySQL data, directly from any applications that support JDBC connectivity
REM Default Value 	: com.mysql.jdbc.Driver
SET driver_Name=com.mysql.jdbc.Driver
REM Name 			: dialect
REM Description		: For connecting any hibernate application with the database, it is required to provide the configuration of MYSQL dialect.
REM Default Value	: org.hibernate.dialect.MySQL5InnoDBDialect
SET dialect=org.hibernate.dialect.MySQL5InnoDBDialect
REM Name			: db_Connection_Url
REM Description		: The general form of the connection URL is
REM  ex.  oracle:          jdbc:oracle:thin:@<host_or_ip>:1521:<db_name>
REM  ex.  db2:             jdbc:db2://<host_or_ip>:50000/<db_name>
REM  ex.  ms-sql:          jdbc:sqlserver://<host_or_ip>:1433;databaseName=<db_name>


REM jdbc:sqlserver://[serverName[\instanceName][:portNumber]][/db_name]


REM jdbc:sqlserver:// (Required) is known as the subprotocol and is constant.

REM serverName (Optional) is the address of the server to connect to. This address can be a DNS or IP address, or it can be localhost or 127.0.0.1 for the local computer. If not specified in the connection URL, the server name must be specified in the properties collection.

REM instanceName (Optional) is the instance to connect to on serverName. If not specified, a connection to the default instance is made.

REM portNumber (Optional) is the port to connect to on serverName. The default is 1433. If you're using the default, you don't have to specify the port, nor its preceding ':', in the URL.

REM db_name is the  name of the database to be used in sql server
SET db_Connection_Url=jdbc:mysql://paymentorder-db-service:3306/payments
REM Name 			: min_Pool_Size
REM Description		: Maximum number of connections maintained in the pool.
REM Default Value   : 10
SET min_Pool_Size="10"
REM Name 			: max_Pool_Size
REM Description		: Maximum number of connections maintained in the pool.
REM Default Value   : 150
SET max_Pool_Size="150"
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
REM Name 			: schema_Registry_Url
REM Description		: Schema Registry is an application that resides outside of your Kafka cluster and handles the distribution of schemas to the producer and consumer by storing a copy of schema in its local cache. Schema registry url is used to connect schema registry in kafka.
REM Default Value	: http://schema-registry-svc.kafka.svc.cluster.local
SET schema_Registry_Url="http://schema-registry-svc.kafka.svc.cluster.local" 
REM Name 			: kafka_Aliases
REM Description		: hostAliases is used to overwrite the resolution of the host name and ip at the pod level when adding entries to the /etc/hosts file of the pod.(https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/). To enable hostAliases, set the below variable to "Y"
REM Possible values : Y | N	 
REM Default Value	: N
SET kafka_Aliases="N"

REM Name			: kafkaip,kafka0ip,kafka1ip,kafka2ip
REM Description		: Set the following variables of kafka ip for hostAliases
SET kafkaip=""
SET kafka0ip=""
SET kafka1ip=""
SET kafka2ip=""

REM Name			: kafka_Host_Name,kafka0_Host_Name,kafka1_Host_Name,kafka2_Host_Name
REM Description		: Set the following variables of kafka hostname for hostAliases
SET kafka_Host_Name=""
SET kafka0_Host_Name=""
SET kafka1_Host_Name=""
SET kafka2_Host_Name=""

REM Name 			: scheduler_Time
REM Description		: Specify the Frequency to trigger the scheduler job is set in this property.
REM Default Value	: 59 * * ? * *
SET scheduler_Time="59 * * ? * *"

REM -------------------------------------------------------------
REM 
REM IMAGE PROPERTIES
REM
REM --------------------------------------------------------------
REM Name			: tag
REM Description		: Specifies the release version of the image
SET tag=DEV
REM Name         :apiImage,ingesterImage,inboxoutboxImage,schemaregistryImage,schedulerImage,fileingesterImage,mysqlImage
REM Description 	: Specifies the name of Images for api ,ingester,inboxoutbox, schemaregistry,scheduler,fileingester,mysql that are  pushed to external repositories,
REM Example			: Consider our external repository is "acr.azurecr.io" and tag is "DEV". It should be like acr.azurecr.io/temenos/ms-paymentorder-service:DEV
SET apiImage=temenos/ms-paymentorder-service
SET ingesterImage=temenos/ms-paymentorder-ingester
SET inboxoutboxImage=temenos/ms-paymentorder-inboxoutbox
SET schemaregistryImage=confluentinc/cp-schema-registry
SET schedulerImage=temenos/ms-paymentorder-scheduler
SET fileingesterImage=temenos/ms-paymentorder-fileingester
SET mysqlImage=ms-paymentorder-mysql
REM Name			: es_Image_Pull_Secret
REM Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htm#:~:text=To%20create%20a%20Docker%20registry%20secret%3A. es_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
SET es_Image_Pull_Secret=""

SET dbinit_Connection_Url="jdbc:mysql://paymentorder-db-service.payments.svc.cluster.local:3306/payments"

SET APP_INIT_IMAGE="temenos/ms-paymentorder-appinit"

kubectl create namespace payments

kubectl create namespace posqlappinit

cd helm-chart

helm install posqlappinit ./appinit -n posqlappinit --set env.sqlinit.databaseKey=%database_Key% --set env.sqlinit.databaseName=%database_Name% --set env.sqlinit.dbusername=%db_Username% --set env.sqlinit.dbpassword=%db_Password% --set image.tag=%tag% --set image.sqlinit.repository=%APP_INIT_IMAGE% --set env.sqlinit.dbconnectionurl=%dbinit_Connection_Url% --set env.sqlinit.dbautoupgrade="N" --set env.sqlinit.dbdialect=%dialect% --set env.sqlinit.dbdriver=%driver_Name%

helm install payments ./svc -n payments --set env.database.host=%db_Host% --set env.database.db_username=%db_Username% --set env.database.db_password=%db_Password% --set env.database.database_key=%database_Key%  --set env.database.database_name=%database_Name% --set env.database.driver_name=%driver_Name% --set env.database.dialect=%dialect% --set env.database.db_connection_url=%db_Connection_Url% --set pit.JWT_TOKEN_ISSUER=%Jwt_Token_Issuer% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%Jwt_Token_Principal_Claim% --set pit.ID_TOKEN_SIGNED=%Id_Token_Signed% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%Jwt_Token_Public_Key_Cert_Encoded% --set pit.JWT_TOKEN_PUBLIC_KEY=%Jwt_Token_Public_Key% --set env.database.max_pool_size=%max_Pool_Size% --set env.database.min_pool_size=%min_Pool_Size% --set env.kafka.kafkabootstrapservers=%kafka_Bootstrap_Servers% --set env.kafka.schema_registry_url=%schema_Registry_Url% --set env.kafka.kafkaAliases=%kafka_Aliases% --set env.kafka.kafkaip=%kafkaip% --set env.kafka.kafka0ip=%kafka0ip% --set env.kafka.kafka1ip=%kafka1ip% --set env.kafka.kafka2ip=%kafka2ip% --set env.kafka.kafkaHostName=%kafka_Host_Name% --set env.kafka.kafka0HostName=%kafka0_Host_Name% --set env.kafka.kafka1HostName=%kafka1_Host_Name% --set env.kafka.kafka2HostName=%kafka2_Host_Name% --set env.scheduler.time=%scheduler_Time% --set image.tag=%tag% --set image.paymentsapi.repository=%apiImage% --set image.paymentsingester.repository=%ingesterImage% --set image.paymentseventdelivery.repository=%inboxoutboxImage% --set image.schemaregistry.repository=%schemaregistryImage% --set image.paymentorderscheduler.repository=%schedulerImage% --set image.fileingester.repository=%fileingesterImage% --set image.mysql.repository=%mysqlImage% --set imagePullSecrets=%es_Image_Pull_Secret% --set audit.ENABLE_AUDIT=%ENABLE_AUDIT% --set audit.ENABLE_AUDIT_FOR_GET_API=%ENABLE_AUDIT_FOR_GET_API% --set audit.ENABLE_AUDIT_TO_CAPTURE_RESPONSE=%ENABLE_AUDIT_TO_CAPTURE_RESPONSE%  


cd ../

cd samples/streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd external

kubectl apply -f payments-nodeport.yaml -n payments 

cd ../..