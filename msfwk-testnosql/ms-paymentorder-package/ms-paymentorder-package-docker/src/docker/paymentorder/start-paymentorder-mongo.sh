#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# Name : Jwt_Token_Issuer
# Description : Identifies the issuer of the authentication token.
# Default Value : https://localhost:9443/oauth2/token
export Jwt_Token_Issuer=https://localhost:9443/oauth2/token
# Name : Jwt_Token_Principal_Claim
# Description : Indicates the claim in which the user principal is provided.
# Default Value : sub
export Jwt_Token_Principal_Claim=sub
# Name : Id_Token_Signed
# Description : Enables the JWT signature validation along with the header and payload
# Default Value : true
export Id_Token_Signed=true
# Name : Jwt_Token_Public_Key
# Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
export Jwt_Token_Public_Key="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
# Name : Jwt_Token_Public_Key_Cert_Encoded
# Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
export Jwt_Token_Public_Key_Cert_Encoded=""


# UNCOMMENT THE BELOW LINES TO ENABLE KEYCLOAK
# export JWT_TOKEN_ISSUER=http://localhost:8180/auth/realms/msf
# export JWT_TOKEN_PRINCIPAL_CLAIM=msuser
# export ID_TOKEN_SIGNED=false
# export JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED="MIIClTCCAX0CBgF6etFgtDANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANNc2YwHhcNMjEwNzA2MDc1NDQwWhcNMzEwNzA2MDc1NjIwWjAOMQwwCgYDVQQDDANNc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZKa8cuSEo8cf6pYC549K2Pcpu20b173iNhgdkhV/1XLW0YktMgnxySKrcCmDbqQJDhK5FWuXN1El8UkxABibqFt8riwesglCYUspNmAszkicZAEQ/X+pu89tAXQOdg8U5kU4ZK4hzOS5D0n8ZzW2TaWCsQDoH3ng0UWGPWA7LTv+zb8f2U+SK6rkP3tkfEZVEhqUrddOeiKGFa6we4mwLPT5ZczBoVRrfpwKBL6i1JDDrWpeCZRrUjm7SFem3lLQMyF6sRQVIPLONWl7AG4ZRv7Akicag7tUeMzbIO7jRAJasrK/40e54YJ4lnVRMUXq7powEFZFigcSLSMUKrZWxAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAe9jK84bas1c+W0Ee4JfHaRPxa1x/Y+lmuWXc1kzFBRptzmQsOJXon6v1VHGTbnvpPnO8wNaxfU0iqPm4RO+LoZyxbGQpyFXYFD+fPZdK2a78oVpfi71g1aS4qjjBIPK1ERZSWalCGdaNxkjG5+wXquAo18tFbacDX41shN6CxHux8bvT9NbWlsjKj6gFhpCbN7oKsafLgTQ2+mqcQO1bQxObHj3o/LiuvIWhIyakz9SmFvh0wgAXhkVoiPvoP5LXMNdbaSv49LIt7wOMZHkbtkFWMTqKRBq32NSSKi0670Tv4IDm2I1cKVWLVy0RXSOc6CXR99G2z2PC6aPQjsXvc="
# export JWT_TOKEN_PUBLIC_KEY=""


# Name 			  : database_Key
# Description 	  : specify the name of the database server.
# Possible values : mongodb | postgresql
# Default Value   : mongodb
export database_Key=mongodb
# Name			  : database_Name
# Description	  : Specify the name of the database used in sql server.
# Default value   : paymentorder
export database_Name=ms_paymentorder 

# Name			: db_Enable_Secret
# Description		: A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key.If db_Enable_Secret is set to 'Y'. It will allow to fetch the DB username and DB password through k8s secrets for MySQL DB.
# Possible values : Y | N	  
# Default value   : N
export db_Enable_Secret="N"

# Name			: appinit_cred for appinit
# Description		: A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key.If appinit_cred is set to 'Y'. It will allow to fetch the DB username and DB password through k8s secrets appinit pod
# Possible values : Y | N	  
# Default value   : N
export appinit_cred="N"

# Name			    : db_Connection_Url
# Description		: The general form of the connection URL is
#  ex.  oracle:          jdbc:oracle:thin:@<host_or_ip>:1521:<db_name>
#  ex.  db2:             jdbc:db2://<host_or_ip>:50000/<db_name>
#  ex.  ms-sql:          jdbc:sqlserver://<host_or_ip>:1433;databaseName=<db_name>
#  ex.  mongodb:         mongodb://[username:password@]host1[:port1][,...hostN[:portN]][/[defaultauthdb][?options]]


