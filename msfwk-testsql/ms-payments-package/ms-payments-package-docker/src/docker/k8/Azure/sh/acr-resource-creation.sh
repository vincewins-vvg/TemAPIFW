#!/bin/bash -x
# configuration details
#FILE RENAME -- azure-resource-creation.sh

export NAMESPACE=payments
export RESOURCE_GROUP_NAME="payments"
export LOCATION="UK South"
export AKS_NAME="paymentsakscluster"
export ACR_NAME="paymentsacrrepo"


az group create --name "${RESOURCE_GROUP_NAME}"  --location "${LOCATION}"

az aks create --resource-group "${RESOURCE_GROUP_NAME}" --name "${AKS_NAME}" --node-count 4 --enable-addons monitoring --generate-ssh-keys

az aks get-credentials --resource-group "${RESOURCE_GROUP_NAME}" --name "${AKS_NAME}"

kubectl get nodes

az acr create --resource-group "${RESOURCE_GROUP_NAME}" --name "${ACR_NAME}" --sku Basic --location "${LOCATION}"
