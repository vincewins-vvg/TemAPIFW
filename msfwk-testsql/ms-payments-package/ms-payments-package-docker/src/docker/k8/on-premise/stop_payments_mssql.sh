# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

cd db/

./stop-mssql-db-scripts.sh

cd ../

helm delete payments -n payments

kubectl delete namespace payments