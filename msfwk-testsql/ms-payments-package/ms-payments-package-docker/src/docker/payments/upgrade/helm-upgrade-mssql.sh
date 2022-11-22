#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start Service
# --------------------------------------------------------------
export MSSQL_CRED="N"
export DATABASE_KEY=sql
export DB_HOST=serviceorchestrator-db-service
export DB_NAME=ms_service_orchestrator
export DB_USERNAME=sa
export DB_PASSWORD=Rootroot@12345
export DB_DRIVER=com.microsoft.sqlserver.jdbc.SQLServerDriver
export DB_DIALECT=org.hibernate.dialect.SQLServer2012Dialect
export DB_CONNECTION_URL="jdbc:sqlserver://serviceorchestrator-db-service:1433;databaseName=ms_service_orchestrator"
export MIN_POOL_SIZE="5"
export MAX_POOL_SIZE="1"


# -------- KAFKA
export kafkabootstrapservers="my-cluster-kafka-bootstrap.kafka:9092"
export schema_registry_url="http://schema-registry-svc.kafka.svc.cluster.local" 
export schedulertime="59 * * ? * *"
# ------- IMAGE PROPERTIES
cd ../
export releaseVersion=$(<version.txt)
echo "Version : " $releaseVersion
export tag=$releaseVersion
cd upgrade

export apiImage=temenos/ms-serviceorchestrator-service
export ingesterImage=temenos/ms-serviceorchestrator-ingester
export eventdeliveryImage=temenos/ms-serviceorchestrator-inboxoutbox
export catchupImage=temenos/ms-serviceorchestrator-catchup-processor
export schedulerImage=temenos/ms-serviceorchestrator-scheduler
export ENV_NAME=""

export soImagePullSecret=""
export dbinitImagePullSecret=""


# --- To enable hostAliases, export the below variable to "Y"
export kafkaAliases="N"

# --- export the following variables for hostAliases
export kafkaip=""
export kafka0ip=""
export kafka1ip=""
export kafka2ip=""

export kafkaHostName=""
export kafka0HostName=""
export kafka1HostName=""
export kafka2HostName=""

# -- Minutes required to delete ms_inbox_events in table
export inboxcleanup="60"

#Rolling Update Env Variables
export rollingUpdate="false"
export apiMaxSurge="1"
export apiMaxUnavailable="0"
export ingesterMaxSurge="1"
export ingesterMaxUnavailable="0"

# ConfigMap Location
export configLocation="svc/so-configmap.yaml"

cd ../helm-chart

helm upgrade serviceorchestrator ./svc -n serviceorchestrator --set env.database.MSSQL_CRED=$MSSQL_CRED --set env.database.host=$DB_HOST --set env.database.db_username=$DB_USERNAME --set env.database.db_password=$DB_PASSWORD --set env.database.database_key=$DATABASE_KEY --set env.database.database_name=$DB_NAME --set env.database.driver_name=$DB_DRIVER --set env.database.dialect=$DB_DIALECT --set env.database.db_connection_url=$DB_CONNECTION_URL --set env.database.max_pool_size=$MAX_POOL_SIZE --set env.database.min_pool_size=$MIN_POOL_SIZE --set env.kafka.kafkabootstrapservers=$kafkabootstrapservers --set env.kafka.schema_registry_url=$schema_registry_url --set image.tag=$tag --set image.serviceorchestratorapi.repository=$apiImage --set image.serviceorchestratoringester.repository=$ingesterImage --set image.serviceorchestratordelivery.repository=$eventdeliveryImage --set image.serviceorchestratorcatchupprocessor.repository=$catchupImage --set image.serviceorchestratorscheduler.repository=$schedulerImage --set imagePullSecrets=$soImagePullSecret --set env.kafka.kafkaAliases=$kafkaAliases --set env.kafka.kafkaip=$kafkaip --set env.kafka.kafka0ip=$kafka0ip --set env.kafka.kafka1ip=$kafka1ip --set env.kafka.kafka2ip=$kafka2ip --set env.kafka.kafkaHostName=$kafkaHostName --set env.kafka.kafka0HostName=kafka0HostName --set env.kafka.kafka1HostName=kafka1HostName --set env.kafka.kafka2HostName=$kafka2HostName --set env.scheduler.temn_msf_scheduler_inboxcleanup_schedule=$inboxcleanup env.scheduler.schedule="5" --set env.name=$ENV_NAME --set configmap.location=$configLocation --set rollingupdate.enabled=$rollingUpdate --set rollingupdate.api.maxsurge=$apiMaxSurge --set rollingupdate.api.maxunavailable=$apiMaxUnavailable --set rollingupdate.ingester.maxsurge=$ingesterMaxSurge --set rollingupdate.ingester.maxunavailable=$ingesterMaxUnavailable

cd ../upgrade