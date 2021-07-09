# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

cd db/

./stop-mssql-db-scripts.sh

cd ../

helm delete payments -n payments

kubectl delete namespace payments

kubectl delete kafkatopics -n kafka table-update-paymentorder

kubectl delete kafkatopics -n kafka paymentorder-outbox

kubectl delete kafkatopics -n kafka ms-eventstore-inbox-topic

kubectl delete kafkatopics -n kafka paymentorder-event-topic

kubectl delete kafkatopics -n kafka ms-paymentorder-inbox-topic

kubectl delete kafkatopics -n kafka error-paymentorder

kubectl delete kafkatopics -n kafka ms-paymentorder-inbox-error-topic

kubectl delete kafkatopics -n kafka multipart-topic