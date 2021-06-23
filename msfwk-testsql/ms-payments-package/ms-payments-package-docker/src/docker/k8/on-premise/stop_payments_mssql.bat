@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

cd db/

call stop-mssql-db-scripts.bat

cd ../

helm delete payments -n payments

kubectl delete namespace payments
