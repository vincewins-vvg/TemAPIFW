#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

source ./env.sh

# Creates a resource group, AKS and ACR
./acr-resource-creation.sh

# # Secret creation to access images in ACR from AKS
./secret.sh

#Pushes images into ACR
./acr-setup.sh

# Event Hub Namespace creation inside the resource group
./event-hub.sh

# Event Hub Topic creation inside the resource group
./event-hub-topic.sh

# schema registry setup
# ./schema-registry.sh

# Create Cloud storage with secret in Azure
./cloud-storage.sh

az account set --subscription "${SUBSCRIPTION_ID}"

az aks get-credentials --resource-group "${RESOURCE_GROUP_NAME}" --name "${AKS_CLUSTER_NAME}"

