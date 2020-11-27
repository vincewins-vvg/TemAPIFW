@echo off
REM --------------------------------------------------------------
REM - Script to stop Paymentorder Service
REM --------------------------------------------------------------

REM - Stop knative services
cd kubectl/120_kafka
kubectl delete -f 110_kafka-source.yaml
kubectl delete -f 100_paymentorder-create-kafka-topics.yaml

cd ../130_scheduler
kubectl delete -f 130_scheduler.yaml
kubectl delete -f 131_scheduler_source.yaml

cd ../110_ksvc
kubectl delete -f 120_paymentorder-ingesters.yaml
kubectl delete -f 110_paymentorder-api.yaml
kubectl delete -f 102_paymentorder-configmap.yaml
kubectl delete -f 100_paymentorder-create-namespace.yaml

cd ../100_db/mongo/rs
kubectl delete -f mongo-setup.yaml
kubectl delete -f 170_mongo_services.yaml
kubectl delete -f 160_rs.yaml
cd ../operator
kubectl delete -f 150_service_account.yaml
kubectl delete -f 140_role.yaml
kubectl delete -f 130_role_binding.yaml
kubectl delete -f 120_operator.yaml
cd ../crd
kubectl delete -f 110_mongo_crd.yaml
cd ../
kubectl delete -f 100_create-mongo-ns.yaml

cd ../../../