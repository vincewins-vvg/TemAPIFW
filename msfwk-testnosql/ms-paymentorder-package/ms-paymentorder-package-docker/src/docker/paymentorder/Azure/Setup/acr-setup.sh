# !/bin/bash -x

# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************


# configuration details


export ACR_PASSWORD=$( az acr login --name "${ACR_NAME}" --expose-token | python -c "import json,sys;apis=json.load(sys.stdin);print(apis['accessToken'])" )

COMMAND=$(echo ${ACR_PASSWORD} | tr -d '\\\r')

docker login "${ACR_NAME}".azurecr.io --username 00000000-0000-0000-0000-000000000000 --password "${COMMAND}"


#docker tag "${DB_IMAGE}":"${VERSION}" "${ACR_NAME}".azurecr.io/"${DB_IMAGE}":"${VERSION}"

#docker push "${ACR_NAME}".azurecr.io/"${DB_IMAGE}":"${VERSION}"


docker tag "${API_IMAGE}":"${VERSION}" "${ACR_NAME}".azurecr.io/"${API_IMAGE}":"${VERSION}"

docker push "${ACR_NAME}".azurecr.io/"${API_IMAGE}":"${VERSION}"


docker tag "${INGESTER_IMAGE}":"${VERSION}" "${ACR_NAME}".azurecr.io/"${INGESTER_IMAGE}":"${VERSION}"

docker push "${ACR_NAME}".azurecr.io/"${INGESTER_IMAGE}":"${VERSION}"


docker tag "${FILEINGESTER_IMAGE}":"${VERSION}" "${ACR_NAME}".azurecr.io/"${FILEINGESTER_IMAGE}":"${VERSION}"

docker push "${ACR_NAME}".azurecr.io/"${FILEINGESTER_IMAGE}":"${VERSION}"


docker tag "${SCHEDULER_IMAGE}":"${VERSION}" "${ACR_NAME}".azurecr.io/"${SCHEDULER_IMAGE}":"${VERSION}"

docker push "${ACR_NAME}".azurecr.io/"${SCHEDULER_IMAGE}":"${VERSION}"


docker tag "${DB_POSTGRES_IMAGE}" "${ACR_NAME}".azurecr.io/"${DB_POSTGRES_IMAGE}"

docker push "${ACR_NAME}".azurecr.io/"${DB_POSTGRES_IMAGE}"
