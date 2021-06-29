@echo off
REM --------------------------------------------------------------
REM - Script to start paymentorder Service
REM --------------------------------------------------------------

cd helm-chart

kubectl create namespace postgresqlpaymentorder

helm install dbinit ./dbinit -n postgresqlpaymentorder

timeout /t 90 >nul

kubectl create namespace paymentorder

helm install paymentorder ./svc -n paymentorder --set env.database.DATABASE_KEY=postgresql --set env.database.MONGODB_DBNAME=ms_paymentorder --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://ent-postgresqldb-service.postgresql.svc.cluster.local:5432/ms_paymentorder 


cd ../