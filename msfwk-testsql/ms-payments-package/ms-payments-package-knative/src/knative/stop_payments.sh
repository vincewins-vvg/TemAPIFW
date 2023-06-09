#!/bin/bash -e
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to stop Payments Service
# --------------------------------------------------------------

# Stop knative services
cd kubectl/120_kafka
kubectl delete -f 120_strimzi.yaml
kubectl delete -f 110_payments-kafka-source.yaml
kubectl delete -f 100_payments-create-topics.yaml

cd ../130_scheduler
kubectl delete -f 130_scheduler.yaml
kubectl delete -f 131_scheduler_source.yaml

cd ../110_ksvc
kubectl delete -f 110_payments-ingesters.yaml
kubectl delete -f 100_payments-api-undertow.yaml
kubectl delete -f 001_payments-configmap.yaml

cd ../100_db
kubectl delete -f 110_payments-db.yaml
kubectl delete -f 101_payments-secrets.yaml
kubectl delete -f 100_payments-create-namespace.yaml


cd ../../