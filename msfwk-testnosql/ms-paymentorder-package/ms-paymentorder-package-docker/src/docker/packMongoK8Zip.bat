@echo off
REM --------------------------------------------------------------
REM - Script to create Entitlement Helm Pack
REM --------------------------------------------------------------

cd ../../target

jar xf ms-paymentorder-package-docker-*.zip

cd ms-paymentorder-Docker

if not defined DOCKER_ENV_LOCATION set DOCKER_ENV_LOCATION=config
set DATABASE=mongo
set MSF_NAME=ms-paymentorder

REM Copy the environment file for docker to resolve
copy %DOCKER_ENV_LOCATION%\k8ENV.env .env > NUL
REM copy %DOCKER_ENV_LOCATION%\k8ENV.env .env > NUL

call repackbuild.bat app\api ms-paymentorder-api.war %* 
call repackbuild.bat app\ingester ms-paymentorder-ingester.jar %* 
call repackbuild.bat app\inboxoutbox ms-paymentorder-inboxoutbox.jar %* 
call repackbuild.bat app\ms-framework-scheduler ms-paymentorder-scheduler.jar %* 

REM Now run Docker Compose
docker-compose -f db-build.yml %*

REM Now run Docker Compose
docker-compose -f db-appinit-build.yml %*

REM Now run Docker Compose
docker-compose -f paymentordermongo.yml %*

cd paymentorder

mkdir helm-chart

cd helm-chart

mkdir svc

mkdir dbinit

cd ../../

xcopy k8\on-premise\svc paymentorder\helm-chart\svc /s /e

xcopy k8\on-premise\dbinit paymentorder\helm-chart\dbinit /s /e

xcopy k8\on-premise\appinit paymentorder\helm-chart\appinit /s /e


cd paymentorder

mkdir images


REM Docker save 
cd images

docker image save dev.local/temenos/ms-paymentorder-service:DEV > ms-paymentorder-serviceDEV.tar

docker image save dev.local/temenos/ms-paymentorder-ingester:DEV > ms-paymentorder-ingesterDEV.tar

docker image save dev.local/temenos/ms-paymentorder-inboxoutbox:DEV > ms-paymentorder-inboxoutboxDEV.tar

docker image save dev.local/temenos/ms-paymentorder-scheduler:DEV > ms-paymentorder-schedulerDEV.tar

docker image save dev.local/temenos/ms-paymentorder-dbscripts:DEV > ms-paymentorder-dbscriptsDEV.tar

docker image save dev.local/temenos/ms-paymentorder-fileingester:DEV > ms-paymentorder-fileingesterDEV.tar

docker image save dev.local/temenos/ms-paymentorder-appinit:DEV > ms-paymentorder-appinitDEV.tar


cd ../../


rem Pack the images as a zip
REM jar -cMf ../paymentorder-helm-mongo-pack.zip paymentorder/