#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

### Destroy script

export RESOURCE_GROUP_NAME="paymentorder"

az group delete --name "${RESOURCE_GROUP_NAME}" -y