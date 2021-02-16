#@echo off
#REM --------------------------------------------------------------
#REM - Script to start Paymentorder Service
#REM --------------------------------------------------------------

#REM - Build paymentorder images

export MONGODB_CONNECTIONSTR=""


cd ../..

./build.sh create --build

#cd k8/on-premise/db

#./start-podb-scripts.sh

#cd ../

cd k8/on-premise/

helm install ponosql ./svc --set env.database.MONGODB_CONNECTIONSTR=$MONGODB_CONNECTIONSTR

