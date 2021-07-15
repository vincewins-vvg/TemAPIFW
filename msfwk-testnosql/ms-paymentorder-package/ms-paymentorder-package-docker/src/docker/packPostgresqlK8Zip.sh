#!/bin/bash -e
# --------------------------------------------------------------
# - Script to create paymentorder Helm Pack
# --------------------------------------------------------------


cd ../../

export releaseVersion=$(sed -n $(expr $(grep -n "<artifactId>ms-paymentorder-package-docker</artifactId>" pom.xml | cut -d ":" -f1) + 3)p pom.xml | cut -d ">" -f2 | cut -d "<" -f1)

echo "Version : " $releaseVersion

chmod -R 777 ./target

cd target

rm -rf paymentorder-Docker

jar xf ms-paymentorder-package-docker-*.zip

cd paymentorder-Docker

find . -name '*' | xargs dos2unix

if [ -z "$DOCKER_ENV_LOCATION" ]; then export DOCKER_ENV_LOCATION=config ;fi
export DATABASE=postgresql
export MSF_NAME=ms-paymentorder

# Copy the environment file for docker to resolve
cp -f ${DOCKER_ENV_LOCATION}/k8ENV.env .env
#REM copy %DOCKER_ENV_LOCATION%\k8ENV.env .env > NUL

chmod -R 777 repackbuild.sh
find . -name 'repackbuild.sh' | xargs dos2unix

./repackbuild.sh app/api ms-paymentorder-api.war $@
./repackbuild.sh app/ingester ms-paymentorder-ingester.jar $@
./repackbuild.sh app/inboxoutbox ms-paymentorder-inboxoutbox.jar $@
./repackbuild.sh app/ms-framework-scheduler ms-paymentorder-scheduler.jar $@

#REM Now run Docker Compose
docker-compose -f paymentorderPostgresql.yml $@

cd paymentorder

mkdir helm-chart

cd ../

cp -r K8/on-premise/svc paymentorder/helm-chart/svc

cp -r K8/on-premise/dbinit paymentorder/helm-chart/dbinit

cd paymentorder

mkdir images

# Docker save 
cd images

docker image save dev.local/temenos/ms-paymentorder-service:DEV > ms-paymentorder-serviceDEV.tar

docker image save dev.local/temenos/ms-paymentorder-ingester:DEV > ms-paymentorder-ingesterDEV.tar

docker image save dev.local/temenos/ms-paymentorder-inboxoutbox:DEV > ms-paymentorder-inboxoutboxDEV.tar

docker image save dev.local/temenos/ms-paymentorder-scheduler:DEV > ms-paymentorder-schedulerDEV.tar

docker image save dev.local/temenos/ms-paymentorder-mongoscripts:DEV > ms-paymentorder-mongoscriptsDEV.tar

cd ../../

# Pack the images as a zip
# jar -cMf ../paymentorder-helm-postgres-pack-$releaseVersion.zip paymentorder/