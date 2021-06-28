# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

cd ../..

./build-mssql.sh build

cd k8/on-premise/db

./start-mssql-db-scripts.sh

cd ../

sleep 60

kubectl create namespace payments

helm install payments ./svc -n payments --set env.database.host=paymentorder-db-service --set env.database.db_username=sa --set env.database.db_password=Rootroot@12345 --set env.database.DATABASE_KEY=sql  --set env.database.database_name=payments --set env.database.driver_name=com.microsoft.sqlserver.jdbc.SQLServerDriver --set env.database.dialect=org.hibernate.dialect.SQLServer2012Dialect --set env.database.db_connection_url=jdbc:sqlserver://paymentorder-db-service:1433;databaseName=payments 