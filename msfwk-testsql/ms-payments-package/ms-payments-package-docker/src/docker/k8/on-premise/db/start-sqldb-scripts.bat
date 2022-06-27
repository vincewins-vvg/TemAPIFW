@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

docker-compose -f paymentorder-sql.yml build

cd database/mysql

kubectl apply -f namespace.yaml

kubectl apply -f mysql-db.yaml

kubectl apply -f db-secrets.yaml

cd ../..