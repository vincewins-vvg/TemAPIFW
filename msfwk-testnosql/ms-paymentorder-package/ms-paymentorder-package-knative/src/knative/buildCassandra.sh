#!/bin/bash -e
# --------------------------------------------------------------
# - Script to start Paymentorder Service
# --------------------------------------------------------------

if [ -z "$DOCKER_ENV_LOCATION" ]; then export DOCKER_ENV_LOCATION=config ;fi

# Copy the environment file for docker to resolve
cp -f ${DOCKER_ENV_LOCATION}/cassandraENV.env .env

# Now run Docker Compose
docker-compose -f paymentorderCassandra.yml $@
