@echo off
REM --------------------------------------------------------------
REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images
call build.bat build

REM - Start knative services


cd kubectl/100_db/mongo
kubectl apply -f 100_create-mongo-ns.yaml
cd crd
kubectl apply -f 110_mongo_crd.yaml
cd ../operator
kubectl apply -f 120_operator.yaml
kubectl apply -f 130_rb.yaml
kubectl apply -f 140_role.yaml
kubectl apply -f 150_sa.yaml
cd ../rs
kubectl apply -f 160_rs.yaml
kubectl apply -f 170_mongo_services.yaml

timeout /t 60 >nul

cd ../../../110_svc
REM cd kubectl/110_svc

kubectl apply -f 000_paymentorder-ns.yaml
timeout /t 30 >nul
kubectl apply -f 001_paymentorder-configmap.yaml
timeout /t 30 >nul
kubectl apply -f 100_paymentorder-api.yaml
timeout /t 30 >nul
kubectl apply -f 110_paymentorder-ingester.yaml

REM cd ../../..

REM timeout /t 30 >nul

cd ../120_kafka
kubectl apply -f kafka-topics.yaml
kubectl apply -f schema-registry.yaml
REM timeout /t 10 >nul
REM kubectl apply -f 110_kafka-source.yaml

REM timeout /t 30 >nul

REM cd ../130_scheduler
REM kubectl apply -f 130_scheduler.yaml
REM timeout /t 10 >nul
REM kubectl apply -f 131_scheduler_source.yaml

cd ../../

timeout /t 90 >nul

cd kubectl/100_db/mongo/rs
kubectl apply -f mongo-setup.yaml

cd ../../../..