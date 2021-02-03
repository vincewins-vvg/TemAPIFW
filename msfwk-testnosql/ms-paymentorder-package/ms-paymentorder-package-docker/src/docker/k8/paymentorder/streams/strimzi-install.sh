#!/bin/bash -e
# --------------------------------------------------------------
# - Script to start Traceability Service
# --------------------------------------------------------------

./kafka_setup.sh

sleep 30

kubectl get pods -n kafka

sleep 10

kubectl -n kafka apply -f kafka.yaml