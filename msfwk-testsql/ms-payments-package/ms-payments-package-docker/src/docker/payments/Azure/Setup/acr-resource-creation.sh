#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# configuration details
#FILE RENAME -- azure-resource-creation.sh
az group create --name "${RESOURCE_GROUP_NAME}"  --location "${LOCATION}"

az aks create --resource-group "${RESOURCE_GROUP_NAME}" -s Standard_DS4_v2 --name "${AKS_NAME}" --node-count 1 --enable-addons monitoring --generate-ssh-keys

az aks get-credentials --resource-group "${RESOURCE_GROUP_NAME}" --name "${AKS_NAME}"

kubectl get nodes

az acr create --resource-group "${RESOURCE_GROUP_NAME}" --name "${ACR_NAME}" --sku Basic --location "${LOCATION}"

az aks update -n "${AKS_NAME}" -g "${RESOURCE_GROUP_NAME}" --attach-acr "${ACR_NAME}"