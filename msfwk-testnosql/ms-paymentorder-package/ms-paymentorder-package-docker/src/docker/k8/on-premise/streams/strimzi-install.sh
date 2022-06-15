#!/bin/bash -e
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start Strimzi Kafka Operator
# --------------------------------------------------------------

./kafka_setup.sh

# Uncomment the below line if you are facing certificate issue while running strimzi setup in K8
# kubectl create namespace kafka
# curl file:///<filepath>/strimzi-cluster-operator-0.16.2.yaml \
# | sed 's/namespace: .*/namespace: kafka/' \
# | kubectl -n kafka apply -f -

sleep 30

kubectl get pods -n kafka

sleep 10

kubectl -n kafka apply -f kafka.yaml