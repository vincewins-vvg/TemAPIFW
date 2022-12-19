#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

export accountId=600670497877
export awsRegion=eu-west-2
export accesskeyId=ASIAYXWWANRKUGEMMIMZ
export accessKey=0bJjeNllbo6lg6sUcVFDsjOiHhFwRF+ynzPvT1ZI
export sessionToken=IQoJb3JpZ2luX2VjEB0aCWV1LXdlc3QtMSJHMEUCIQDLnRs/nmZdLoqlaNWQsVKoAYEX7GxL9pLwRJOgOjD1gAIgVRFg5wnKdF1GD8mfY0yCT8A718/fRyHnjytsEC45UQcqkQMIVhAAGgw2MDA2NzA0OTc4NzciDO+1PhnmoTBDqqP1aSruAsItiwvn71hx/QMjpZqkjUMDcGMVgr1gu0ydFy1ZJb49mKFvivTpQT7Zishc959el8JNsEUvG/8MJGCGgz9a/d0OEl12/L+BsWCStPpWBXaoNTl9xlSDnRAJKtDoTX5NxN3GP1iG7iun2B0AC2ziI1WCr1PUNrl8D1+ruzo9/39CdsZG5hY7jvvN6UL20p+qvgdhq+dQq6XXfW8no9QTbrbdrMDZHFXORTfaZIzkvzaeL+rKVCEPaO6Pw3uE+eGkgV5P8pn2dKBmO120gkD0wR9oQww5Nu8ZPkNg8hhmoLk0lgyWjvMZm/pQ96hgf5COn2H71Li1T30QmMX2DAZG38HHRd+lLaPuAYNO9Vk7l9w+Pxf0PWw7U2gtRKfzgZbVhbsELYNkbj60flKWEtLGNkSgcYTU94BE+kgm9EWiCw9/5g5HNfouYJ7z78GJv4wMSlHpIwAFbLblJPwHAqHcvJjcyzLLgW7TnJZUlf0HfDCR3/+cBjqmAZcOtGS9Y28UlrE5NUHXAEOUF79anO3zCK02JvsbSVBJHsnqMixoyIQ3K/mgloCBuKB5iGjIjdlVX7p0NgYiR9EpVBoqVvdhthB/GF93EAgZ6soGc9mn7QIbC1K+I5AZc79dSEdJQilrFugrmzW5Z8Cn/ZX/1FfQDNIVklvrF6NcUMhBP7J4KWU9h9JKzwkOHS1uotrUUu398gdTgdk+oBs+qYD8eMY=
# kinesis Region
export kinesisRegion=eu-west-2
export ecrregion=$awsRegion
# Cluster Information
export clustername=ms-paymentcluster
export clusterregion=eu-west-2
export nodegroupname=ms-paymentcluster-nodes
export repositoryname=ms-paymentimagerepository

# Name : Jwt_Token_Issuer
# Description : Identifies the issuer of the authentication token.
# Default Value : https://localhost:9443/oauth2/token
export Jwt_Token_Issuer =https://localhost:9443/oauth2/token
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

export db_Connection_Url=jdbc:sqlserver://paymentorder-db-service:3007;databaseName=payments

export dbinit_Connection_Url="jdbc:sqlserver://paymentorder-db-service.payments.svc.cluster.local:3007;databaseName=payments"

# Name 			  : min_Pool_Size
# Description	  : Minimum number of connections allowed in the pool.
# Default Value   : 10
export min_Pool_Size="10"
# Name 			  : max_Pool_Size
# Description	  : Maximum number of connections maintained in the pool.
# Default Value   : 150
export max_Pool_Size="150"
# Name 			  : schema_Registry_Url
# Description	  : Schema Registry is an application that resides outside of your Kafka cluster and handles the distribution of schemas to the producer and consumer by storing a copy of schema in its local cache. Schema registry url is used to connect schema registry in kafka.
# Default Value	  : http://schema-registry-svc.kafka.svc.cluster.local
export schema_Registry_Url="http://afa91311ff4fa4dbc8c0a90c23a5ea4c-1855601373.eu-west-2.elb.amazonaws.com:8081" 
# Name 			: scheduler_Time
# Description		: Specify the Frequency to trigger the scheduler job is set in this property.
# Default Value	: 59 * * ? * *
export scheduler_Time="59 * * ? * *"

