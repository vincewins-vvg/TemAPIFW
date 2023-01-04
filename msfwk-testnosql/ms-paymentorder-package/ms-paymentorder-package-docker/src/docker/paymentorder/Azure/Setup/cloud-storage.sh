#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# configuration details


az storage account create -n "${STORAGE_ACCOUNT_NAME}" -g "${RESOURCE_GROUP_NAME}" --kind Storage -l "${LOCATION}"

az storage share create --account-name "${STORAGE_ACCOUNT_NAME}" --name "${FILE_SHARE_NAME}"

export KEY=$(az storage account keys list -g "${RESOURCE_GROUP_NAME}" -n "${STORAGE_ACCOUNT_NAME}" --query [0].value -o tsv)

COMMAND=$(echo ${KEY} | tr -d '\\\r')

echo "Key Value : ${COMMAND}"

kubectl create secret generic storagesecret --from-literal=azurestorageaccountname="${STORAGE_ACCOUNT_NAME}" --from-literal=azurestorageaccountkey="${COMMAND}" -n "${NAMESPACE}"