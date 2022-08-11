#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

#@echo off
#REM --------------------------------------------------------------
#REM - Script to stop Paymentorder Service
#REM --------------------------------------------------------------

#REM - Build paymentorder images


helm uninstall ponosql

kubectl delete namespace paymentorder

helm uninstall poappinit

kubectl delete namespace poappinit

cd db

./stop-postgresqldb-scripts.sh

cd ../

cd streams/kafka

kubectl delete -f kafka-topics.yaml

kubectl delete -f schema-registry.yaml

cd ../..