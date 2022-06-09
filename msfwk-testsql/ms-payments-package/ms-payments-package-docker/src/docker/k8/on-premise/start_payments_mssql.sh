#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------
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

# -------------------------------------------------------------
# 
# Database properties
#
# --------------------------------------------------------------
# Name 			  : database_Key
# Description 	  : specify the name of the database server.
# Possible values : orcl | sql
# Default Value   : sql
export database_Key=sql
# Name			  : db_Host
# Description	  : Specifies the host name of the sql server.
# Default value   : paymentorder-db-service
export db_Host=paymentorder-db-service
# Name			  : database_Name
# Description	  : Specify the name of the database used in sql server.
# Default value   : payments
export database_Name=payments
#Name			  : db_Username
#Description      : To run a SQL query or otherwise interact with a database, you generally first need to connect to the server. You supply a username (uid) for a server login.
#Default value    : sa
export db_Username=sa
#Name			  : db_Password
#Description      : To run a SQL query or otherwise interact with a database, you generally first need to connect to the server. You supply a password that match a server login.
#Default value    : Rootroot@12345
export db_Password=Rootroot@12345
# Name 			  : driver_Name
# Description	  : Driver provides Java database connectivity from any Java application, application server, or Java-enabled applet.The MySQL JDBC Driver enables users to connect with live MySQL data, directly from any applications that support JDBC connectivity
# Default Value   : com.microsoft.sqlserver.jdbc.SQLServerDriver
export driver_Name=com.microsoft.sqlserver.jdbc.SQLServerDriver
# Name 			  : dialect
# Description	  : For connecting any hibernate application with the database, it is required to provide the configuration of MYSQL dialect.
# Default Value	  : org.hibernate.dialect.SQLServer2012Dialect
export dialect=org.hibernate.dialect.SQLServer2012Dialect
# Name			  : db_Connection_Url
# Description	  : The general form of the connection URL is
#  ex.  oracle:          jdbc:oracle:thin:@<host_or_ip>:1521:<db_name>
#  ex.  db2:             jdbc:db2://<host_or_ip>:50000/<db_name>
#  ex.  ms-sql:          jdbc:sqlserver://<host_or_ip>:1433;databaseName=<db_name>
# jdbc:sqlserver://[serverName[\instanceName][:portNumber]][/db_name]

# jdbc:sqlserver:// (Required) is known as the subprotocol and is constant.

# serverName (Optional) is the address of the server to connect to. This address can be a DNS or IP address, or it can be localhost or 127.0.0.1 for the local computer. If not specified in the connection URL, the server name must be specified in the properties collection.

# instanceName (Optional) is the instance to connect to on serverName. If not specified, a connection to the default instance is made.

# portNumber (Optional) is the port to connect to on serverName. The default is 1433. If you're using the default, you don't have to specify the port, nor its preceding ':', in the URL.

# db_name is the  name of the database to be used in sql server

export db_Connection_Url=jdbc:sqlserver://paymentorder-db-service:1433;databaseName=payments
# Name 			  : min_Pool_Size
# Description	  : Minimum number of connections allowed in the pool.
# Default Value   : 10
export min_Pool_Size="10"
# Name 			  : max_Pool_Size
# Description	  : Maximum number of connections maintained in the pool.
# Default Value   : 150
export max_Pool_Size="150"

# -------------------------------------------------------------
# 
# Kafka setup
#
# --------------------------------------------------------------
# Name 			  : kafka_Bootstrap_Servers
# Description	  : It contains a list of host/port pairs for establishing the initial connection to the Kafka cluster.A host and port pair uses : as the separator.
# Example		  : localhost:9092,localhost:9092,another.host:9092
# Default Value	  : my-cluster-kafka-bootstrap.kafka:9092
export kafka_Bootstrap_Servers="my-cluster-kafka-bootstrap.kafka:9092"
# Name 			  : schema_Registry_Url
# Description	  : Schema Registry is an application that resides outside of your Kafka cluster and handles the distribution of schemas to the producer and consumer by storing a copy of schema in its local cache. Schema registry url is used to connect schema registry in kafka.
# Default Value	  : http://schema-registry-svc.kafka.svc.cluster.local
export schema_Registry_Url="http://schema-registry-svc.kafka.svc.cluster.local" 
# Name 			: scheduler_Time
# Description		: Specify the Frequency to trigger the scheduler job is set in this property.
# Default Value	: 59 * * ? * *
export scheduler_Time="59 * * ? * *"
# Name 			  : kafka_Aliases
# Description	  : hostAliases is used to overwrite the resolution of the host name and ip at the pod level when adding entries to the /etc/hosts file of the pod.(https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/). To enable hostAliases, set the below variable to "Y"
# Possible values : Y | N	 
# Default Value	  : N
export kafka_Aliases="N"
# Name			  : kafkaip,kafka0ip,kafka1ip,kafka2ip
# Description	  : Set the following variables of kafka ip for hostAliases
export kafkaip=""
export kafka0ip=""
export kafka1ip=""
export kafka2ip=""
# Name			  : kafka_Host_Name,kafka0_Host_Name,kafka1_Host_Name,kafka2_Host_Name
# Description	  : Set the following variables of kafka hostname for hostAliases
export kafka_Host_Name=""
export kafka0_Host_Name=""
export kafka1_Host_Name=""
export kafka2_Host_Name=""


