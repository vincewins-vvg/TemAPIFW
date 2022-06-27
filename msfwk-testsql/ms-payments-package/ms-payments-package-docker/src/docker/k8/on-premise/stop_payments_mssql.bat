@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

cd db/

call stop-mssql-db-scripts.bat

cd ../

helm delete payments -n payments

kubectl delete namespace payments


cd streams/kafka

kubectl delete -f kafka-topics.yaml

kubectl delete -f schema-registry.yaml

cd ../