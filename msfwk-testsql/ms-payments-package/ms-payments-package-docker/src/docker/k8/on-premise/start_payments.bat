@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

cd ../..

call build.bat build

cd k8/on-premise/db

call start-sqldb-scripts.bat

cd ../

helm install svc ./svc

REM docker-compose -f kafka.yml -f paymentorder-nuo.yml %*
