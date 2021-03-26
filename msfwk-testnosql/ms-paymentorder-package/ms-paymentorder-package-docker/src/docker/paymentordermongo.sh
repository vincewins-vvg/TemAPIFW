#!/bin/bash -e
# --------------------------------------------------------------
# - Script to start Traceability Service
# --------------------------------------------------------------

if [ -z "$DOCKER_ENV_LOCATION" ]; then export DOCKER_ENV_LOCATION=config ;fi
export DATABASE=mongo ;fi
export MSF_NAME=ms-paymentorder ;fi

# Copy the environment file for docker to resolve
cp -f ${DOCKER_ENV_LOCATION}/ENV.env .env

./repackbuild.sh api ms-paymentorder-api.war $@  
./repackbuild.sh inboxoutbox ms-paymentorder-inboxoutbox.jar $@  
./repackbuild.sh ingester ms-paymentorder-ingester.jar $@  
./repackbuild.sh ms-framework-scheduler ms-paymentorder-scheduler.jar $@
./repackbuild.sh fileingester ms-fileingester.jar $@  



# Now run Docker Compose
docker-compose -f kafka.yml -f paymentordermongo.yml $@
