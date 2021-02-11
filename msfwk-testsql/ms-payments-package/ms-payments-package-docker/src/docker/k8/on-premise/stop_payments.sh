# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

cd db/

./stop-sqldb-scripts.sh

cd ../

helm delete svc

# docker-compose -f kafka.yml -f paymentorder-nuo.yml %*