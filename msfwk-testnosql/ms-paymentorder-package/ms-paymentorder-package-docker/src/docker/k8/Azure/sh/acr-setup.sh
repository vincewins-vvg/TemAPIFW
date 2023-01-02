#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# configuration details
export RESOURCE_GROUP_NAME="paymentorder"
export LOCATION="UK South"
export AKS_NAME="poakscluster"
export ACR_NAME="poacr"
export VERSION="DEV"
export DB_IMAGE="temenos/ms-paymentorder-mongoscripts"
export API_IMAGE="temenos/ms-paymentorder-service"
export INGESTER_IMAGE="temenos/ms-paymentorder-ingester"
export FILE_INGESTER_IMAGE="temenos/ms-paymentorder-fileingester"
export SCHEDULER_IMAGE="temenos/ms-paymentorder-scheduler"

export ACR_PASSWORD=$( az acr login --name "${ACR_NAME}" --expose-token | python -c "import json,sys;apis=json.load(sys.stdin); print(apis['accessToken'])" )

echo "${ACR_PASSWORD}"

docker login "${ACR_NAME}".azurecr.io --username 00000000-0000-0000-0000-000000000000 --password "${ACR_PASSWORD}"


docker tag "${DB_IMAGE}" "${ACR_NAME}".azurecr.io/"${DB_IMAGE}":"${VERSION}"

docker push "${ACR_NAME}".azurecr.io/"${DB_IMAGE}":"${VERSION}"


docker tag "${API_IMAGE}" "${ACR_NAME}".azurecr.io/"${API_IMAGE}":"${VERSION}"

docker push "${ACR_NAME}".azurecr.io/"${API_IMAGE}":"${VERSION}"



docker tag "${INGESTER_IMAGE}" "${ACR_NAME}".azurecr.io/"${INGESTER_IMAGE}":"${VERSION}"

docker push "${ACR_NAME}".azurecr.io/"${INGESTER_IMAGE}":"${VERSION}"


docker tag "${FILE_INGESTER_IMAGE}" "${ACR_NAME}".azurecr.io/"${FILE_INGESTER_IMAGE}":"${VERSION}"

docker push "${ACR_NAME}".azurecr.io/"${FILE_INGESTER_IMAGE}":"${VERSION}"



docker tag "${SCHEDULER_IMAGE}" "${ACR_NAME}".azurecr.io/"${SCHEDULER_IMAGE}":"${VERSION}"

docker push "${ACR_NAME}".azurecr.io/"${SCHEDULER_IMAGE}":"${VERSION}"


