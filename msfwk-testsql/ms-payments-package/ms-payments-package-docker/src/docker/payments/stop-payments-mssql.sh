#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

helm uninstall posqlappinit -n posqlappinit

kubectl delete namespace posqlappinit

helm uninstall payments -n payments

kubectl delete namespace payments