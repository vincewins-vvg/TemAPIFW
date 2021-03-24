@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images
SET DB_NAME=ms_paymentorder 


cd ../..

call build-Postgresql.bat build

cd k8/on-premise/db
call start-postgresqldb-scripts.bat

cd ../

helm install ponosql ./svc --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb  --set env.database.MONGODB_DBNAME=%DB_NAME% --set env.database.DATABASE_KEY=postgresql