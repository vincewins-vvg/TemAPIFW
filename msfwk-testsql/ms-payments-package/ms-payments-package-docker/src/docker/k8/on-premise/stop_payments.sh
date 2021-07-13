# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

cd db/

./stop-sqldb-scripts.sh

cd ../

helm delete svc

# docker-compose -f kafka.yml -f paymentorder-nuo.yml %*

kubectl delete kafkatopics -n kafka table-update-paymentorder

kubectl delete kafkatopics -n kafka paymentorder-outbox

kubectl delete kafkatopics -n kafka ms-eventstore-inbox-topic

kubectl delete kafkatopics -n kafka paymentorder-event-topic

kubectl delete kafkatopics -n kafka ms-paymentorder-inbox-topic

kubectl delete kafkatopics -n kafka error-paymentorder

kubectl delete kafkatopics -n kafka ms-paymentorder-inbox-error-topic

kubectl delete kafkatopics -n kafka multipart-topic