@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

if not defined DOCKER_ENV_LOCATION set DOCKER_ENV_LOCATION=config
if not defined INGESTER_ENV_LOCATION set INGESTER_ENV_LOCATION=app/ingester/
set DATABASE=mongo
set MSF_NAME=ms-paymentorder

REM Copy the local log4j2.properties to the ingester jar
REM jar uf %INGESTER_ENV_LOCATION%/ms-paymentorder-ingester.jar -C %INGESTER_ENV_LOCATION% log4j2.properties


call repackbuild.bat app\api ms-paymentorder-api.war %*  
call repackbuild.bat app\inboxoutbox ms-paymentorder-inboxoutbox.jar %*  
call repackbuild.bat app\ingester ms-paymentorder-ingester.jar %*  
call repackbuild.bat app\ms-framework-scheduler ms-paymentorder-scheduler.jar %*
call repackbuild.bat app\fileingester ms-fileingester.jar %*  

REM Copy the environment file for docker to resolve
copy %DOCKER_ENV_LOCATION%\ENV.env .env > NUL

REM Now run Docker Compose
docker-compose -f monitor.yml -f kafka.yml -f paymentordermongo.yml %*
