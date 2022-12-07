#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------
#  Name				: db_Connection_Url
#  Description		: The general form of the connection URL is
#   ex.  oracle:          jdbc:oracle:thin:@<host_or_ip>:1521:<db_name>
#   ex.  db2:             jdbc:db2://<host_or_ip>:50000/<db_name>
#   ex.  ms-sql:          jdbc:sqlserver://<host_or_ip>:1433;databaseName=<db_name>
#   ex.  mongodb:         mongodb://[username:password@]host1[:port1][,...hostN[:portN]][/[defaultauthdb][?options]]

#  We are using mongodb by default 
#  The general form of the connection URL for shared cluster is
#     mongodb://<hostname>:<port>,<hostname>:<port>
#      mongodb://mongos0.example.com:27017,mongos1.example.com:27017,mongos2.example.com:27017


# mongodb:// -- A required prefix to identify that this is a string in the standard connection format.
    
#  host[:port] -- The host (and optional port number) where mongos instance for a sharded cluster is running. You can specify a hostname, IP address, or UNIX domain socket. Specify as many hosts as appropriate for your deployment topology.If the port number is not specified, the default port 27017 is used.

export db_Connection_Url=mongodb+srv://badri0307:badri0307@mongodb01.qjebf.azure.mongodb.net
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
# Name : Jwt_Token_Public_Key_Cert_Encoded
# Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
export Jwt_Token_Public_Key_Cert_Encoded="MIIClTCCAX0CBgF+041vlTANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANtc2YwHhcNMjIwMjA3MDkzNzQ4WhcNMzIwMjA3MDkzOTI4WjAOMQwwCgYDVQQDDANtc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCCjlPW4lBYzOF05r5NlXaUSuL9KH23gNUFDISZDgmowdi8EkapXT822UDD6OoG83Y6ql+pZa1BjuNV8p64AMs64hnCXmwAuL1H/xbBTbLwvhVwBvfWAxSvuZ3sJbAYANo0T21pLuiknH2d9egPiYxil9xGbhH1IxVXZpUwvEVE2awvIiBCZit1OwlvXGMzf9Vj0hemI7hdH7xZHa3OWHHUle3ncrA0OsuUhxsdvb+P6xoKZHbhNkD+4MmJrZToAefr+TzfP9Y77j82DYaik7UHEVRdg0MXNr9oRSZ5RU53jOwSJHQgdRuxFgZM/Mj4IE/lNnyt+UevLgViNUx3SjO5AgMBAAEwDQYJKoZIhvcNAQELBQADggEBADpNxerAa4Q8gfo7gMINJLhYGrDwKD2YWuB4NfRyEXbcwJOxGGn4ViNc0yCJEHI0J0pbcAcEvYTYTdCpZVMqJ6bX8bm/bWBDuwlDemLyzV66rw/SEl4aML2yc06bGWn1+v93YHz/lLVLIK8JYPUhYWo+T9DkAZ45cP9wCIu/6/krvj91fcQMlGt8ZVRgbCzZLjq9Zrv34jTXStQU9+Qrbrq4zTfk+grVtC6iWKVRaSXC/2sIp6dTdmf+4VdmMrcHBdfh4xHAtTeiGk2AU7D7AzDJ0R1PLe8K0O7zae418Vfoa5MWZOgRMW3nyX5qCXmhemS8qLMN2B5Mks8yIM9I7aU="

# Name : Jwt_Token_Public_Key
# Description : Indicates Base64 encoded public key content that can be directly loaded as a public key certificate.
export Jwt_Token_Public_Key=""

# Name             : Audit 
# Description      : To capture system events for query 
export query_enable_system_events="false"

export query_enable_response="false"

cd ../..

./build.sh build

cd k8/on-premise/db

./start-sqldb-scripts.sh

cd ../


sleep 60

export dbinit_Connection_Url="jdbc:mysql://paymentorder-db-service.payments.svc.cluster.local:3306/payments"

export APP_INIT_IMAGE="temenos/ms-paymentorder-appinit"

export tag=DEV

kubectl create namespace posqlappinit

helm install posqlappinit ./appinit -n posqlappinit --set env.sqlinit.databaseKey=sql --set env.sqlinit.databaseName=payments --set env.sqlinit.dbusername=root --set env.sqlinit.dbpassword=password --set image.tag=$tag --set image.sqlinit.repository=$APP_INIT_IMAGE --set env.sqlinit.dbconnectionurl=$dbinit_Connection_Url --set env.sqlinit.dbautoupgrade="N" --set env.sqlinit.dbdialect=org.hibernate.dialect.MySQL5InnoDBDialect --set env.sqlinit.dbdriver=com.mysql.jdbc.Driver

helm install svc ./svc -n payments --set env.database.host=paymentorder-db-service-np --set env.database.db_username=root --set env.database.db_password=password --set env.database.database_key=sql --set env.database.database_name=payments --set env.database.driver_name=com.mysql.jdbc.Driver --set env.database.dialect=org.hibernate.dialect.MySQL5InnoDBDialect --set env.database.db_connection_url=jdbc:mysql://paymentorder-db-service:3306/payments --set pit.JWT_TOKEN_ISSUER=$Jwt_Token_Issuer --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$Jwt_Token_Principal_Claim --set pit.ID_TOKEN_SIGNED=$Id_Token_Signed --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$Jwt_Token_Public_Key_Cert_Encoded --set pit.JWT_TOKEN_PUBLIC_KEY=$Jwt_Token_Public_Key --set env.audit.query_enable_system_events=$query_enable_system_events$ --set env.audit.query_enable_response=$query_enable_response$

# docker-compose -f kafka.yml -f paymentorder-nuo.yml %*

cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f payments-nodeport.yaml -n payments 

cd ../..