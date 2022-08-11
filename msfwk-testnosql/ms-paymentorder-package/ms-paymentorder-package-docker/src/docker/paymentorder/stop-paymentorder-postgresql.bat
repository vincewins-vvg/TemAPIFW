@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

helm uninstall poappinit -n poappinit

helm uninstall paymentorder -n paymentorder

kubectl delete namespace poappinit

kubectl delete namespace paymentorder