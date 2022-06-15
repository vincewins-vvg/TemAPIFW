@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

if not defined DOCKER_ENV_LOCATION set DOCKER_ENV_LOCATION=config

REM Copy the environment file for docker to resolve
copy %DOCKER_ENV_LOCATION%\dynamoENV.env .env > NUL

REM Now run Docker Compose
docker-compose -f paymentorderDynamo.yml %*
