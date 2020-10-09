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
kubectl apply -f 130_role_binding.yaml
kubectl apply -f 140_role.yaml
kubectl apply -f 150_service_account.yaml
cd ../rs
kubectl apply -f 160_rs.yaml
kubectl apply -f 170_mongo_services.yaml

cd ../../../110_ksvc
kubectl apply -f 100_paymentorder-create-namespace.yaml
kubectl apply -f 110_paymentorder-api.yaml
kubectl apply -f 120_paymentorder-ingesters.yaml

cd ../120_kafka
kubectl apply -f 100_paymentorder-create-kafka-topics.yaml
kubectl apply -f 110_kafka-source.yaml

cd ../130_scheduler
kubectl apply -f 130_scheduler.yaml
kubectl apply -f 131_scheduler_source.yaml

cd ../../