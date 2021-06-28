# --------------------------------------------------------------
# - Script to start Service
#--------------------------------------------------------------

cd ../../

export releaseVersion=$(sed -n $(expr $(grep -n "<artifactId>ms-payments-package-docker</artifactId>" pom.xml | cut -d ":" -f1) + 3)p pom.xml | cut -d ">" -f2 | cut -d "<" -f1)

echo "Version : " $releaseVersion

cd target

jar xf ms-payments-package-docker-*.zip

cd ms-payments-Docker


if [ -z "$DOCKER_ENV_LOCATION" ]; then export DOCKER_ENV_LOCATION=config ;fi

# Copy the environment file for docker to resolve
cp -f ${DOCKER_ENV_LOCATION}/k8ENV.env .env

# Now run Docker Compose
docker-compose -f paymentorder.yml $@

docker-compose -f db-build.yml $@

cd payments

mkdir helm-chart

cd ../

cp -r k8/on-premise/svc payments/helm-chart/svc

cp -r k8/on-premise/dbinit payments/helm-chart/dbinit

cd payments

mkdir images

# Docker save 
cd images

docker image save temenos/ms-paymentorder-service:DEV > ms-paymentorder-service:DEV.tar

docker image save temenos/ms-paymentorder-ingester:DEV > ms-paymentorder-ingester:DEV.tar

docker image save temenos/ms-paymentorder-inboxoutbox:DEV > ms-paymentorder-inboxoutboxDEV.tar

docker image save temenos/ms-paymentorder-scheduler:DEV > ms-paymentorder-schedulerDEV.tar

docker image save temenos/ms-paymentorder-initscripts:DEV > ms-paymentorder-initscripts-DEV.tar

cd ../../

# Pack the images as a zip
jar -cMf ../payments-helm-mysql-pack-$releaseVersion.zip payments/