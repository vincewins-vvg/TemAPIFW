@echo on

for /D %%s in (.\target\azure-functions\*) do (
    if exist target\azure-functions\%%~ns\lib\ms-entity.jar del /f target\azure-functions\%%~ns\lib\ms-entity.jar
    xcopy db\dbjars\%1-entity-%2.jar target\azure-functions\%%~ns\lib\ms-entity.jar* /d
)