# Name            : inbox_Cleanup
# Descripton        : Specifies No of Minutes required to hold the records inside ms_inbox_events table before automatic deletion.
# Default Value    : 60
export inbox_Cleanup="60"
# Name             : schedule
# Description        : Specify the Frequency to trigger the scheduler job is set in this property.
# Default Value    : 5
export schedule="5"

#  ------- IMAGE PROPERTIES
# Name			 : tag
# Description	 : Specifies the release version of the image
export tag=DEV
# Name			 : apiImage,ingesterImage,inboxoutboxImage,schedulerImage,schemaregistryImage,fileingesterImage,mysqlImage
# Description 	 : Specifies the name of Images for api ,ingester,schemaregistry, scheduler,fileingester, mysql that are  pushed to external repositories,
# Example		 : Consider our external repository is "acr.azurecr.io" and tag is "DEV". It should be like acr.azurecr.io/temenos/paymentorder-service:DEV
export apiImage=temenos/ms-paymentorder-service
export ingesterImage=temenos/ms-paymentorder-ingester
export inboxoutboxImage=temenos/ms-paymentorder-inboxoutbox
export schedulerImage=temenos/ms-paymentorder-scheduler
export fileingesterImage=temenos/ms-paymentorder-fileingester
export appInitImage="temenos/ms-paymentorder-appinit"

export apiImageTag=$accountId.dkr.ecr.$ecrregion.amazonaws.com/$repositoryname:apiservice
export ingesterImageTag=$accountId.dkr.ecr.$ecrregion.amazonaws.com/$repositoryname:ingesterservice
export schedulerImageTag=$accountId.dkr.ecr.$ecrregion.amazonaws.com/$repositoryname:schedulerservice
export inboxoutboxImageTag=$accountId.dkr.ecr.$ecrregion.amazonaws.com/$repositoryname:inboxoutboxservice
export fileingesterImageTag=$accountId.dkr.ecr.$ecrregion.amazonaws.com/$repositoryname:fileingesterservice
export appInitImageTag=$accountId.dkr.ecr.$ecrregion.amazonaws.com/$repositoryname:appinitservice

# Name			: es_Image_Pull_Secret
# Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htm#:~:text=To%20create%20a%20Docker%20registry%20secret%3A. es_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
export es_Image_Pull_Secret=""

# Name             : Audit 
# Description      : To capture system events for query 
export query_enable_system_events="false"

export query_enable_response="false"

# -- Kinesis consumer default polling config for multi shard

# Name            : requesttimeout 
# Description     : The maximum time to wait for a future request from Kinesis to complete
# Default Value   : 30 seconds, default value provided in kcl
export requesttimeout=30

# Name            : maxrecords 
# Description     : Max records to fetch from Kinesis in a single GetRecords call
# Default Value   : 10000, default value provided in kcl
export maxrecords=10000

# Name            : idleinterval 
# Description     : The value for how long the ShardConsumer should sleep in between calls to getRecords.
# Default Value   : 1000 milliseconds, default value provided in kcl
export idleinterval=1000

export storage="s3://paymentsstorage"

export serviceAccountEnable="N"
export serviceAccountName=payments-serviceaccount
export serviceAccountPolicy=kinesis-policy

aws ecr create-repository --repository-name $repositoryname  --region $ecrregion

aws ecr get-login-password --region $ecrregion | docker login --username AWS --password-stdin $accountId.dkr.ecr.ecrregion.amazonaws.com

docker tag $apiImage:$tag $apiImageTag

docker push $apiImageTag

docker tag $ingesterImage:$tag $ingesterImageTag

docker push $ingesterImageTag

docker tag $inboxoutboxImage:$tag $inboxoutboxImageTag

docker push $inboxoutboxImageTag

docker tag $schedulerImage:$tag $schedulerImageTag

docker push $schedulerImageTag

docker tag $fileingesterImage:$tag $fileingesterImageTag

docker push $fileingesterImageTag

docker tag $appInitImage:$tag $appInitImageTag

docker push $appInitImageTag

# Uncomment the below to push the mssql image into ECR
docker tag temenos/ms-paymentorder-mssql:DEV $accountId.dkr.ecr.eu-west-2.amazonaws.com/$repositoryname:mssql
docker push $accountId.dkr.ecr.eu-west-2.amazonaws.com/$repositoryname:mssql

