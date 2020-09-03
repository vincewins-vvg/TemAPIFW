#!/bin/bash -e
# --------------------------------------------------------------
# - Script to start Traceability Service
# --------------------------------------------------------------

if [ -z "$DOCKER_ENV_LOCATION" ]; then export DOCKER_ENV_LOCATION=config ;fi

# Copy the environment file for docker to resolve
cp -f ${DOCKER_ENV_LOCATION}/ENV.env .env

# Now run Docker Compose
docker-compose -f paymentorder.yml $@
