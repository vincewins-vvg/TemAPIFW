@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

IF NOT EXIST config.properties (
	ECHO config.properties file is not available
	pause
	exit
)

IF NOT EXIST app.properties (
	ECHO app.properties file is not available
	pause
	exit
)

IF NOT EXIST deployment.properties (
	ECHO deployment.properties file is not available
	pause
	exit
)

findstr /m "RESOURCE_GROUP_NAME" app.properties >Nul
if %errorlevel%==1 (
	ECHO RESOURCE_GROUP_NAME property must be entered in app.properties
	pause
	exit
)

findstr /m "LOCATION" app.properties >Nul
if %errorlevel%==1 (
	ECHO LOCATION property must be entered in app.properties
	pause
	exit
)

findstr /m "APP_NAME" app.properties >Nul
if %errorlevel%==1 (
	ECHO APP_NAME property must be entered in app.properties
	pause
	exit
)

findstr /m "INBOXOUTBOXAPPNAME" app.properties >Nul
if %errorlevel%==1 (
	ECHO INBOXOUTBOXAPPNAME property must be entered in app.properties
	pause
	exit
)

findstr /m "EVENT_HUB_NAME_SPACE" app.properties >Nul
if %errorlevel%==1 (
	ECHO EVENT_HUB_NAME_SPACE property must be entered in app.properties
	pause
	exit
)

findstr /m "EVENT_HUB" app.properties >Nul
if %errorlevel%==1 (
	ECHO EVENT_HUB property must be entered in app.properties
	pause
	exit
)

findstr /m "EVENT_HUB_OUTBOX" app.properties >Nul
if %errorlevel%==1 (
	ECHO EVENT_HUB_OUTBOX property must be entered in app.properties
	pause
	exit
)


findstr /m "EVENT_HUB_CG" app.properties >Nul
if %errorlevel%==1 (
	ECHO EVENT_HUB_CG property must be entered in app.properties
	pause
	exit
)

findstr /m "EVENT_HUB_OUTBOX_CG" app.properties >Nul
if %errorlevel%==1 (
	ECHO EVENT_HUB_OUTBOX_CG property must be entered in app.properties
	pause
	exit
)

findstr /m "DATABASE_KEY" deployment.properties >Nul
if %errorlevel%==1 (
	ECHO DATABASE_KEY property must be entered in deployment.properties
	pause
	exit
)

:END
