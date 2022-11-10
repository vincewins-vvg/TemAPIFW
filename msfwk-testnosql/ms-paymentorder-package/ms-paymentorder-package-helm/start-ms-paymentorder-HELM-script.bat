@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

REM --------------------------------------------------------------
REM - Script to start paymentorder HELM Script Service
REM --------------------------------------------------------------
@echo off

SET _do.deploy=%1
SET _do.helm="install"
IF "%_do.deploy%"=="true" (SET _do.helm="deploy")
IF "%_do.deploy%"=="false" (SET _do.helm="install")

CALL cd ..\ms-paymentorder-package-docker\src\docker

REM STEP1: packMongoK8Zip -- To get the folder structure for NoSQL Mongo Helm pack
CALL packMongoK8Zip.bat build

REM STEP2: mvn assembly plugin -- To generate zip for NoSQL Mongo Helm pack
CALL cd ../../
CALL mvn -f mongo-helm-pom.xml %_do.helm%

REM STEP3: packPostgresqlK8Zip -- To get the folder structure for NoSQL Postgres Helm pack
CALL cd src\docker
CALL packPostgresqlK8Zip.bat build

REM STEP4: mvn assembly plugin -- To generate zip for NoSQL Postgres Helm pack
CALL cd ../../
CALL mvn -f postgres-helm-pom.xml %_do.helm%