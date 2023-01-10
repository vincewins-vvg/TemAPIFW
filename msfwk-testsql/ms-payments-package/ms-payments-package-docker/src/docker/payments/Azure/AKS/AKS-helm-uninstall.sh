#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

##Apply the required kubernetes manifest files

source ./env-mongo.sh

#uninstall the helm chart changes

helm uninstall "${NAMESPACE}" -n "${NAMESPACE}"

kubectl delete ns postgresql
