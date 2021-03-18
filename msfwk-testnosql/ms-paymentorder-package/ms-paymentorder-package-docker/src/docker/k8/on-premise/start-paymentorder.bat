@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images

SET DB_NAME=ms_paymentorder 

cd ../..

call build.bat build

cd k8/on-premise/db

call start-podb-scripts.bat

cd ../

helm install ponosql ./svc --set env.database.MONGODB_DBNAME=%DB_NAME%
