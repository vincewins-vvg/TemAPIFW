#@echo off
#REM --------------------------------------------------------------
#REM - Script to start Paymentorder Service
#REM --------------------------------------------------------------

#REM - Build paymentorder images

export MONGO_CONENCTONSTR=""

cd ../..

./build.sh create --build

#cd k8/on-premise/db

#./start-podb-scripts.sh

#cd ../

cd k8/on-premise/

sleep 60

helm install ponosql ./svc --set env.database.MONGODB_CONNECTIONSTR=$MONGO_CONENCTONSTR

