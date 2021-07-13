@echo off
REM --------------------------------------------------------------
REM - Script to stop Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images


helm uninstall ponosql

kubectl delete namespace paymentorder


cd db

call stop-postgresqldb-scripts.bat

cd ../

kubectl delete kafkatopics -n kafka table-update-paymentorder

kubectl delete kafkatopics -n kafka paymentorder-outbox

kubectl delete kafkatopics -n kafka ms-eventstore-inbox-topic

kubectl delete kafkatopics -n kafka paymentorder-event-topic

kubectl delete kafkatopics -n kafka ms-paymentorder-inbox-topic

kubectl delete kafkatopics -n kafka error-paymentorder

kubectl delete kafkatopics -n kafka ms-paymentorder-inbox-error-topic

kubectl delete kafkatopics -n kafka multipart-topic