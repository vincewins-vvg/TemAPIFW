#@echo off
#REM --------------------------------------------------------------
#REM - Script to stop Paymentorder Service
#REM --------------------------------------------------------------

#REM - Build paymentorder images


helm uninstall ponosql

kubectl delete namespace paymentorder


#cd db

#./stop-podb-scripts.sh

#cd ../

cd streams/kafka

kubectl delete -f kafka-topics.yaml

kubectl delete -f schema-registry.yaml

cd ../..