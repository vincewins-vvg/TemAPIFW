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

cd database/postgresql

kubectl delete -f postgresql-db.yaml

kubectl delete -f namespace.yaml

kubectl delete -f db-secrets.yaml

cd ../..