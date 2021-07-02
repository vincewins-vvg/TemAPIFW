kubectl create namespace dbinitpayments

kubectl create namespace payments

cd helm-chart


helm install dbinit ./dbinit -n dbinitpayments --set env.sqlinit.databaseKey=sql --set env.sqlinit.databaseName=payments --set env.sqlinit.dbdialect=org.hibernate.dialect.MySQL5InnoDBDialect --set env.sqlinit.dbusername=root --set env.sqlinit.dbpassword=password --set env.sqlinit.dbconnectionurl=jdbc:mysql://<IP>:30015


helm install svc ./svc -n payments --set env.database.host=paymentorder-db-service-np --set env.database.db_username=root --set env.database.db_password=password --set env.database.database_key=sql  --set env.database.database_name=payments --set env.database.driver_name=com.mysql.jdbc.Driver --set env.database.dialect=org.hibernate.dialect.MySQL5InnoDBDialect --set env.database.db_connection_url=jdbc:mysql://paymentorder-db-service:3306/payments

cd ../