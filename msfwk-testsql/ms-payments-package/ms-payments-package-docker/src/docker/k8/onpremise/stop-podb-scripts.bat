@echo off
REM --------------------------------------------------------------
REM - Script to stop Payments Service
REM --------------------------------------------------------------

REM - Stop knative services

cd kubectl/100_db

kubectl delete -f 101_mysql-db.yaml


cd ../..