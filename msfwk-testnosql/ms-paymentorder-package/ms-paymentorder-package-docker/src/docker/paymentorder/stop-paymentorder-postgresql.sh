#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

helm uninstall poappinit -n poappinit

helm uninstall paymentorder -n paymentorder

kubectl delete namespace poappinit

kubectl delete namespace paymentorder