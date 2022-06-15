@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

call build.bat build

cd k8/payments/

helm install svc ./svc

cd ../../
REM docker-compose -f kafka.yml -f paymentorder-nuo.yml %*
