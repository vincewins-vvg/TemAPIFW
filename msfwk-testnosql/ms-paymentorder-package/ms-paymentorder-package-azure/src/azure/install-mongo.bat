@echo off

CALL db/repackbuild.bat ms-paymentorder mongo

set /P input="Enter 1.Production Settings 2.Slot Settings (1/2) ? "

IF "%input%" NEQ "1" (
	IF "%input%" NEQ "2" (
		ECHO Invalid Option Entered
		pause
		exit
	)
)

call "validation.bat"

@echo on
if "%input%" == "2" (
	findstr /m "SLOT_NAME" app.properties >Nul
	if %errorlevel%==1 (
		ECHO SLOT_NAME property must be entered in app.properties
		pause
		exit
	)	
	findstr /m "APP_SRC_PATH" app.properties >Nul
	if %errorlevel%==1 (
		ECHO APP_SRC_PATH property must be entered in app.properties
		pause
		exit
	)	
)

@echo off
For /F "tokens=1* delims==" %%A IN (app.properties) DO (
    IF "%%A"=="RESOURCE_GROUP_NAME" set RESOURCE_GROUP_NAME=%%B
	IF "%%A"=="LOCATION" set LOCATION=%%B
	IF "%%A"=="APP_NAME" set APP_NAME=%%B
	IF "%%A"=="INBOXOUTBOXAPPNAME" set INBOXOUTBOXAPPNAME=%%B
	IF "%%A"=="EVENT_HUB_NAME_SPACE" set EVENT_HUB_NAME_SPACE=%%B
	IF "%%A"=="EVENT_HUB" set EVENT_HUB=%%B
	IF "%%A"=="EVENT_HUB_OUTBOX" set EVENT_HUB_OUTBOX=%%B
	IF "%%A"=="EVENT_HUB_CG" set EVENT_HUB_CG=%%B
	IF "%%A"=="EVENT_HUB_OUTBOX_CG" set EVENT_HUB_OUTBOX_CG=%%B
	IF "%%A"=="RESOURCE_STORAGE_NAME" set RESOURCE_STORAGE_NAME=%%B
	IF "%%A"=="MAX_FILE_UPLOAD_SIZE" set MAX_FILE_UPLOAD_SIZE=%%B
	IF "%%A"=="SLOT_NAME" set SLOT_NAME=%%B
	IF "%%A"=="APP_SRC_PATH" set APP_SRC_PATH=%%B
)

setlocal enabledelayedexpansion
set deploymentVal=
for /f "tokens=1,* delims== " %%i in (deployment.properties) do set deploymentVal=!deploymentVal! %%i=%%j

REM configuration details
SET eventHubConnection="TEST"
SET GENERIC_INGESTER="com.temenos.microservice.framework.core.ingester.GenericCommandSTBinaryIngester"
SET INBOXOUTBOX_INGESTER="com.temenos.microservice.framework.core.ingester.MSKafkaOutboxEventListener"

if "%input%" == "1" (	
	rem deployment azure package into azure enviornment
	call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%APP_NAME% -f pom-azure-deploy.xml -X

	rem OutboxListener function
	call mvn -Pdeploy azure-functions:deploy -Dazure.region=%LOCATION% -Dazure.resourceGroup=%RESOURCE_GROUP_NAME% -DappName=%INBOXOUTBOXAPPNAME% -f pom-azure-deploy.xml -X
)

if "%input%" == "2" (
	rem create deployment slot
	call az functionapp deployment slot create --name %APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --slot %SLOT_NAME%

	rem deploying source in the created deployment slot
	call az webapp deployment source config-zip -g %RESOURCE_GROUP_NAME% -n %APP_NAME% --src %APP_SRC_PATH% --slot %SLOT_NAME%
		
	SET EVENT_HUB_NAME_SPACE="%EVENT_HUB_NAME_SPACE%%SLOT_NAME%"
	SET EVENT_HUB="%EVENT_HUB%%SLOT_NAME%"
	SET EVENT_HUB_OUTBOX="%EVENT_HUB_OUTBOX%%SLOT_NAME%"
	
)

rem Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.
call az eventhubs namespace create --name %EVENT_HUB_NAME_SPACE% --resource-group %RESOURCE_GROUP_NAME% -l %LOCATION% --enable-kafka true

rem Create an event hub. Specify a name for the event hub. 
call az eventhubs eventhub create --name %EVENT_HUB% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

rem Outbox EventListener EventHub //Outbox Listener
call az eventhubs eventhub create --name %EVENT_HUB_OUTBOX% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE%

rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_CG%

rem Consumer Group for event hub
call az eventhubs eventhub consumer-group create --eventhub-name %EVENT_HUB_OUTBOX% --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name %EVENT_HUB_OUTBOX_CG%

rem Reterive event hub connection string
call az eventhubs namespace authorization-rule keys list --resource-group %RESOURCE_GROUP_NAME% --namespace-name %EVENT_HUB_NAME_SPACE% --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])" >> out.txt
set /p eventHubConnection=< out.txt
del out.txt

SET SASL_JASS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%eventHubConnection%\";"

REM create new Storage
call az storage account create -n %RESOURCE_STORAGE_NAME% -g %RESOURCE_GROUP_NAME% -l %LOCATION% --sku Standard_LRS

rem Reterive storage account connection string
call az storage account show-connection-string -g %RESOURCE_GROUP_NAME% -n %RESOURCE_STORAGE_NAME% | python -c "import json,sys;apis=json.load(sys.stdin); print(apis['connectionString'])" >> out1.txt
set /p storageconnectionString=< out1.txt
set AZURE_STORAGE_CONNECTION_STRING=%storageconnectionString%
del out1.txt

setlocal enabledelayedexpansion
set configVal=
for /f "tokens=1,* delims== " %%i in (config.properties) do set configVal=!configVal! %%i=%%j

if "%input%" == "1" (
	rem Environment variable settings
	call az functionapp config appsettings set --name %APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings eventHubConnection=%eventHubConnection% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% eventHubName=%EVENT_HUB%  temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.generic.ingester=%GENERIC_INGESTER% temn.msf.max.file.upload.size=%MAX_FILE_UPLOAD_SIZE% eventHubConsumerGroup=%EVENT_HUB_CG% %configVal% %deploymentVal%

	rem Environment variable settings
	call az functionapp config appsettings set --name %INBOXOUTBOXAPPNAME% --resource-group %RESOURCE_GROUP_NAME% --settings eventHubConnection=%eventHubConnection% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% eventHubName=%EVENT_HUB_OUTBOX% temn.msf.ingest.source.stream=%INGEST_SOURCE_STREAM% temn.msf.ingest.generic.ingester=%INBOXOUTBOX_INGESTER% eventHubConsumerGroup=%EVENT_HUB_OUTBOX_CG% %configVal% %deploymentVal%
)

if "%input%" == "2" (	
	rem Environment variable settings
	call az functionapp config appsettings set --name %APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --settings %configVal%
	
	rem Environment variable settings
	call az functionapp config appsettings set --name %APP_NAME% --resource-group %RESOURCE_GROUP_NAME% --slot-settings eventHubConnection=%eventHubConnection% temn.msf.stream.kafka.sasl.jaas.config=%SASL_JASS_CONFIG% eventHubName=%EVENT_HUB% eventHubConsumerGroup=%EVENT_HUB_CG% %deploymentVal%
)

:END
timeout 5