#  ------- IMAGE PROPERTIES
# Name			 : tag
# Description	 : Specifies the release version of the image
export tag=DEV
# Name			 : api_Image,ingester_Image,inboxoutbox_Image,scheduler_Image,schemaregistry_Image,fileingester_Image,mysql_Image
# Description 	 : Specifies the name of Images for api ,ingester,schemaregistry, scheduler,fileingester, mysql that are  pushed to external repositories,
# Example		 : Consider our external repository is "acr.azurecr.io" and tag is "DEV". It should be like acr.azurecr.io/temenos/paymentorder-service:DEV
export apiImage=temenos/ms-paymentorder-service
export ingesterImage=temenos/ms-paymentorder-ingester
export inboxoutboxImage=temenos/ms-paymentorder-inboxoutbox
export schemaregistryImage=confluentinc/cp-schema-registry
export schedulerImage=temenos/ms-paymentorder-scheduler
export fileingesterImage=temenos/ms-paymentorder-fileingester
export mysqlImage=ms-paymentorder-mysql
# Name			    : es_Image_Pull_Secret
# Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htm#:~:text=To%20create%20a%20Docker%20registry%20secret%3A. es_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
export es_Image_Pull_Secret=""

cd ../..

./build-mssql.sh build

cd k8/on-premise/db

export currentString="docker-compose"
export replaceString="#docker-compose"
sed -i -e 's/'"$currentString"'/'"$replaceString"'/g' start-mssql-db-scripts.sh

./start-mssql-db-scripts.sh

cd ../

sleep 60

kubectl create namespace payments

helm install payments ./svc -n payments --set env.database.host=$db_Host --set env.database.db_username=$db_Username --set env.database.db_password=$db_Password --set env.database.DATABASE_KEY=$database_Key --set env.database.database_name=$database_Name --set env.database.driver_name=$driver_Name --set env.database.dialect=$dialect --set env.database.db_connection_url=$db_Connection_Url --set pit.JWT_TOKEN_ISSUER=$Jwt_Token_Issuer --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$Jwt_Token_Principal_Claim --set pit.ID_TOKEN_SIGNED=$Id_Token_Signed --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$Jwt_Token_Public_Key_Cert_Encoded --set pit.JWT_TOKEN_PUBLIC_KEY=$Jwt_Token_Public_Key --set env.database.max_pool_size=$max_Pool_Size --set env.database.min_pool_size=$min_Pool_Size --set env.kafka.kafkabootstrapservers=$kafka_Bootstrap_Servers --set env.kafka.schema_registry_url=$schema_Registry_Url --set env.kafka.kafkaAliases=$kafka_Aliases --set env.kafka.kafkaip=$kafkaip --set env.kafka.kafka0ip=$kafka0ip --set env.kafka.kafka1ip=$kafka1ip --set env.kafka.kafka2ip=$kafka2ip --set env.kafka.kafkaHostName=$kafka_Host_Name --set env.kafka.kafka0HostName=$kafka0_Host_Name --set env.kafka.kafka1HostName=$kafka1_Host_Name --set env.kafka.kafka2HostName=$kafka2_Host_Name --set env.scheduler.time=$scheduler_Time --set image.tag=$tag --set image.paymentsapi.repository=$apiImage --set image.paymentsingester.repository=$ingesterImage --set image.paymentseventdelivery.repository=$inboxoutboxImage --set image.schemaregistry.repository=$schemaregistryImage --set image.paymentorderscheduler.repository=$schedulerImage --set image.fileingester.repository=$fileingesterImage --set image.mysql.repository=$mysqlImage --set imagePullSecrets=$es_Image_Pull_Secret


cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f payments-nodeport.yaml -n payments 

cd ../..