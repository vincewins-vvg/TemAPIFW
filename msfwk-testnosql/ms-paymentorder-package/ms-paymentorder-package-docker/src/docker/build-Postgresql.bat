@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

if not defined DOCKER_ENV_LOCATION set DOCKER_ENV_LOCATION=config
set DATABASE=postgresql
set MSF_NAME=ms-paymentorder

REM Copy the environment file for docker to resolve
copy %DOCKER_ENV_LOCATION%\k8ENV.env .env > NUL
REM copy %DOCKER_ENV_LOCATION%\k8ENV.env .env > NUL

call repackbuild.bat app\api ms-paymentorder-api.war %*  
call repackbuild.bat app\inboxoutbox ms-paymentorder-inboxoutbox.jar %*  
call repackbuild.bat app\ingester ms-paymentorder-ingester.jar %*  
call repackbuild.bat app\ms-framework-scheduler ms-paymentorder-scheduler.jar %*
call repackbuild.bat app\fileingester ms-fileingester.jar %*  

REM Now run Docker Compose
docker-compose -f paymentorderPostgresql.yml %*
