@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to stop Paymentorder Service
REM --------------------------------------------------------------

REM - Stop knative services

cd database/mongo/rs
kubectl delete -f mongo-setup.yaml
kubectl delete -f mongo_services.yaml
kubectl delete -f rs.yaml
cd ../operator
kubectl delete -f service_account.yaml
kubectl delete -f role.yaml
kubectl delete -f role_binding.yaml
kubectl delete -f operator.yaml
cd ../crd
kubectl delete -f mongo_crd.yaml
cd ../
kubectl delete -f create-mongo-ns.yaml


cd ../..