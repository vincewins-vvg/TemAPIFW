@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

REM helm uninstall posqlappinit -n posqlappinit

REM kubectl delete namespace posqlappinit

helm uninstall payments -n payments

kubectl delete namespace payments