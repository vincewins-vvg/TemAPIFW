@echo off
REM --------------------------------------------------------------
REM - Script to stop Paymentorder Service
REM --------------------------------------------------------------

REM - Stop knative services

cd kubectl/110_svc
REM kubectl delete -f 120_paymentorder-ingesters.yaml
kubectl apply -f 100_paymentorder-api.yaml
kubectl apply -f 001_paymentorder-configmap.yaml
kubectl apply -f 000_paymentorder-ns.yaml

cd ../100_db/mongo/rs
kubectl delete -f mongo-setup.yaml
kubectl delete -f 170_mongo_services.yaml
kubectl delete -f 160_rs.yaml
cd ../operator
kubectl delete -f 150_sa.yaml
kubectl delete -f 140_role.yaml
kubectl delete -f 130_rb.yaml
kubectl delete -f 120_operator.yaml
cd ../crd
kubectl delete -f 110_mongo_crd.yaml
cd ../
kubectl delete -f 100_create-mongo-ns.yaml

cd ../../../