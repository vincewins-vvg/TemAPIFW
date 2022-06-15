@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

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