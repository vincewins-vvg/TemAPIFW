@echo off
REM --------------------------------------------------------------
REM - Script to stop Payments Service
REM --------------------------------------------------------------

REM - Stop knative services

cd kubectl/120_kafka
kubectl delete -f kafka-topics.yaml

cd ../130_scheduler
kubectl delete -f 100_scheduler-job.yaml

cd ../110_svc
kubectl delete -f 001_payments-configmap.yaml 
kubectl delete -f 100_payments-api.yaml
kubectl delete -f 101_payments-ingester.yaml

cd ../100_db
kubectl delete -f 100_payments-create-namespace.yaml

cd ../../