@echo off
REM --------------------------------------------------------------
REM - Script to stop Traceability Service
REM --------------------------------------------------------------

REM - Stop knative services

cd kubectl/120_kafka
kubectl delete -f kafka-topics.yaml

cd ../110_svc
kubectl delete -f 001_payments-configmap.yaml 
kubectl delete -f 100_payments-api.yaml
kubectl delete -f 101_payments-ingester.yaml

cd ../100_db
kubectl delete -f 101_mysql-db.yaml
kubectl delete -f 100_payments-create-namespace.yaml

cd ../../