#@echo off
#REM --------------------------------------------------------------
#REM - Script to start Paymentorder Service
#REM --------------------------------------------------------------

#REM - Build paymentorder images

export DB_NAME=ms_paymentorder
export MONGODB_CONNECTIONSTR=mongodb+srv://badri0307:badri0307@mongodb01.qjebf.azure.mongodb.net


cd ../..

./build.sh create --build

cd k8/on-premise/db

./start-postgresqldb-scripts.sh

cd ../

cd k8/on-premise/

helm install ponosql ./svc --set env.database.MONGODB_CONNECTIONSTR=$MONGODB_CONNECTIONSTR --set env.database.MONGODB_DBNAME=$DB_NAME --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://po-postgresqldb-service.postgresql.svc.cluster.local:5432/paymentorderdb --set env.database.DATABASE_KEY=postgresql