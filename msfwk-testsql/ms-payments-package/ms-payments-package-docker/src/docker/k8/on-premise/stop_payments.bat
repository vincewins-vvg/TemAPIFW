@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

cd db/

call stop-sqldb-scripts.bat

cd ../

helm delete svc

REM docker-compose -f kafka.yml -f paymentorder-nuo.yml %*


cd streams/kafka

kubectl delete -f kafka-topics.yaml

kubectl delete -f schema-registry.yaml

cd ../