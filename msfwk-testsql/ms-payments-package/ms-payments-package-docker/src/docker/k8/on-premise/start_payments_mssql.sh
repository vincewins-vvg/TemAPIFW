# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

cd ../..

./build-mssql.sh build

cd k8/on-premise/db

./start-mssql-db-scripts.sh

cd ../

sleep 60

kubectl create namespace payments

helm install payments ./svc -n payments