# Name 			: db_Connection_Url
# Description		: We are using mongodb by default 

# The general form of the connection URL for shared cluster is
    # mongodb://<hostname>:<port>,<hostname>:<port>
    # mongodb://mongos0.example.com:27017,mongos1.example.com:27017,mongos2.example.com:27017


# mongodb:// -- A required prefix to identify that this is a string in the standard connection format.
    
# host[:port] -- The host (and optional port number) where mongos instance for a sharded cluster is running. You can specify a hostname, IP address, or UNIX domain socket. Specify as many hosts as appropriate for your deployment topology.If the port number is not specified, the default port 27017 is used.

export db_Connection_Url=mongodb://mongodb-0.mongodb-svc.mongodb.svc.cluster.local:27017'\',mongodb-1.mongodb-svc.mongodb.svc.cluster.local:27017'\',mongodb-2.mongodb-svc.mongodb.svc.cluster.local:27017
# Name			   : db_Username
# Description      : To interact with a database, you generally first need to connect to the server. You supply a username (uid) for a server login.
# Default Value    : root
export db_Username=root
# Name			   : db_password
# Description      : To interact with a database, you generally first need to connect to the server. You supply a password that match a server login.
# Default Value    : root
export db_Password=root

# -------------------------------------------------------------
# 
# IMAGE PROPERTIES
#
# --------------------------------------------------------------
#Name				: tag
#Description		: Specifies the release version of the image
export tag="DEV"
# Name			: apiImage,ingesterImage,schedulerImage,fileingesterImage,schemaregistryImage,dbinitImage
# Description 	: Specifies the name of Images for api ,ingester,scheduler,fileingesterImage,schemaregistryImage,dbinitImage that are  pushed to external repositories,
# Example			: Consider our external repository is "acr.azurecr.io" and tag is "DEV". It should be like acr.azurecr.io/temenos/ms-paymentorder-service:DEV
export apiImage=dev.local/temenos/ms-paymentorder-service
export ingesterImage=dev.local/temenos/ms-paymentorder-ingester
export schedulerImage=dev.local/temenos/ms-paymentorder-scheduler
export fileingesterImage=dev.local/temenos/ms-paymentorder-fileingester
export schemaregistryImage=confluentinc/cp-schema-registry

export dbinitImage=dev.local/temenos/ms-paymentorder-dbscripts

# Name			: po_Image_Pull_Secret,dbinit_Image_Pull_Secret
# Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htm#:~:text=To%20create%20a%20Docker%20registry%20secret%3A. adapter_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
export po_Image_Pull_Secret=""
export dbinit_Image_Pull_Secret=""

# Name			: encryption_Key,encryption_Algorithm
# Description 	: For encrypting the plain text's, need some inputs i.e., Password and an Algorithm which is used to encrypt/decrypt an given input. These two values are mandatory to encrypt the plain text.
# Default value 	: temenos for key and PBEWithMD5AndTripleDES for algorithm.
export encryption_Key=temenos
export encryption_Algorithm=PBEWithMD5AndTripleDES

# Name 			   : gc_Base_Path
# Description	   : Specify the url to connect generic configuration microservice.
# Default Value	   : http://localhost:7006/ms-genericconfig-api/api/v2.0.0/
export gc_Base_Path="http://localhost:7006/ms-genericconfig-api/api/v2.0.0/"
# -------------------------------------------------------------
# 
# Kafka properties
#
# --------------------------------------------------------------
# Name 			: kafka_Bootstrap_Servers
# Description	: It contains a list of host/port pairs for establishing the initial connection to the Kafka cluster.A host and port pair uses : as the separator.
# Example		: localhost:9092,localhost:9092,another.host:9092
# Default Value	: my-cluster-kafka-bootstrap.kafka:9092
export kafka_Bootstrap_Servers="my-cluster-kafka-bootstrap.kafka:9092"

# Name 			: kafka_Aliases
# Description	: hostAliases is used to overwrite the resolution of the host name and ip at the pod level when adding entries to the /etc/hosts file of the pod.(https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/). To enable hostAliases, set the below variable to "Y"
# Possible values : Y | N	 
# Default Value	: N
export kafka_Aliases="N"

