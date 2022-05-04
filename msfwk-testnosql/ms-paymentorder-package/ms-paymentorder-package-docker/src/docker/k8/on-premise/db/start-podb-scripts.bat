REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images

REM - Start knative services

docker-compose -f paymentordermongo.yml build

cd database/mongo
kubectl apply -f create-mongo-ns.yaml
cd crd
kubectl apply -f mongo_crd.yaml
cd ../operator
kubectl apply -f operator.yaml
kubectl apply -f role_binding.yaml
kubectl apply -f role.yaml
kubectl apply -f service_account.yaml
cd ../rs
kubectl apply -f rs.yaml
kubectl apply -f mongo_services.yaml

timeout /t 180 >nul

kubectl apply -f mongo-setup.yaml

cd ../../../