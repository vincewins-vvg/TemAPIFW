@echo off
REM --------------------------------------------------------------
REM - Script to stop Payments Service
REM --------------------------------------------------------------

REM - Stop knative services


kubectl delete -f mysql-db.yaml

kubectl delete -f namespace.yaml

kubectl delete -f db-secrets.yaml
