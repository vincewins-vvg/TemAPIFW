#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start Service
#--------------------------------------------------------------

if [ -z "$DOCKER_ENV_LOCATION" ]; then export DOCKER_ENV_LOCATION=config ;fi

# Copy the environment file for docker to resolve
cp -f ${DOCKER_ENV_LOCATION}/k8ENV.env .env

# Now run Docker Compose
docker-compose -f paymentorder-oracle.yml $@

docker-compose -f db-build.yml $@

docker-compose -f db-appinit-build.yml $@

# call kafka.bat up --build -d