aws kinesis create-stream --stream-name table-update-paymentorder --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name paymentorder-outbox --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name ms-eventstore-inbox-topic --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name ms-paymentorder-inbox-topic --shard-count 1
sleep 10
aws kinesis create-stream --stream-name paymentorder-inbox-topic --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name paymentorder-event-topic --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name ms-paymentorder-inbox-error-topic --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name ms-paymentorder-outbox --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name error-paymentorder --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name table-update --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name multipart-topic --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name ms-paymentorder-ingester-consumer --shard-count 1 
sleep 10
aws kinesis create-stream --stream-name ms-paymentorder-ingester-error-producer --shard-count 1
sleep 10
aws kinesis create-stream --stream-name Test-topic --shard-count 1
sleep 10
aws kinesis create-stream --stream-name table-update-splitData --shard-count 1
sleep 10
aws kinesis create-stream --stream-name reprocess-event --shard-count 1

aws s3 mb $storage
sleep 10

# Uncomment the below to run the mssql db
# cd db/mssql

# kubectl apply -f namespace.yaml

# kubectl apply -f mssql-db.yaml

# kubectl apply -f mssql-db-secrets.yaml

# cd ../..

kubectl create namespace payments

kubectl create namespace posqlappinit


helm install posqlappinit ./appinit -n posqlappinit --set env.sqlinit.databaseKey=$database_Key --set env.sqlinit.databaseName=$database_Name --set env.sqlinit.dbusername=$db_Username --set env.sqlinit.dbpassword=$db_Password --set image.tag=$tag --set image.sqlinit.repository=$appInitImageTag --set env.sqlinit.dbconnectionurl=$dbinit_Connection_Url --set env.sqlinit.dbautoupgrade="N" --set env.sqlinit.dbdialect=$dialect --set env.sqlinit.dbdriver=$driver_Name

if $serviceAccountEnable == "Y" (
eksctl utils associate-iam-oidc-provider --cluster $clustername --approve --region $clusterregion

eksctl create iamserviceaccount --cluster $clustername --name $serviceAccountName --namespace payments --attach-policy-arn arn:aws:iam::$accountId:policy/$serviceAccountPolicy --approve --region $clusterregion
)

helm install payments ./svc -n payments --set env.database.host=$db_Host --set env.database.db_username=$db_Username --set env.database.db_password=$db_Password --set env.database.database_key=$database_Key  --set env.database.database_name=$database_Name --set env.database.driver_name=$driver_Name --set env.database.dialect=$dialect --set env.database.db_connection_url=$db_Connection_Url --set pit.JWT_TOKEN_ISSUER=$Jwt_Token_Issuer --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$Jwt_Token_Principal_Claim --set pit.ID_TOKEN_SIGNED=$Id_Token_Signed --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$Jwt_Token_Public_Key_Cert_Encoded --set pit.JWT_TOKEN_PUBLIC_KEY=$Jwt_Token_Public_Key --set env.database.max_pool_size=$max_Pool_Size --set env.database.min_pool_size=$min_Pool_Size --set env.kafka.schema_registry_url=$schema_Registry_Url --set env.scheduler.time=$scheduler_Time --set image.tag=$tag --set image.paymentsapi.repository=$apiImageTag --set image.paymentsingester.repository=$ingesterImageTag --set image.paymentseventdelivery.repository=$inboxoutboxImageTag --set image.fileingester.repository=$fileingesterImageTag --set imagePullSecrets=$es_Image_Pull_Secret --set env.scheduler.temn_msf_scheduler_inboxcleanup_schedule=$inbox_Cleanup --set env.scheduler.schedule=$schedule --set env.audit.query_enable_system_events=$query_enable_system_events --set env.audit.query_enable_response=$query_enable_response --set env.aws.region=$awsRegion --set env.aws.accesskeyid=$accesskeyId --set env.aws.accesskey=$accessKey --set env.aws.sessionToken=$sessionToken --set env.aws.kinesisregion=$kinesisRegion --set env.storage.home=$storage --set serviceaccount.enabled=$serviceAccountEnable --set serviceaccount.name=$serviceAccountName --set env.kinesis.requesttimeout=$requesttimeout --set env.kinesis.maxrecords=$maxrecords --set env.kinesis.idleinterval=$idleinterval