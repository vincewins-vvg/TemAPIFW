export JWT_TOKEN_ISSUER=https://localhost:9443/oauth2/token
export JWT_TOKEN_PRINCIPAL_CLAIM=sub
export ID_TOKEN_SIGNED=true
export JWT_TOKEN_PUBLIC_KEY="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
export JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=""


# UNCOMMENT THE BELOW LINES TO ENABLE KEYCLOAK
# export JWT_TOKEN_ISSUER=http://localhost:8180/auth/realms/msf
# export JWT_TOKEN_PRINCIPAL_CLAIM=msuser
# export ID_TOKEN_SIGNED=false
# export JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED="MIIClTCCAX0CBgF6etFgtDANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANNc2YwHhcNMjEwNzA2MDc1NDQwWhcNMzEwNzA2MDc1NjIwWjAOMQwwCgYDVQQDDANNc2YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZKa8cuSEo8cf6pYC549K2Pcpu20b173iNhgdkhV/1XLW0YktMgnxySKrcCmDbqQJDhK5FWuXN1El8UkxABibqFt8riwesglCYUspNmAszkicZAEQ/X+pu89tAXQOdg8U5kU4ZK4hzOS5D0n8ZzW2TaWCsQDoH3ng0UWGPWA7LTv+zb8f2U+SK6rkP3tkfEZVEhqUrddOeiKGFa6we4mwLPT5ZczBoVRrfpwKBL6i1JDDrWpeCZRrUjm7SFem3lLQMyF6sRQVIPLONWl7AG4ZRv7Akicag7tUeMzbIO7jRAJasrK/40e54YJ4lnVRMUXq7powEFZFigcSLSMUKrZWxAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAe9jK84bas1c+W0Ee4JfHaRPxa1x/Y+lmuWXc1kzFBRptzmQsOJXon6v1VHGTbnvpPnO8wNaxfU0iqPm4RO+LoZyxbGQpyFXYFD+fPZdK2a78oVpfi71g1aS4qjjBIPK1ERZSWalCGdaNxkjG5+wXquAo18tFbacDX41shN6CxHux8bvT9NbWlsjKj6gFhpCbN7oKsafLgTQ2+mqcQO1bQxObHj3o/LiuvIWhIyakz9SmFvh0wgAXhkVoiPvoP5LXMNdbaSv49LIt7wOMZHkbtkFWMTqKRBq32NSSKi0670Tv4IDm2I1cKVWLVy0RXSOc6CXR99G2z2PC6aPQjsXvc="
# export JWT_TOKEN_PUBLIC_KEY=""



kubectl create namespace dbinitpayments

kubectl create namespace payments

kubectl create namespace appinitpayments

cd helm-chart

helm install dbinit ./dbinit -n dbinitpayments --set env.sqlinit.databaseKey=sql --set env.sqlinit.databaseName=payments --set env.sqlinit.dbdialect=org.hibernate.dialect.SQLServer2012Dialect --set env.sqlinit.dbusername=sa --set env.sqlinit.dbpassword=Rootroot@12345 --set env.sqlinit.dbconnectionurl=jdbc:sqlserver://paymentorder-db-service.payments.svc.cluster.local:1433

helm install appinit ./appinit -n appinitpayments --set env.sqlinit.databaseKey=sql --set env.sqlinit.databaseName=payments --set env.sqlinit.dbdialect=com.microsoft.sqlserver.jdbc.SQLServerDriver --set env.sqlinit.dbusername=sa --set env.sqlinit.dbpassword=Rootroot@12345 --set env.sqlinit.dbconnectionurl=jdbc:sqlserver://paymentorder-db-service.payments.svc.cluster.local:1433 --set env.sqlinit.msversion=DEV.0.0-SNAPSHOT --set env.sqlinit.migration=path:database/install/ --set env.sqlinit.dbdriver=com.mysql.jdbc.Driver

helm install payments ./svc -n payments --set env.database.host=paymentorder-db-service --set env.database.db_username=sa --set env.database.db_password=Rootroot@12345 --set env.database.database_key=sql  --set env.database.database_name=payments --set env.database.driver_name=com.microsoft.sqlserver.jdbc.SQLServerDriver --set env.database.dialect=org.hibernate.dialect.SQLServer2012Dialect --set env.database.db_connection_url=jdbc:sqlserver://paymentorder-db-service:1433;databaseName=payments --set pit.JWT_TOKEN_ISSUER=$JWT_TOKEN_ISSUER --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$JWT_TOKEN_PRINCIPAL_CLAIM --set pit.ID_TOKEN_SIGNED=$ID_TOKEN_SIGNED --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED --set pit.JWT_TOKEN_PUBLIC_KEY=$JWT_TOKEN_PUBLIC_KEY 

cd ../