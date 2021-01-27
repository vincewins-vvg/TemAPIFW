REM - Script to start Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images

REM - Start knative services


cd 100_db/mongo
kubectl apply -f 100_create-mongo-ns.yaml
cd crd
kubectl apply -f 110_mongo_crd.yaml
cd ../operator
kubectl apply -f 120_operator.yaml
kubectl apply -f 130_role_binding.yaml
kubectl apply -f 140_role.yaml
kubectl apply -f 150_service_account.yaml
cd ../rs
kubectl apply -f 160_rs.yaml
kubectl apply -f 170_mongo_services.yaml

timeout /t 180 >nul

kubectl apply -f mongo-setup.yaml