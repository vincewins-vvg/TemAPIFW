# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

export JWT_TOKEN_ISSUER=http://localhost:8180/auth/realms/msf
export JWT_TOKEN_PRINCIPAL_CLAIM=msuser
export ID_TOKEN_SIGNED=true
export JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED="MIIClTCCAX0CBgF6etFgtDANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANNc2YwHhcNMjEwNzA2MDc1NDQwWhcNMzEwNzA2MDc1NjIwWjAOMQwwCgYDVQQDDANNc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZKa8cuSEo8cf6pYC549K2Pcpu20b173iNhgdkhV/1XLW0YktMgnxySKrcCmDbqQJDhK5FWuXN1El8UkxABibqFt8riwesglCYUspNmAszkicZAEQ/X+pu89tAXQOdg8U5kU4ZK4hzOS5D0n8ZzW2TaWCsQDoH3ng0UWGPWA7LTv+zb8f2U+SK6rkP3tkfEZVEhqUrddOeiKGFa6we4mwLPT5ZczBoVRrfpwKBL6i1JDDrWpeCZRrUjm7SFem3lLQMyF6sRQVIPLONWl7AG4ZRv7Akicag7tUeMzbIO7jRAJasrK/40e54YJ4lnVRMUXq7powEFZFigcSLSMUKrZWxAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAe9jK84bas1c+W0Ee4JfHaRPxa1x/Y+lmuWXc1kzFBRptzmQsOJXon6v1VHGTbnvpPnO8wNaxfU0iqPm4RO+LoZyxbGQpyFXYFD+fPZdK2a78oVpfi71g1aS4qjjBIPK1ERZSWalCGdaNxkjG5+wXquAo18tFbacDX41shN6CxHux8bvT9NbWlsjKj6gFhpCbN7oKsafLgTQ2+mqcQO1bQxObHj3o/LiuvIWhIyakz9SmFvh0wgAXhkVoiPvoP5LXMNdbaSv49LIt7wOMZHkbtkFWMTqKRBq32NSSKi0670Tv4IDm2I1cKVWLVy0RXSOc6CXR99G2z2PC6aPQjsXvc="
export JWT_TOKEN_PUBLIC_KEY=""

cd ../..

./build-mssql.sh build

cd k8/on-premise/db

./start-mssql-db-scripts.sh

cd ../

sleep 60

kubectl create namespace payments

helm install payments ./svc -n payments --set env.database.host=paymentorder-db-service --set env.database.db_username=sa --set env.database.db_password=Rootroot@12345 --set env.database.DATABASE_KEY=sql  --set env.database.database_name=payments --set env.database.driver_name=com.microsoft.sqlserver.jdbc.SQLServerDriver --set env.database.dialect=org.hibernate.dialect.SQLServer2012Dialect --set env.database.db_connection_url=jdbc:sqlserver://paymentorder-db-service:1433;databaseName=payments --set pit.JWT_TOKEN_ISSUER=$JWT_TOKEN_ISSUER --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$JWT_TOKEN_PRINCIPAL_CLAIM --set pit.ID_TOKEN_SIGNED=$ID_TOKEN_SIGNED --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED --set pit.JWT_TOKEN_PUBLIC_KEY=$JWT_TOKEN_PUBLIC_KEY 

cd streams/kafka

kubectl apply -f kafka-topics.yaml

kubectl apply -f schema-registry.yaml

cd ../..

cd samples/external

kubectl apply -f payments-nodeport.yaml -n payments 

cd ../..