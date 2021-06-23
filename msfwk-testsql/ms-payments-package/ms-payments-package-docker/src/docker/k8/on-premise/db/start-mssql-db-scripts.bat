@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

cd database/mssql

kubectl apply -f namespace.yaml

kubectl apply -f mssql-db.yaml

kubectl apply -f mssql-db-secrets.yaml

cd ../..
