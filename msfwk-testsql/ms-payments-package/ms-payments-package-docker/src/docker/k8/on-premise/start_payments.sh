# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

cd ../..

./build.sh create --build

cd k8/on-premise/db

./start-sqldb-scripts.sh

cd ../

sleep 60

helm install svc ./svc

# docker-compose -f kafka.yml -f paymentorder-nuo.yml %*