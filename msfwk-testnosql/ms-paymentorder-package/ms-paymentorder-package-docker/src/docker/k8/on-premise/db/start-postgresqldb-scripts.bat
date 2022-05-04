@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

docker-compose -f paymentorderPostgresql.yml build

cd database/postgresql

kubectl apply -f namespace.yaml

kubectl apply -f postgresql-db.yaml

kubectl apply -f db-secrets.yaml

cd ../..