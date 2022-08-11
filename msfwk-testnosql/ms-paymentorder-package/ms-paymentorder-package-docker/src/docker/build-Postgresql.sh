#!/bin/bash -e
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start Traceability Service
# --------------------------------------------------------------

if [ -z "$DOCKER_ENV_LOCATION" ]; then export DOCKER_ENV_LOCATION=config ;fi
export DATABASE=postgresql
export MSF_NAME=ms-paymentorder

# Copy the environment file for docker to resolve
cp -f ${DOCKER_ENV_LOCATION}/k8ENV.env .env
#REM copy %DOCKER_ENV_LOCATION%\k8ENV.env .env > NUL

./repackbuild.sh app/api ms-paymentorder-api.war $@  
./repackbuild.sh app/inboxoutbox ms-paymentorder-inboxoutbox.jar $@  
./repackbuild.sh app/ingester ms-paymentorder-ingester.jar $@  
./repackbuild.sh app/ms-framework-scheduler ms-paymentorder-scheduler.jar $@
./repackbuild.sh app/fileingester ms-fileingester.jar $@  

#REM Now run Docker Compose
docker-compose -f db-appinit-build.yml $@

#REM Now run Docker Compose
docker-compose -f paymentorderPostgresql.yml $@

