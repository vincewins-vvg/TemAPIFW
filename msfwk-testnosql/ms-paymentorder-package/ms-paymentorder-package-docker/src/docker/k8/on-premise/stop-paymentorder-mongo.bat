@echo off
REM --------------------------------------------------------------
REM - Script to stop Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images


helm uninstall ponosql


cd db

call stop-podb-scripts.bat

REM stop-opm-operator.bat

cd ../



kubectl delete kafkatopics -n kafka table-update-paymentorder

kubectl delete kafkatopics -n kafka paymentorder-outbox

kubectl delete kafkatopics -n kafka ms-eventstore-inbox-topic

kubectl delete kafkatopics -n kafka paymentorder-event-topic

kubectl delete kafkatopics -n kafka ms-paymentorder-inbox-topic

kubectl delete kafkatopics -n kafka error-paymentorder

kubectl delete kafkatopics -n kafka ms-paymentorder-inbox-error-topic