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

# Name			  : database_Name
# Description	  : Specify the name of the database used in sql server.
# Default value   : ms_paymentorder
export database_Name=ms_paymentorder
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

# Name             : eventDirectDelivery
# Description      : If the value is true. Framework will directly deliver the events to respective topics. It skip the <msf>-outbox topic. If the value is false. It will delivers the events to <msf>-outbox topic and event delivery service will delivers the events to respective topic.
export eventDirectDelivery=\"true\"

cd ../..

./build.sh build

cd k8/on-premise/db

./start-sqldb-scripts.sh

cd ../


sleep 60


helm install svc ./svc -n payments --set env.database.host=paymentorder-db-service-np --set env.database.db_username=root --set env.database.db_password=password --set env.database.database_key=sql  --set env.database.database_name=payments --set env.database.driver_name=com.mysql.jdbc.Driver --set env.database.dialect=org.hibernate.dialect.MySQL5InnoDBDialect --set env.database.db_connection_url=jdbc:mysql://paymentorder-db-service:3306/payments --set pit.JWT_TOKEN_ISSUER=$Jwt_Token_Issuer --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$Jwt_Token_Principal_Claim --set pit.ID_TOKEN_SIGNED=$Id_Token_Signed --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$Jwt_Token_Public_Key_Cert_Encoded --set pit.JWT_TOKEN_PUBLIC_KEY=$Jwt_Token_Public_Key --set env.eventdelivery.outboxdirectdeliveryenabled=$eventDirectDelivery

# docker-compose -f kafka.yml -f paymentorder-nuo.yml %*


cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f payments-nodeport.yaml -n payments 

cd ../..