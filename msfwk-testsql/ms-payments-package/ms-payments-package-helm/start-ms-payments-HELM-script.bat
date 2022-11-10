@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

REM --------------------------------------------------------------
REM - Script to start payments HELM Script Service
REM --------------------------------------------------------------
@echo off

SET _do.deploy=%1
SET _do.helm="install"
IF "%_do.deploy%"=="true" (SET _do.helm="deploy")
IF "%_do.deploy%"=="false" (SET _do.helm="install")

CALL cd ..\ms-payments-package-docker\src\docker

REM STEP1: packk8SQLZip -- To get the folder structure for SQL Helm pack
CALL packK8SQL.bat build

REM STEP2: mvn assembly plugin -- To generate zip for SQL Helm pack
CALL cd ../../
CALL mvn -f sql-helm-pom.xml %_do.helm%
