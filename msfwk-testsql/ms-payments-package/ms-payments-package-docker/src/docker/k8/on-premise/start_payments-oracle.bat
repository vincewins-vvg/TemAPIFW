@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

SET JWT_TOKEN_ISSUER=https://localhost:9443/oauth2/token
SET JWT_TOKEN_PRINCIPAL_CLAIM=sub
SET ID_TOKEN_SIGNED=true
SET JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
SET JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=""

cd ../..

call build-oracle.bat build

cd k8/on-premise/db

call start-oracledb-scripts.bat

cd ../

helm install svc ./svc -n payments --set env.database.host=host.docker.internal --set env.database.db_username=system --set env.database.db_password=Oracle_1 --set env.database.database_key=sql  --set env.database.database_name=payments --set env.database.driver_name=oracle.jdbc.OracleDriver --set env.database.dialect=org.hibernate.dialect.Oracle10gDialect --set env.database.db_connection_url=jdbc:oracle:thin:@host.docker.internal:1521:orcl --set pit.JWT_TOKEN_ISSUER=%JWT_TOKEN_ISSUER% --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=%JWT_TOKEN_PRINCIPAL_CLAIM% --set pit.ID_TOKEN_SIGNED=%ID_TOKEN_SIGNED% --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=%JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED% --set pit.JWT_TOKEN_PUBLIC_KEY=%JWT_TOKEN_PUBLIC_KEY%

REM docker-compose -f kafka.yml -f paymentorder-nuo.yml %*


cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..