#
# --------------------------------------------------------------
# - Script to start paymentorder Service
# --------------------------------------------------------------


cd helm-chart

kubectl create namespace mongopaymentorder

helm install dbinit ./dbinit -n mongopaymentorder

sleep 90

kubectl create namespace paymentorder

helm install paymentorder ./svc -n paymentorder --set env.database.DATABASE_KEY=mongodb --set env.database.MONGODB_DBNAME=ms_paymentorder --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://ent-postgresqldb-service.postgresql.svc.cluster.local:5432/ms_paymentorder 


cd ../