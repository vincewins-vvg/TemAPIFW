@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

helm uninstall appinit -n mongopaymentorder

helm uninstall dbinit -n mongopaymentorder

helm uninstall paymentorder -n paymentorder

kubectl delete namespace mongopaymentorder

kubectl delete namespace paymentorder