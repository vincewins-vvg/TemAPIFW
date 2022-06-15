@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

helm uninstall appinit -n appinitpayments

helm uninstall dbinit -n dbinitpayments

helm uninstall payments -n payments

kubectl delete namespace appinitpayments

kubectl delete namespace dbinitpayments

kubectl delete namespace payments