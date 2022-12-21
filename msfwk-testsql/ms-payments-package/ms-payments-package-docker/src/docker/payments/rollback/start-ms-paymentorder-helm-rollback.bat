@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

REM - Starting the Helm rollback for paymentorder micro service

helm rollback payments -n payments

timeout /t 90 >nul

REM - Rollback to previous version of deployment completed