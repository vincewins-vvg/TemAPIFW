kubectl create namespace dbinitpayments

kubectl create namespace payments

cd helm-chart


helm install dbinit ./dbinit -n dbinitpayments --set env.sqlinit.databaseKey=sql --set env.sqlinit.databaseName=payments --set env.sqlinit.dbdialect=org.hibernate.dialect.SQLServer2012Dialect --set env.sqlinit.dbusername=sa --set env.sqlinit.dbpassword=Rootroot@12345 --set env.sqlinit.dbconnectionurl=jdbc:sqlserver://<IP>:30109


helm install payments ./svc -n payments --set env.database.host=paymentorder-db-service --set env.database.db_username=sa --set env.database.db_password=Rootroot@12345 --set env.database.database_key=sql  --set env.database.database_name=payments --set env.database.driver_name=com.microsoft.sqlserver.jdbc.SQLServerDriver --set env.database.dialect=org.hibernate.dialect.SQLServer2012Dialect --set env.database.db_connection_url=jdbc:sqlserver://paymentorder-db-service:1433;databaseName=payments

cd ../