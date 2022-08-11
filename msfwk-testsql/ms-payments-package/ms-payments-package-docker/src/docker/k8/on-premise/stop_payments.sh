#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------

cd db/

./stop-sqldb-scripts.sh

cd ../

helm delete svc

# docker-compose -f kafka.yml -f paymentorder-nuo.yml %*

cd streams/kafka

kubectl delete -f kafka-topics.yaml

kubectl delete -f schema-registry.yaml

helm uninstall posqlappinit -n posqlappinit

kubectl delete namespace posqlappinit

cd ../