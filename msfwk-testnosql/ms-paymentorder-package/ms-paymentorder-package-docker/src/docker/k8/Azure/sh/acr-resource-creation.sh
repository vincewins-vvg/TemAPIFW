#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# configuration details
#FILE RENAME -- azure-resource-creation.sh

export NAMESPACE=paymentorder
export RESOURCE_GROUP_NAME="paymentorder"
export LOCATION="UK South"
export AKS_NAME="poakscluster"
export ACR_NAME="poacr"
export SERVICE_PRINCIPAL_NAME="poacrserviceprincipal"
export SECRET_NAME="poregcred"


az group create --name "${RESOURCE_GROUP_NAME}"  --location "${LOCATION}"

az aks create --resource-group "${RESOURCE_GROUP_NAME}" --name "${AKS_NAME}" --node-count 1 --enable-addons monitoring --generate-ssh-keys

az aks get-credentials --resource-group "${RESOURCE_GROUP_NAME}" --name "${AKS_NAME}"

kubectl get nodes

az acr create --resource-group "${RESOURCE_GROUP_NAME}" --name "${ACR_NAME}" --sku Basic --location "${LOCATION}"
