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
REM Default Value : http://localhost:8180/auth/realms/msf
SET Jwt_Token_Issuer=http://localhost:8180/auth/realms/msf
REM Name : Jwt_Token_Principal_Claim
REM Description : Indicates the claim in which the user principal is provided.
REM Default Value : msuser
SET Jwt_Token_Principal_Claim=msuser
REM Name : Id_Token_Signed
REM Description : Enables the JWT signature validation along with the header and payload
REM Default Value : true
SET Id_Token_Signed=true
REM Default Value : true
SET ENABLE_AUDIT=true
REM Name : ENABLE_AUDIT_FOR_GET_API
REM Description : Capture audit logs for get APIs.
REM Default Value : true
SET ENABLE_AUDIT_FOR_GET_API=true
REM Name : ENABLE_AUDIT_TO_CAPTURE_RESPONSE
REM Description : Capture response in the audit logs.
REM Default Value : true
SET ENABLE_AUDIT_TO_CAPTURE_RESPONSE=true
REM Name : Jwt_Token_Public_Key_Cert_Encoded
REM Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
SET wt_Token_Public_Key_Cert_Encoded="MIIClTCCAX0CBgF+041vlTANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANtc2YwHhcNMjIwMjA3MDkzNzQ4WhcNMzIwMjA3MDkzOTI4WjAOMQwwCgYDVQQDDANtc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCCjlPW4lBYzOF05r5NlXaUSuL9KH23gNUFDISZDgmowdi8EkapXT822UDD6OoG83Y6ql+pZa1BjuNV8p64AMs64hnCXmwAuL1H/xbBTbLwvhVwBvfWAxSvuZ3sJbAYANo0T21pLuiknH2d9egPiYxil9xGbhH1IxVXZpUwvEVE2awvIiBCZit1OwlvXGMzf9Vj0hemI7hdH7xZHa3OWHHUle3ncrA0OsuUhxsdvb+P6xoKZHbhNkD+4MmJrZToAefr+TzfP9Y77j82DYaik7UHEVRdg0MXNr9oRSZ5RU53jOwSJHQgdRuxFgZM/Mj4IE/lNnyt+UevLgViNUx3SjO5AgMBAAEwDQYJKoZIhvcNAQELBQADggEBADpNxerAa4Q8gfo7gMINJLhYGrDwKD2YWuB4NfRyEXbcwJOxGGn4ViNc0yCJEHI0J0pbcAcEvYTYTdCpZVMqJ6bX8bm/bWBDuwlDemLyzV66rw/SEl4aML2yc06bGWn1+v93YHz/lLVLIK8JYPUhYWo+T9DkAZ45cP9wCIu/6/krvj91fcQMlGt8ZVRgbCzZLjq9Zrv34jTXStQU9+Qrbrq4zTfk+grVtC6iWKVRaSXC/2sIp6dTdmf+4VdmMrcHBdfh4xHAtTeiGk2AU7D7AzDJ0R1PLe8K0O7zae418Vfoa5MWZOgRMW3nyX5qCXmhemS8qLMN2B5Mks8yIM9I7aU="
REM Name : Jwt_Token_Public_Key
REM Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
SET Jwt_Token_Public_Key=""

cd ../..

call build-mssql.bat build

cd k8/on-premise/db

call start-mssql-db-scripts.bat

timeout 60 /nobreak > nul

cd ../

SET dbinit_Connection_Url="jdbc:sqlserver://paymentorder-db-service.payments.svc.cluster.local:1433;databaseName=payments"

SET APP_INIT_IMAGE="temenos/ms-paymentorder-appinit"

SET tag=DEV

kubectl create namespace posqlappinit

helm install posqlappinit ./appinit -n posqlappinit --set env.sqlinit.databaseKey=sql --set env.sqlinit.databaseName=payments --set env.sqlinit.dbusername=sa --set env.sqlinit.dbpassword=Rootroot@12345 --set image.tag=%tag% --set image.sqlinit.repository=%APP_INIT_IMAGE% --set env.sqlinit.dbconnectionurl=%dbinit_Connection_Url% --set env.sqlinit.dbautoupgrade="N" --set env.sqlinit.dbdialect=org.hibernate.dialect.SQLServer2012Dialect --set env.sqlinit.dbdriver=com.microsoft.sqlserver.jdbc.SQLServerDriver

helm install payments ./svc -n payments --set env.database.host=paymentorder-db-service --set env.database.db_username=sa --set env.database.db_password=Rootroot@12345 --set env.database.DATABASE_KEY=sql  --set env.database.database_name=payments --set env.database.driver_name=com.microsoft.sqlserver.jdbc.SQLServerDriver --set env.database.dialect=org.hibernate.dialect.SQLServer2012Dialect --set env.database.db_connection_url=jdbc:sqlserver://paymentorder-db-service:1433;databaseName=payments --set pit.JWT_TOKEN_ISSUER=%Jwt_Token_Issuer% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%Jwt_Token_Principal_Claim% --set pit.ID_TOKEN_SIGNED=%Id_Token_Signed% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%Jwt_Token_Public_Key_Cert_Encoded% --set pit.JWT_TOKEN_PUBLIC_KEY=%Jwt_Token_Public_Key% --set audit.ENABLE_AUDIT=%ENABLE_AUDIT% --set audit.ENABLE_AUDIT_FOR_GET_API=%ENABLE_AUDIT_FOR_GET_API% --set audit.ENABLE_AUDIT_TO_CAPTURE_RESPONSE=%ENABLE_AUDIT_TO_CAPTURE_RESPONSE%


cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f payments-nodeport.yaml -n payments 

cd ../..
