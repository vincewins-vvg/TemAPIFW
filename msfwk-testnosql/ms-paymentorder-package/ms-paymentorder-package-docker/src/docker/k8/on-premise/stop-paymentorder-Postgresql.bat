@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to stop Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images


helm uninstall ponosql

kubectl delete namespace paymentorder


cd db

call stop-postgresqldb-scripts.bat

cd ../

cd streams/kafka

kubectl delete -f kafka-topics.yaml

kubectl delete -f schema-registry.yaml

cd ../..