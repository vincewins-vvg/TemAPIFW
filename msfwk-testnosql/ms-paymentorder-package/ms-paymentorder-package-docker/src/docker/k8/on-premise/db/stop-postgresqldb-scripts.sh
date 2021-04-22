cd database/postgresql

kubectl delete -f postgresql-db.yaml

kubectl delete -f db-secrets.yaml

kubectl delete -f namespace.yaml

cd ../..
