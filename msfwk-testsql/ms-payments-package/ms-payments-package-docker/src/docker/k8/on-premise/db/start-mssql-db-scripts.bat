@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

docker-compose -f paymentorder-mssql.yml build

cd database/mssql

kubectl apply -f namespace.yaml

kubectl apply -f mssql-db.yaml

kubectl apply -f mssql-db-secrets.yaml

cd ../..
