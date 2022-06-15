@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo on

for /D %%s in (.\target\azure-functions\*) do (
    if exist target\azure-functions\%%~ns\lib\*-entity.jar del /f target\azure-functions\%%~ns\lib\*-entity.jar
    xcopy db\dbjars\%1-entity-%2.jar target\azure-functions\%%~ns\lib\%1-entity.jar* /d
)