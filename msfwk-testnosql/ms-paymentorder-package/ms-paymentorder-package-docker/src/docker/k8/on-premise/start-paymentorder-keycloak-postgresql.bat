@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images
REM Name			: database_Name
REM Description		: Specify the name of the database used in mongodb.
REM Default value   : ms_paymentorder
SET database_Name=ms_paymentorder 
REM Name : Jwt_Token_Issuer
REM Description : Identifies the issuer of the authentication token.
REM Default Value : https://localhost:9443/oauth2/token
SET Jwt_Token_Issuer=http://localhost:8180/auth/realms/msf
REM Name : Jwt_Token_Principal_Claim
REM Description : Indicates the claim in which the user principal is provided.
REM Default Value : sub
SET Jwt_Token_Principal_Claim=msuser
REM Name : Id_Token_Signed
REM Description : Enables the JWT signature validation along with the header and payload
REM Default Value : true
SET Id_Token_Signed=true
REM Name : Jwt_Token_Public_Key_Cert_Encoded
REM Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
SET Jwt_Token_Public_Key_Cert_Encoded="MIIClTCCAX0CBgF+041vlTANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANtc2YwHhcNMjIwMjA3MDkzNzQ4WhcNMzIwMjA3MDkzOTI4WjAOMQwwCgYDVQQDDANtc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCCjlPW4lBYzOF05r5NlXaUSuL9KH23gNUFDISZDgmowdi8EkapXT822UDD6OoG83Y6ql+pZa1BjuNV8p64AMs64hnCXmwAuL1H/xbBTbLwvhVwBvfWAxSvuZ3sJbAYANo0T21pLuiknH2d9egPiYxil9xGbhH1IxVXZpUwvEVE2awvIiBCZit1OwlvXGMzf9Vj0hemI7hdH7xZHa3OWHHUle3ncrA0OsuUhxsdvb+P6xoKZHbhNkD+4MmJrZToAefr+TzfP9Y77j82DYaik7UHEVRdg0MXNr9oRSZ5RU53jOwSJHQgdRuxFgZM/Mj4IE/lNnyt+UevLgViNUx3SjO5AgMBAAEwDQYJKoZIhvcNAQELBQADggEBADpNxerAa4Q8gfo7gMINJLhYGrDwKD2YWuB4NfRyEXbcwJOxGGn4ViNc0yCJEHI0J0pbcAcEvYTYTdCpZVMqJ6bX8bm/bWBDuwlDemLyzV66rw/SEl4aML2yc06bGWn1+v93YHz/lLVLIK8JYPUhYWo+T9DkAZ45cP9wCIu/6/krvj91fcQMlGt8ZVRgbCzZLjq9Zrv34jTXStQU9+Qrbrq4zTfk+grVtC6iWKVRaSXC/2sIp6dTdmf+4VdmMrcHBdfh4xHAtTeiGk2AU7D7AzDJ0R1PLe8K0O7zae418Vfoa5MWZOgRMW3nyX5qCXmhemS8qLMN2B5Mks8yIM9I7aU="
REM Name : Jwt_Token_Public_Key
REM Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate
SET Jwt_Token_Public_Key=""


REM -------------------------------------------------------------
REM 
REM IMAGE PROPERTIES
REM
REM --------------------------------------------------------------
REM Name			: tag
REM Description		: Specifies the release version of the image
SET tag="DEV"
REM Name			: dbinitImage
REM Description 	: Specifies the name of Images for dbinitImage that are  pushed to external repositories,
REM Example			: Consider our external repository is "acr.azurecr.io" and tag is "DEV". It should be like acr.azurecr.io/temenos/ms-paymentorder-service:DEV
SET dbinitImage=dev.local/temenos/ms-paymentorder-dbscripts
REM Name			: dbinit_Image_Pull_Secret
REM Description		: Docker registry secret contains the Oracle Cloud Infrastructure credentials to use when pulling the image. You have to specify the image to pull from Container Registry, including the repository location and the Docker registry secret to use, in the application's manifest file. To build docker registry secret,kindly use kubectl create secret docker-registry <secret-name> --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'. Refer https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrypullingimagesfromocir.htm#:~:text=To%20create%20a%20Docker%20registry%20secret%3A. adapter_Image_Pull_Secret and dbinit_Image_Pull_Secret Specifies the <secret-name> is a name of your choice, that you will use in the manifest file to refer to the secret.
SET dbinit_Image_Pull_Secret=""

cd ../..

call build.bat build

cd k8/on-premise/db

call start-podb-scripts.bat

REM call start-opm.bat

REM call start-mongo-operator.bat

cd ../

SET APP_INIT_IMAGE="dev.local/temenos/ms-paymentorder-appinit"

SET DB_UPGRADE_START_VERSION=""

SET db_Username="paymentorderusr"

SET db_Password="paymentorderpass"

SET db_Connection_Url="jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb"

helm install ponosql ./svc -n paymentorder --create-namespace -n paymentorder --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb  --set env.database.MONGODB_DBNAME=%database_Name% --set env.database.DATABASE_KEY=postgresql --set pit.JWT_TOKEN_ISSUER=%Jwt_Token_Issuer% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%Jwt_Token_Principal_Claim% --set pit.ID_TOKEN_SIGNED=%Id_Token_Signed% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%Jwt_Token_Public_Key_Cert_Encoded% --set pit.JWT_TOKEN_PUBLIC_KEY=%Jwt_Token_Public_Key% --set image.appinit.repository=%APP_INIT_IMAGE% --set env.appinit.dbUpgradeStartVersion=%DB_UPGRADE_START_VERSION% --set image.tag=%tag%


cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f paymentorder-api-nodeport.yaml -n paymentorder

cd ../..
