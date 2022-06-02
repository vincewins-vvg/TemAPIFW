@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images

SET DB_NAME=ms_paymentorder 
SET JWT_TOKEN_ISSUER=http://localhost:8180/auth/realms/msf
SET JWT_TOKEN_PRINCIPAL_CLAIM=msuser
SET ID_TOKEN_SIGNED=true
SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED="MIIClTCCAX0CBgF+041vlTANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANtc2YwHhcNMjIwMjA3MDkzNzQ4WhcNMzIwMjA3MDkzOTI4WjAOMQwwCgYDVQQDDANtc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCCjlPW4lBYzOF05r5NlXaUSuL9KH23gNUFDISZDgmowdi8EkapXT822UDD6OoG83Y6ql+pZa1BjuNV8p64AMs64hnCXmwAuL1H/xbBTbLwvhVwBvfWAxSvuZ3sJbAYANo0T21pLuiknH2d9egPiYxil9xGbhH1IxVXZpUwvEVE2awvIiBCZit1OwlvXGMzf9Vj0hemI7hdH7xZHa3OWHHUle3ncrA0OsuUhxsdvb+P6xoKZHbhNkD+4MmJrZToAefr+TzfP9Y77j82DYaik7UHEVRdg0MXNr9oRSZ5RU53jOwSJHQgdRuxFgZM/Mj4IE/lNnyt+UevLgViNUx3SjO5AgMBAAEwDQYJKoZIhvcNAQELBQADggEBADpNxerAa4Q8gfo7gMINJLhYGrDwKD2YWuB4NfRyEXbcwJOxGGn4ViNc0yCJEHI0J0pbcAcEvYTYTdCpZVMqJ6bX8bm/bWBDuwlDemLyzV66rw/SEl4aML2yc06bGWn1+v93YHz/lLVLIK8JYPUhYWo+T9DkAZ45cP9wCIu/6/krvj91fcQMlGt8ZVRgbCzZLjq9Zrv34jTXStQU9+Qrbrq4zTfk+grVtC6iWKVRaSXC/2sIp6dTdmf+4VdmMrcHBdfh4xHAtTeiGk2AU7D7AzDJ0R1PLe8K0O7zae418Vfoa5MWZOgRMW3nyX5qCXmhemS8qLMN2B5Mks8yIM9I7aU="
SET JWT_TOKEN_PUBLIC_KEY=""

SET tag="DEV"
SET dbinitImage=dev.local/temenos/ms-paymentorder-dbscripts
SET dbinitImagePullSecret=""



cd ../..

call build.bat build

cd k8/on-premise/db

call start-podb-scripts.bat

REM call start-opm.bat

REM call start-mongo-operator.bat

cd ../

kubectl create namespace postgresqlpaymentorder

helm install dbinit ./dbinit -n postgresqlpaymentorder --set image.mongoinit.repository=%dbinitImage% --set env.mongoinit.migration=../migration --set imagePullSecrets=%dbinitImagePullSecret% --set image.tag=%tag%

kubectl create namespace paymentorder

helm install ponosql ./svc --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb  --set env.database.MONGODB_DBNAME=%DB_NAME% --set env.database.DATABASE_KEY=postgresql --set pit.JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% --set pit.ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED% --set pit.JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY%


cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f paymentorder-api-nodeport.yaml -n paymentorder

cd ../..
