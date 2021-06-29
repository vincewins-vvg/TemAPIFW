#
# --------------------------------------------------------------
# - Script to start paymentorder Service
# --------------------------------------------------------------


cd helm-chart

kubectl create namespace postgresqlpaymentorder

helm install dbinit ./dbinit -n postgresqlpaymentorder

sleep 90

kubectl create namespace paymentorder

helm install paymentorder ./svc -n paymentorder --set env.database.DATABASE_KEY=postgresql --set env.database.MONGODB_DBNAME=ms_paymentorder --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb 


cd ../