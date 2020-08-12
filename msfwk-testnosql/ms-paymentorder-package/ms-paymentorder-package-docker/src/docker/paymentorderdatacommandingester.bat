@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

if not defined DOCKER_ENV_LOCATION set DOCKER_ENV_LOCATION=config
if not defined INGESTER_ENV_LOCATION set INGESTER_ENV_LOCATION=app/ingester/

REM Copy the local log4j2.properties to the ingester jar
jar uf %INGESTER_ENV_LOCATION%/ms-paymentorder-ingester.jar -C %INGESTER_ENV_LOCATION% log4j2.properties


REM Copy the environment file for docker to resolve
copy %DOCKER_ENV_LOCATION%\ENV.env .env > NUL

REM Now run Docker Compose
docker-compose -f kafka.yml -f paymentorderdatacommandingester.yml %*
