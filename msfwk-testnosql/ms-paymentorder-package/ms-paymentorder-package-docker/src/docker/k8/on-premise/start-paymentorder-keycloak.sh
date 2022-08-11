#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start Paymentorder Service
# --------------------------------------------------------------

# - Build paymentorder images

# Name : Jwt_Token_Issuer
# Description : Identifies the issuer of the authentication token.
# Default Value : http://localhost:8180/auth/realms/msf
export Jwt_Token_Issuer=http://localhost:8180/auth/realms/msf
# Name : Jwt_Token_Principal_Claim
# Description : Indicates the claim in which the user principal is provided.
# Default Value : msuser
export Jwt_Token_Principal_Claim=msuser
# Name : Id_Token_Signed
# Description : Enables the JWT signature validation along with the header and payload
# Default Value : true
export Id_Token_Signed=true
# Name : ENABLE_AUDIT
# Description : Enable the audit log feature.
# Default Value : true
export ENABLE_AUDIT=true
# Name : ENABLE_AUDIT_FOR_GET_API
# Description : Capture audit logs for get APIs.
# Default Value : true
export ENABLE_AUDIT_FOR_GET_API=true
# Name : ENABLE_AUDIT_TO_CAPTURE_RESPONSE
# Description : Capture response in the audit logs.
# Default Value : true
export ENABLE_AUDIT_TO_CAPTURE_RESPONSE=true
# Name : Jwt_Token_Public_Key_Cert_Encoded
# Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
export Jwt_Token_Public_Key_Cert_Encoded="MIIClTCCAX0CBgF+041vlTANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANtc2YwHhcNMjIwMjA3MDkzNzQ4WhcNMzIwMjA3MDkzOTI4WjAOMQwwCgYDVQQDDANtc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCCjlPW4lBYzOF05r5NlXaUSuL9KH23gNUFDISZDgmowdi8EkapXT822UDD6OoG83Y6ql+pZa1BjuNV8p64AMs64hnCXmwAuL1H/xbBTbLwvhVwBvfWAxSvuZ3sJbAYANo0T21pLuiknH2d9egPiYxil9xGbhH1IxVXZpUwvEVE2awvIiBCZit1OwlvXGMzf9Vj0hemI7hdH7xZHa3OWHHUle3ncrA0OsuUhxsdvb+P6xoKZHbhNkD+4MmJrZToAefr+TzfP9Y77j82DYaik7UHEVRdg0MXNr9oRSZ5RU53jOwSJHQgdRuxFgZM/Mj4IE/lNnyt+UevLgViNUx3SjO5AgMBAAEwDQYJKoZIhvcNAQELBQADggEBADpNxerAa4Q8gfo7gMINJLhYGrDwKD2YWuB4NfRyEXbcwJOxGGn4ViNc0yCJEHI0J0pbcAcEvYTYTdCpZVMqJ6bX8bm/bWBDuwlDemLyzV66rw/SEl4aML2yc06bGWn1+v93YHz/lLVLIK8JYPUhYWo+T9DkAZ45cP9wCIu/6/krvj91fcQMlGt8ZVRgbCzZLjq9Zrv34jTXStQU9+Qrbrq4zTfk+grVtC6iWKVRaSXC/2sIp6dTdmf+4VdmMrcHBdfh4xHAtTeiGk2AU7D7AzDJ0R1PLe8K0O7zae418Vfoa5MWZOgRMW3nyX5qCXmhemS8qLMN2B5Mks8yIM9I7aU="
# Name : Jwt_Token_Public_Key
# Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
export Jwt_Token_Public_Key=""
# Name			  : database_Name
# Description	  : Specify the name of the database used in sql server.
# Default value   : ms_paymentorder
export database_Name=ms_paymentorder
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

export db_Connection_Url="mongodb+srv://user01:user01@mongodb01.jx2tl.mongodb.net/test"

# Name             : eventDirectDelivery
# Description      : If the value is true. Framework will directly deliver the events to respective topics. It skip the <msf>-outbox topic. If the value is false. It will delivers the events to <msf>-outbox topic and event delivery service will delivers the events to respective topic.
export eventDirectDelivery=\"true\"

# -------------------------------------------------------------
# 
# IMAGE PROPERTIES
#
# --------------------------------------------------------------
#Name				: tag
#Description		: Specifies the release version of the image
export tag="DEV"
# Name			: dbinitImage
# Description 	: Specifies the name of Images for dbinitImage that are  pushed to external repositories,
#REM Example			: Consider our external repository is "acr.azurecr.io" and tag is "DEV". It should be like acr.azurecr.io/temenos/ms-paymentorder-service:DEV
export dbinitImage=dev.local/temenos/ms-paymentorder-dbscripts
# Name			: dbinit_Image_Pull_Secret
# Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htm#:~:text=To%20create%20a%20Docker%20registry%20secret%3A. adapter_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
export dbinit_Image_Pull_Secret=""

cd ../..

./build.sh build

cd k8/on-premise/db

#call start-podb-scripts.bat

# call start-opm.bat

# call start-mongo-operator.bat

cd ../

kubectl create ns poappinit

export APP_INIT_IMAGE="dev.local/temenos/ms-paymentorder-appinit"

helm install poappinit ./appinit -n poappinit --set env.appinit.databaseKey=mongodb --set env.appinit.databaseName=$database_Name --set image.appinit.repository=$APP_INIT_IMAGE --set image.tag=$tag --set env.appinit.dbConnectionUrl=\"${db_Connection_Url}\" --set env.appinit.dbautoupgrade="N"

kubectl create namespace paymentorder

helm install ponosql ./svc -n paymentorder --set env.database.MONGODB_CONNECTIONSTR=$db_Connection_Url --set env.database.MONGODB_DBNAME=$database_Name --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb --set env.database.DATABASE_KEY=mongodb --set pit.JWT_TOKEN_ISSUER=$Jwt_Token_Issuer --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$Jwt_Token_Principal_Claim --set pit.ID_TOKEN_SIGNED=$Id_Token_Signed --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$Jwt_Token_Public_Key_Cert_Encoded --set pit.JWT_TOKEN_PUBLIC_KEY=$Jwt_Token_Public_Key --set env.eventdelivery.outboxdirectdeliveryenabled=$eventDirectDelivery --set audit.ENABLE_AUDIT=$ENABLE_AUDIT --set audit.ENABLE_AUDIT_FOR_GET_API=$ENABLE_AUDIT_FOR_GET_API --set audit.ENABLE_AUDIT_TO_CAPTURE_RESPONSE=$ENABLE_AUDIT_TO_CAPTURE_RESPONSE



cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f paymentorder-api-nodeport.yaml -n paymentorder

cd ../..
