#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

##Apply the required kubernetes manifest files

cd ..

source ./env-postgres.sh

export eventHubConnection=$(az eventhubs namespace authorization-rule keys list --resource-group ${RESOURCE_GROUP_NAME} --namespace-name ${EVENT_HUB_NAME_SPACE} --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])")


echo "event hub : "$eventHubConnection
export string='"$ConnectionString"'
export jaas="org.apache.kafka.common.security.plain.PlainLoginModule required username=$string password='$eventHubConnection';"
export saasenable="true"


echo "jaas : "$jaas
echo "namespace : "$NAMESPACE
echo "runtime : "$RUNTIME_ENV
echo "eventHubConnection : "$eventHubConnection

export storageAccountKey=$(az storage account keys list -g "${RESOURCE_GROUP_NAME}" -n "${STORAGE_ACCOUNT_NAME}" --query [0].value -o tsv)

echo "storageAccountKey : "$storageAccountKey

helm upgrade "${NAMESPACE}" ./svc -n "${NAMESPACE}" --set env.database.DATABASE_KEY="${DATABASE_KEY}" --set env.database.MONGODB_DBNAME=paymentorder-db --set env.database.POSTGRESQL_CONNECTIONURL="${POSTGRESQL_CONNECTIONURL}" --set image.paymentorderapi.repository="${ACR_NAME}.azurecr.io/dev.local/temenos/ms-paymentorder-service" --set image.paymentorderingester.repository="${ACR_NAME}.azurecr.io/dev.local/temenos/ms-paymentorder-ingester" --set image.paymentorderscheduler.repository="${ACR_NAME}.azurecr.io/dev.local/temenos/ms-paymentorder-scheduler" --set image.paymentorderinboxoutbox.repository="${ACR_NAME}.azurecr.io/dev.local/temenos/ms-paymentorder-inboxoutbox" --set image.fileingester.repository="${ACR_NAME}.azurecr.io/dev.local/temenos/ms-paymentorder-fileingester" --set imagePullSecrets="${IMAGE_PULL_SECRET}" --set image.tag="${tag}" --set env.azure.jaas_config="${jaas}" --set env.azure.eventhub_connection=$eventHubConnection --set env.azure.eventHubName="${EVENT_HUB_NAME_SPACE}" --set env.kafka.temnmsfstreamvendor=kafka --set env.kafka.temnqueueimpl=kafka --set env.kafka.kafkabootstrapservers="${EVENT_HUB_NAME_SPACE}.servicebus.windows.net:9093"  --set env.database.POSTGRESQL_USERNAME="${POSTGRESQL_USERNAME}" --set env.database.POSTGRESQL_PASSWORD="${POSTGRESQL_PASSWORD}" --set env.database.POSTGRESQL_CRED="${POSTGRESQL_CRED}" --set env.eventdelivery.outboxdirectdeliveryenabled=$eventDirectDelivery --set env.scheduler.temn_msf_scheduler_inboxcleanup_schedule=$inbox_Cleanup --set env.scheduler.schedule=$schedule --set pit.JWT_TOKEN_ISSUER=$Jwt_Token_Issuer --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$Jwt_Token_Principal_Claim --set pit.ID_TOKEN_SIGNED=$Id_Token_Signed --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$Jwt_Token_Public_Key_Cert_Encoded --set pit.JWT_TOKEN_PUBLIC_KEY=$Jwt_Token_Public_Key --set env.azure.runtime="${RUNTIME_ENV}" --set namespace="${NAMESPACE}" --set configmap.location="${configLocation}"  --set rollingupdate.enabled="${rollingUpdate}" --set rollingupdate.api.maxsurge="${apiMaxSurge}" --set rollingupdate.api.maxunavailable="${apiMaxUnavailable}" --set rollingupdate.ingester.maxsurge="${ingesterMaxSurge}" --set rollingupdate.ingester.maxunavailable="${ingesterMaxUnavailable}" --set kafkatopic.consumergroupid="${kafkaconsumergroupid}" --set kafkatopic.inboxerrortopic="${kafkainboxerrortopic}" --set kafkatopic.errorproducerid="${kafkaerrorproducerid}" --set kafkatopic.ingestertopic="${kafkaingester}" --set env.azurestorageaccountname="${STORAGE_ACCOUNT_NAME}" --set env.azurestorageaccountkey=$storageAccountKey