# Name			: kafkaip,kafka0ip,kafka1ip,kafka2ip,devdomain
# Description	: Set the following variables of kafka ip for hostAliases
export kafkaip=""
export kafka0ip=""
export kafka1ip=""
export kafka2ip=""
export devdomain=""
# Name			: kafka_Host_Name,kafka0_Host_Name,kafka1_Host_Name,kafka2_Host_Name,devdomain_Host_Name
# Description	: Set the following variables of kafka hostname for hostAliases
export kafka_Host_Name=""
export kafka0_Host_Name=""
export kafka1_Host_Name=""
export kafka2_Host_Name=""
export devdomain_Host_Name=""

# Name            : inbox_Cleanup
# Descripton        : Specifies No of Minutes required to hold the records inside ms_inbox_events table before automatic deletion.
# Default Value    : 60
export inbox_Cleanup="60"
# Name             : schedule
# Description        : Specify the Frequency to trigger the scheduler job is set in this property.
# Default Value    : 5
export schedule="5"

# Name             : eventDirectDelivery
# Description      : If the value is true. Framework will directly deliver the events to respective topics. It skip the <msf>-outbox topic. If the value is false. It will delivers the events to <msf>-outbox topic and event delivery service will delivers the events to respective topic.
export eventDirectDelivery=true

cd helm-chart

#kubectl create ns poappinit

export APP_INIT_IMAGE="dev.local/temenos/ms-paymentorder-appinit"

#helm install poappinit ./appinit -n poappinit --set env.appinit.databaseKey=mongodb --set env.appinit.databaseName=$database_Name --set image.appinit.repository=$APP_INIT_IMAGE --set image.tag=$tag --set env.appinit.dbConnectionUrl=\"${db_Connection_Url}\" --set env.appinit.dbautoupgrade="N"

#sleep 90

#kubectl create namespace paymentorder

helm install paymentorder ./svc -n paymentorder --create-namespace -n paymentorder --set env.database.DATABASE_KEY=$database_Key --set env.database.MONGODB_DBNAME=$database_Name --set env.database.MONGODB_CONNECTIONSTR=\"${db_Connection_Url}\"  --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://ent-postgresqldb-service.postgresql.svc.cluster.local:5432/ms_paymentorder --set pit.JWT_TOKEN_ISSUER=$Jwt_Token_Issuer --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$Jwt_Token_Principal_Claim --set pit.ID_TOKEN_SIGNED=$Id_Token_Signed --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$Jwt_Token_Public_Key_Cert_Encoded --set pit.JWT_TOKEN_PUBLIC_KEY=$Jwt_Token_Public_Key --set env.database.temn_msf_db_pass_encryption_key=$encryption_Key --set env.database.temn_msf_db_pass_encryption_algorithm=$encryption_Algorithm --set env.genericconfig.basepath=$gc_Base_Path --set image.paymentorderapi.repository=$apiImage --set image.paymentorderingester.repository=$ingesterImage --set image.paymentorderscheduler.repository=$schedulerImage --set image.fileingester.repository=$fileingesterImage --set image.schemaregistry.repository=$schemaregistryImage --set imagePullSecrets=$po_Image_Pull_Secret --set image.tag=$tag --set env.kafka.kafkabootstrapservers=$kafka_Bootstrap_Servers --set env.kafka.kafkaAliases=$kafka_Aliases --set env.kafka.kafkaip=$kafkaip --set env.kafka.kafka0ip=$kafka0ip --set env.kafka.kafka1ip=$kafka1ip --set env.kafka.kafka2ip=$kafka2ip --set env.kafka.kafkaHostName=$kafka_Host_Name --set env.kafka.kafka0HostName=$kafka0_Host_Name --set env.kafka.kafka1HostName=$kafka1_Host_Name --set env.kafka.kafka2HostName=$kafka2_Host_Name --set env.kafka.devdomainHostName=$devdomain_Host_Name --set env.eventdelivery.outboxdirectdeliveryenabled=$eventDirectDelivery --set env.scheduler.temn_msf_scheduler_inboxcleanup_schedule=$inbox_Cleanup --set env.scheduler.schedule=$schedule --set image.appinit.repository=$APP_INIT_IMAGE

cd ../

cd samples/streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml