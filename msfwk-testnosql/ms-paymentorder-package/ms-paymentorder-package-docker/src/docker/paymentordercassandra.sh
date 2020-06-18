#!/bin/bash -e
# --------------------------------------------------------------
# - Script to start Traceability Service
# --------------------------------------------------------------

if [ -z "$DOCKER_ENV_LOCATION" ]; then export DOCKER_ENV_LOCATION=config ;fi
if [ -z "$INGESTER_ENV_LOCATION" ]; then export INGESTER_ENV_LOCATION=app/ingester/ ;fi

# Copy the local log4j2.properties to the ingester jar
jar uf $INGESTER_ENV_LOCATION/ms-paymentorder-ingester.jar -C $INGESTER_ENV_LOCATION log4j2.properties

# Copy the environment file for docker to resolve
cp -f ${DOCKER_ENV_LOCATION}/ENV.env .env

# Now run Docker Compose
docker-compose -f kafka.yml -f paymentordercassandra.yml $@
