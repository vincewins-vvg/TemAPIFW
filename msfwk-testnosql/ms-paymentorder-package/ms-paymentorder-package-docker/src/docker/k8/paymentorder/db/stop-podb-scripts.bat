@echo off
REM --------------------------------------------------------------
REM - Script to stop Paymentorder Service
REM --------------------------------------------------------------

REM - Stop knative services

cd 100_db/mongo/rs
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


cd ../..