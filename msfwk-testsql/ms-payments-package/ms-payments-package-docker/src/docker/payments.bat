@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

REM Buildimageslocally

call build.bat build

REM - Start knative services
cd kubectl/100_db
kubectl apply -f 100_payments-create-namespace.yaml
kubectl apply -f 101_mysql-db.yaml

cd ../110_svc
kubectl apply -f 001_payments-configmap.yaml 
kubectl apply -f 100_payments-api.yaml
kubectl apply -f 101_payments-ingester.yaml

REM cd ../120_kafka
REM kubectl apply -f 100_payments-create-topics.yaml
REM kubectl apply -f 110_payments-kafka-source.yaml
REM kubectl apply -f 120_strimzi.yaml

REM cd ../130_scheduler
REM kubectl apply -f 130_scheduler.yaml
REM kubectl apply -f 131_scheduler_source.yaml

cd ../../