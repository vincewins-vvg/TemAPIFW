#!/bin/bash -e
# --------------------------------------------------------------
# - Script to start Traceability Service
# --------------------------------------------------------------

export JOB_HOME=`pwd`
export LOGS_DIR=$JOB_HOME/logs
export PERF_LOGS_DIR=$JOB_HOME/perflogs
export AGGREGATORJAR_DIR=$JOB_HOME/aggregator


mvn dependency:get -Dartifact=com.temenos.profiler:bytecodecount-logger:1.0.0-SNAPSHOT:jar -U
mvn dependency:get -Dartifact=com.temenos.profiler:bytecodecount-agent:1.0.0-SNAPSHOT:jar -U
mvn dependency:copy -Dartifact=com.temenos.profiler:bytecodecount-logger:1.0.0-SNAPSHOT:jar -DoutputDirectory=$JOB_HOME/app/api -Dmdep.stripVersion=true -U
mvn dependency:copy -Dartifact=com.temenos.profiler:bytecodecount-agent:1.0.0-SNAPSHOT:jar -DoutputDirectory=$JOB_HOME/app/api -Dmdep.stripVersion=true -U

mvn dependency:get -Dartifact=com.temenos.profiler:bytecodecount-data-aggregator:1.0.0-SNAPSHOT:jar -U
mvn dependency:copy -Dartifact=com.temenos.profiler:bytecodecount-data-aggregator:1.0.0-SNAPSHOT:jar -U -DoutputDirectory=$AGGREGATORJAR_DIR -Dmdep.stripVersion=true -U

if [ -z "$DOCKER_ENV_LOCATION" ]; then export DOCKER_ENV_LOCATION=config ;fi

# Copy the environment file for docker to resolve
cp -f ${DOCKER_ENV_LOCATION}/ENV.env .env

# Now run Docker Compose
docker-compose -f kafka.yml -f paymentorder-performance.yml $@