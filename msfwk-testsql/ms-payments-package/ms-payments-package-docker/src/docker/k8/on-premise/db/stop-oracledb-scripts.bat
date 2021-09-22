@echo off
REM --------------------------------------------------------------
REM - Script to stop Payments Service
REM --------------------------------------------------------------

REM - Stop knative services

cd database/oracle


kubectl delete -f namespace.yaml

kubectl delete -f db-secrets.yaml

cd ../..