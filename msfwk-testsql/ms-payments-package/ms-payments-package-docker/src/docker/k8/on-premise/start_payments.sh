# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

cd ../..

./build.sh create --build

cd k8/on-premise/db

./start-sqldb-scripts.sh

cd ../


sleep 60


helm install svc ./svc -n payments --set env.database.host=paymentorder-db-service-np --set env.database.db_username=root --set env.database.db_password=password --set env.database.database_key=sql  --set env.database.database_name=payments --set env.database.driver_name=com.mysql.jdbc.Driver --set env.database.dialect=org.hibernate.dialect.MySQL5InnoDBDialect --set env.database.db_connection_url=jdbc:mysql://paymentorder-db-service:3306/payments

# docker-compose -f kafka.yml -f paymentorder-nuo.yml %*