#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

helm uninstall appinit -n postgresqlpaymentorder

helm uninstall dbinit -n postgresqlpaymentorder

helm uninstall paymentorder -n paymentorder

kubectl delete namespace postgresqlpaymentorder

kubectl delete namespace paymentorder