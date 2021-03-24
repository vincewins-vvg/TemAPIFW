cd database/postgresql

kubectl apply -f namespace.yaml

kubectl apply -f postgresql-db.yaml

kubectl apply -f db-secrets.yaml

cd ../..