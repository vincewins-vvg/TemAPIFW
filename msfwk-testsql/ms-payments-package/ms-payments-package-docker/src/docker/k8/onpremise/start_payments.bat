@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

REM Buildimageslocally

cd ../..

call build.bat build

cd k8/k8-local

REM - Start knative services
cd kubectl/100_db
kubectl apply -f 100_payments-create-namespace.yaml

cd ../110_svc
kubectl apply -f 001_payments-configmap.yaml 
kubectl apply -f 100_payments-api.yaml
kubectl apply -f 101_payments-ingester.yaml

cd ../120_kafka
kubectl apply -f kafka-topics.yaml
kubectl apply -f schema-registry.yaml
REM kubectl apply -f 110_payments-kafka-source.yaml
REM kubectl apply -f 120_strimzi.yaml

cd ../130_scheduler
kubectl apply -f 100_scheduler-job.yaml

cd ../../