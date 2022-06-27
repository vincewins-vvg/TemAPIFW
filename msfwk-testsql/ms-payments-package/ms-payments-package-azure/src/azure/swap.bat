@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

echo "PaymentOrder Party Microservice for deployment slot in Azure"

@echo off
For /F "tokens=1* delims==" %%A IN (app.properties) DO (
    IF "%%A"=="RESOURCE_GROUP_NAME" set RESOURCE_GROUP_NAME=%%B
	IF "%%A"=="LOCATION" set LOCATION=%%B
	IF "%%A"=="APP_NAME" set APP_NAME=%%B	
	IF "%%A"=="SLOT_NAME" set SLOT_NAME=%%B	
)

az functionapp deployment slot swap -n %APP_NAME% -g %RESOURCE_GROUP_NAME% -s %SLOT_NAME%

echo "PaymentOrder Microservice Swap in Azure Completed"
REM End of Script