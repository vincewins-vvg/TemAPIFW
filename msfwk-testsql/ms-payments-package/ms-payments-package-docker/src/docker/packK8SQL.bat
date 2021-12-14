@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

REM Extract the target zip and execute this file

cd ../../target

jar xf ms-payments-package-docker-*.zip

cd ms-payments-Docker

if not defined DOCKER_ENV_LOCATION set DOCKER_ENV_LOCATION=config

REM Copy the environment file for docker to resolve
copy %DOCKER_ENV_LOCATION%\k8ENV.env .env > NUL

REM Now run Docker Compose
docker-compose -f paymentorder.yml %*

docker-compose -f db-build.yml %*

docker-compose -f db-appinit-build.yml %*

cd payments

mkdir helm-chart

mkdir samples

cd helm-chart

mkdir svc

cd ../../

xcopy k8\on-premise\svc payments\helm-chart\svc /s /e

xcopy k8\on-premise\dbinit payments\helm-chart\dbinit /s /e

xcopy k8\on-premise\appinit payments\helm-chart\appinit /s /e

xcopy k8\on-premise\samples payments\samples /s /e

cd payments

mkdir images


REM Docker save 
cd images

docker image save temenos/ms-paymentorder-service:DEV > ms-paymentorder-serviceDEV.tar

docker image save temenos/ms-paymentorder-ingester:DEV > ms-paymentorder-ingesterDEV.tar

docker image save temenos/ms-paymentorder-inboxoutbox:DEV > ms-paymentorder-inboxoutboxDEV.tar

docker image save temenos/ms-paymentorder-scheduler:DEV > ms-paymentorder-schedulerDEV.tar

docker image save temenos/ms-paymentorder-initscripts:DEV > ms-paymentorder-initscripts-DEV.tar

docker image save temenos/ms-paymentorder-fileingester:DEV > ms-paymentorder-fileingesterDEV.tar

docker image save temenos/ms-paymentorder-appinit:DEV > ms-paymentorder-appinitDEV.tar

cd ../../


rem Pack the images as a zip
REM jar -cMf ../payments-helm-mysql-pack.zip payments/