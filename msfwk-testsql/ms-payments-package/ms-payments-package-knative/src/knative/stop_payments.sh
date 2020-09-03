#!/bin/bash -e
# --------------------------------------------------------------
# - Script to stop Payments Service
# --------------------------------------------------------------

# Stop knative services
cd kubectl/120_kafka
kubectl delete -f 110_payments-kafka-source.yaml
kubectl delete -f 100_payments-create-topics.yaml

cd ../110_ksvc
kubectl delete -f 110_payments-ingesters.yaml
kubectl delete -f 100_payments-api-undertow.yaml

cd ../100_db
kubectl delete -f 110_payments-db.yaml
kubectl delete -f 100_payments-create-namespace.yaml

cd ../../