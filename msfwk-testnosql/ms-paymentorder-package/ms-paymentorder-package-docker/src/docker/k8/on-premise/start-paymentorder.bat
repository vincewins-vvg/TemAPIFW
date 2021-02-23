@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images

SET DB_NAME=ms_paymentorder 
SET MONGODB_CONNECTIONSTR=mongodb://mongodb-0.mongodb-svc.mongodb.svc.cluster.local:27017,mongodb-1.mongodb-svc.mongodb.svc.cluster.local:27017,mongodb-2.mongodb-svc.mongodb.svc.cluster.local:27017

cd ../..

call build.bat build

cd k8/on-premise/db

call start-podb-scripts.bat

cd ../

helm install ponosql ./svc --set env.database.MONGODB_CONNECTIONSTR=%MONGODB_CONNECTIONSTR% --set env.database.MONGODB_DBNAME=%DB_NAME%

