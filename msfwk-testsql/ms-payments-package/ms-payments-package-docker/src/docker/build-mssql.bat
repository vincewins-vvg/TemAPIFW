@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

if not defined DOCKER_ENV_LOCATION set DOCKER_ENV_LOCATION=config

REM Copy the environment file for docker to resolve
copy %DOCKER_ENV_LOCATION%\k8ENV.env .env > NUL

REM Now run Docker Compose
docker-compose -f paymentorder-mssql.yml %*

docker-compose -f db-build.yml %*

REM call kafka.bat up --build -d

