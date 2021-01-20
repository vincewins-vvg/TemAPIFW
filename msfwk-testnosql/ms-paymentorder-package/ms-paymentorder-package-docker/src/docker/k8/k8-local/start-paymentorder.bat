@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images

cd ../..

call build.bat build

cd k8/k8-local

REM - Start knative services

cd kubectl/110_svc
REM cd kubectl/110_svc

kubectl apply -f 000_paymentorder-ns.yaml
timeout /t 30 >nul
kubectl apply -f 001_paymentorder-configmap.yaml
timeout /t 30 >nul
kubectl apply -f 100_paymentorder-api.yaml
timeout /t 30 >nul
kubectl apply -f 110_paymentorder-ingester.yaml

REM cd ../../..

timeout /t 30 >nul

cd ../120_kafka
kubectl apply -f kafka-topics.yaml
timeout /t 30 >nul
kubectl apply -f schema-registry.yaml

cd ../130_scheduler
kubectl apply -f 100_scheduler-job.yaml

cd ../../

