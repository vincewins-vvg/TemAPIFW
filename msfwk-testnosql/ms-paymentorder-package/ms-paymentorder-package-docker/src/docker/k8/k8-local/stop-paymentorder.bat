@echo off
REM --------------------------------------------------------------
REM - Script to stop Paymentorder Service
REM --------------------------------------------------------------

REM - Stop knative services

cd kubectl/120_kafka
kubectl delete -f kafka-topics.yaml

cd ../130_scheduler
kubectl delete -f 100_scheduler-job.yaml

cd ../110_svc
kubectl delete -f 110_paymentorder-ingester.yaml
kubectl delete -f 100_paymentorder-api.yaml
kubectl delete -f 001_paymentorder-configmap.yaml
kubectl delete -f 000_paymentorder-ns.yaml



cd ../../