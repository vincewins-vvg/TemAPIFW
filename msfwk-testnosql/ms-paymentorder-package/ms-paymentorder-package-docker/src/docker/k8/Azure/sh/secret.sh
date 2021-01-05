#!/bin/bash

#FILE RENAME -- acr-imagepullsecret.sh


export RESOURCE_GROUP_NAME="paymentorder"
export AKS_NAME="poakscluster"
export SUBSCRIPTION_ID="e77b124b-df70-4526-a09b-c8d2619386e3"
# Modify for your environment.
# ACR_NAME: The name of your Azure Container Registry
# SERVICE_PRINCIPAL_NAME: Must be unique within your AD tenant
export NAMESPACE="paymentorder"
export SECRET_NAME="poregcredentials"
export ACR_NAME="poacr"
export SERVICE_PRINCIPAL_NAME="po-acr-sp-nosql-order"


az account set --subscription "${SUBSCRIPTION_ID}"

#az aks get-credentials --resource-group "${RESOURCE_GROUP_NAME}" --name "${AKS_NAME}"

# Obtain the full registry ID for subsequent command args
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

# Create the service principal with rights scoped to the registry.
# Default permissions are for docker pull access. Modify the '--role'
# argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles
SP_PASSWD=$(az ad sp create-for-rbac --name http://$SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpull --query password --output tsv)
SP_APP_ID=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
echo "Service principal ID: $SP_APP_ID"
echo "Service principal password: $SP_PASSWD"

kubectl create namespace $NAMESPACE

kubectl create secret docker-registry $SECRET_NAME --namespace $NAMESPACE --docker-server=$ACR_NAME.azurecr.io --docker-username=$SP_APP_ID --docker-password=$SP_PASSWD