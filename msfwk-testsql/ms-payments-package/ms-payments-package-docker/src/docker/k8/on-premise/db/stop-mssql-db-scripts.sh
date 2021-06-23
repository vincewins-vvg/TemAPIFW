
cd database/mssql

kubectl delete -f mysql-db.yaml

kubectl delete -f namespace.yaml

kubectl delete -f db-secrets.yaml

cd ../..
