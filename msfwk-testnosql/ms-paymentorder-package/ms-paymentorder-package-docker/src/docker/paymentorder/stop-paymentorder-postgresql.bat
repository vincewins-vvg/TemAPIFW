@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

helm uninstall appinit -n postgresqlpaymentorder

helm uninstall dbinit -n postgresqlpaymentorder

helm uninstall paymentorder -n paymentorder

kubectl delete namespace postgresqlpaymentorder

kubectl delete namespace paymentorder