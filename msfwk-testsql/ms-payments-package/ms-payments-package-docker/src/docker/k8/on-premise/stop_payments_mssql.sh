#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

cd db/

./stop-mssql-db-scripts.sh

cd ../

helm delete payments -n payments

kubectl delete namespace payments

cd streams/kafka

kubectl delete -f kafka-topics.yaml

kubectl delete -f schema-registry.yaml

helm uninstall posqlappinit -n posqlappinit

kubectl delete namespace posqlappinit

cd ../