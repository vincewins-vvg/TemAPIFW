#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

###Deploy the following files

export SUBSCRIPTION_ID="e77b124b-df70-4526-a09b-c8d2619386e3"
export RESOURCE_GROUP_NAME="paymentorder"
export AKS_CLUSTER_NAME="poakscluster"


# Creates a resource group, AKS and ACR
./acr-resource-creation.sh

# Secret creation to access images in ACR from AKS
./secret.sh


cd ../../

./db-image.sh create --build


cd ../

#Build images locally

./paymentorder.sh create --build


cd k8/Azure/sh


#Pushes images into ACR
./acr-setup.sh

# Event Hub Namespace creation inside the resource group
./event-hub.sh

# Event Hub Topic creation inside the resource group
./event-hub-topic.sh


# schema registry setup
./schema-registry.sh


az account set --subscription "${SUBSCRIPTION_ID}"

az aks get-credentials --resource-group "${RESOURCE_GROUP_NAME}" --name "${AKS_CLUSTER_NAME}"


##Apply the required kubernetes manifest files

cd ../../kubectl/schema-registry

kubectl apply -f schema-registry.yaml




cd ../110_svc

kubectl apply -f 001_paymentorder-configmap.yaml

kubectl apply -f 100_paymentorder-api.yaml

kubectl apply -f 101_paymentorder-ingester.yaml




# cd ../130_scheduler

# kubectl apply -f 130_paymentorder-schduler.yaml


cd ../100_db

kubectl apply -f mongo-setup.yaml



cd ../../Azure/sh