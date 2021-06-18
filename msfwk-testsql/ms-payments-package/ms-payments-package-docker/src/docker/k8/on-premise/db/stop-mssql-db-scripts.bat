@echo off
REM --------------------------------------------------------------
REM - Script to stop Payments Service
REM --------------------------------------------------------------

REM - Stop knative services

cd database/mssql

kubectl delete -f mssql-db.yaml

kubectl delete -f namespace.yaml

kubectl delete -f mssql-db-secrets.yaml

cd ../..