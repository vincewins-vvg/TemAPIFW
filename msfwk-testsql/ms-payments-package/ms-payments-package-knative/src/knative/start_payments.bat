@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

REM - Build payments images
call build.bat build

REM - Start knative services
cd kubectl/100_db
kubectl apply -f 100_payments-create-namespace.yaml
kubectl apply -f 110_payments-db.yaml

cd ../110_ksvc
kubectl apply -f 100_payments-api-undertow.yaml
kubectl apply -f 110_payments-ingesters.yaml

cd ../120_kafka
kubectl apply -f 100_payments-create-topics.yaml
kubectl apply -f 110_payments-kafka-source.yaml

cd ../../