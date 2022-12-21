#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

#@echo off
#REM --------------------------------------------------------------

#REM - Script to start paymentorder Service
#REM --------------------------------------------------------------

# -------------------------------------------------------------
# 
# Database properties
#
# --------------------------------------------------------------

# Name 				: database_Key
# Description 		: specify the name of the database server.
# Possible values 	:  mongodb | postgresql
# Default Value   	: postgresql
export database_Key=postgresql
# Name				: database_Name
# Description		: Specify the name of the database used in mongodb.
# Default value   	: ms_paymentorder
export database_Name=ms_paymentorder
# Name			 : db_Username
# Description    : To interact with a database, you generally first need to connect to the server. You supply a username (uid) for a server login.
# Default Value	 : paymentorderusr
export db_Username="paymentorderusr"
# Name			 : db_password
# Description    : To interact with a database, you generally first need to connect to the server. You supply a password that match a server login.
# Default Value	 : paymentorderpass
export db_Password="paymentorderpass"

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

# -------------------------------------------------------------
# 
# IMAGE PROPERTIES
#
# --------------------------------------------------------------

# IMAGE PROPERTIES
cd ../
export releaseVersion=$(<version.txt)
echo "Version : " $releaseVersion
cd upgrade
#Name				: tag
#Description		: Specifies the release version of the image
export tag=$releaseVersion
# Name			: apiImage,ingesterImage,inboxoutboxImage,dbinitImage
# Description 	: Specifies the name of Images for api ,ingester,inboxoutbox, dbinit that are  pushed to external repositories,
# Example			: Consider our external repository is "acr.azurecr.io" and tag is the releaseVersion. It should be like acr.azurecr.io/temenos/ms-paymentorder-service:%releaseVersion%
export apiImage=dev.local/temenos/ms-paymentorder-service
export ingesterImage=dev.local/temenos/ms-paymentorder-ingester
export inboxoutboxImage=dev.local/temenos/ms-paymentorder-inboxoutbox
export schedulerImage=dev.local/temenos/ms-paymentorder-scheduler
export fileingesterImage=dev.local/temenos/ms-paymentorder-fileingester
export schemaregistryImage=confluentinc/cp-schema-registry
# Name				: env_Name
# Description		: specifies the environment name which will be added as a respective pod prefix.
export env_Name=""
# Name				: ImagePullSecret,dbinit_Image_Pull_Secret
# Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htm#:~:text=To%20create%20a%20Docker%20registry%20secret%3A. adapter_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
export ImagePullSecret=""
export dbinit_Image_Pull_Secret=""

# Name 			: rolling_Update
# Description     : Rolling updates allow Deployments' update to take place with zero downtime by incrementally updating Pods instances with new ones
# Default Value   : false
# Possible Value  : true | false
export rolling_Update="false"
# Name 			: api_MaxSurge
# Description		: Specifies the maximum number of pods that can be created over the desired number of pods.
# Default Value 	: 1
export api_MaxSurge="1"
# Name 			: api_MaxUnavailable
# Description		: the maximum number of pods that can be unavailable during the update process. 
# Default Value 	: 0
export api_MaxUnavailable="0"


# Name 			: ingester_MaxSurge
# Description		: Specifies the maximum number of pods that can be created over the desired number of pods in ingester.
# Default Value 	: 1
export ingester_MaxSurge="1"
# Name 			: ingester_MaxUnavailable
# Description		: the maximum number of pods that can be unavailable during the update process in ingester. 
# Default Value 	: 0
export ingester_MaxUnavailable="0"


# Name			: ip_Config
# Description 	: Specifies the ip of the host machine where configuration MS runs
# Example			: "10.92.27.159"
export ip_Config="10.92.27.159"

# Name			: gc_Base_Path
# Description 	: Specifies the base URL of configuration MS
# Example			: "http://10.92.27.159:30023/ms-genericconfig-api/api/v2.0.0/"
export gc_Base_Path="http://"$ip_Config":30023/ms-genericconfig-api/api/v2.0.0/"

# Name : Jwt_Token_Issuer
# Description : Identifies the issuer of the authentication token.
# Default Value : https://localhost:9443/oauth2/token
export Jwt_Token_Issuer=https://localhost:9443/oauth2/token
# Name : Jwt_Token_Principal_Claim
# Description : Indicates the claim in which the user principal is provided.
# Default Value : sub
# Jwt_Token_Principal_Claim=sub
# Name : Id_Token_Signed
# Description : Enables the JWT signature validation along with the header and payload
# Default Value : true
export Id_Token_Signed=true
# Name : Jwt_Token_Public_Key
# Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
export Jwt_Token_Public_Key="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
# Name : Jwt_Token_Public_Key_Cert_Encoded
# Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate
export Jwt_Token_Public_Key_Cert_Encoded=""
# Name : ms_security_tokencheck_enabled
# Description : Indicates if JWT token is enabled
export ms_security_tokencheck_enabled="N"


cd ../helm-chart


helm upgrade paymentorder ./svc -n paymentorder --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb --set env.database.MONGODB_DBNAME=$database_Name --set env.database.DATABASE_KEY=$database_Key --set image.paymentorderapi.repository=$apiImage --set image.paymentorderingester.repository=$ingesterImage --set image.paymentorderscheduler.repository=$schedulerImage --set image.paymentorderinboxoutbox.repository=$inboxoutboxImage --set image.fileingester.repository=$fileingesterImage --set image.schemaregistry.repository=$schemaregistryImage --set imagePullSecrets=$ImagePullSecret --set image.tag=$tag --set env.genericconfig.basepath=$gc_Base_Path --set env.kafka.kafkabootstrapservers=$kafka_Bootstrap_Servers --set env.name=$env_Name --set rollingupdate.enabled=$rollingUpdate --set rollingupdate.enabled=$rolling_Update --set rollingupdate.api.maxsurge=$api_MaxSurge --set rollingupdate.api.maxunavailable=$api_MaxUnavailable --set rollingupdate.ingester.maxsurge=$ingester_MaxSurge --set rollingupdate.ingester.maxunavailable=$ingester_MaxUnavailable --set pit.JWT_TOKEN_ISSUER=$Jwt_Token_Issuer --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$Jwt_Token_Principal_Claim --set pit.ID_TOKEN_SIGNED=$Id_Token_Signed --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$Jwt_Token_Public_Key_Cert_Encoded --set pit.JWT_TOKEN_PUBLIC_KEY=$Jwt_Token_Public_Key --set pit.ms_security_tokencheck_enabled=$ms_security_tokencheck_enabled --set env.database.POSTGRESQL_USERNAME=$db_Username --set env.database.POSTGRESQL_PASSWORD=$db_Password

cd upgrade