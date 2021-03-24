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