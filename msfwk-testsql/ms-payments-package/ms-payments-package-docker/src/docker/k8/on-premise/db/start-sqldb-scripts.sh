
docker-compose -f paymentorder-sql.yml build

cd database/mysql

kubectl apply -f namespace.yaml

kubectl apply -f mysql-db.yaml

kubectl apply -f db-secrets.yaml

cd ../..