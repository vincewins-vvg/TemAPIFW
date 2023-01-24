#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

###Deploy the following files



##Apply the required kubernetes manifest files

#kubectl apply -f mssql-db-secrets.yaml
#kubectl apply -f mssql-db.yaml
#kubectl apply -f mssql-db-svc.yaml

cd ../

source ./env-mssql.sh

export eventHubConnection=$(az eventhubs namespace authorization-rule keys list --resource-group ${RESOURCE_GROUP_NAME} --namespace-name ${EVENT_HUB_NAME_SPACE} --name RootManageSharedAccessKey | python -c "import json,sys;obj=json.load(sys.stdin); print(obj['primaryConnectionString'])")

echo "event hub : "$eventHubConnection
export string='"$ConnectionString"'
export jaas="org.apache.kafka.common.security.plain.PlainLoginModule required username=$string password=\"$eventHubConnection\";"
echo "jaas : "$jaas
export saasenable="true"

echo "namespace : "$NAMESPACE

echo "runtime : "$RUNTIME_ENV

export storageAccountKey=$(az storage account keys list -g "${RESOURCE_GROUP_NAME}" -n "${STORAGE_ACCOUNT_NAME}" --query [0].value -o tsv)

echo "storageAccountKey : "$storageAccountKey

kubectl delete job appinit-sql-init -n posqlappinit

helm upgrade posqlappinit ./appinit -n posqlappinit --set env.sqlinit.databaseKey=$database_Key --set env.sqlinit.databaseName=$database_Name --set env.sqlinit.dbusername=$db_Username --set env.sqlinit.dbpassword=$db_Password --set image.tag=$tag --set image.sqlinit.repository="${ACR_NAME}.azurecr.io/temenos/ms-paymentorder-appinit:DEV" --set env.sqlinit.dbconnectionurl=$dbinit_Connection_Url --set env.sqlinit.dbautoupgrade="N" --set env.sqlinit.dbdialect=$dialect --set env.sqlinit.dbdriver=$driver_Name

helm upgrade "${NAMESPACE}" ./svc -n "${NAMESPACE}" --set env.database.db_username=$db_Username --set env.database.db_password=$db_Password --set env.database.database_key=$database_Key  --set env.database.database_name=$database_Name --set env.database.driver_name=$driver_Name --set env.database.dialect=$dialect --set env.database.db_connection_url=$db_Connection_Url --set pit.JWT_TOKEN_ISSUER=$Jwt_Token_Issuer --set pit.JWT_TOKEN_PRINCIPAL_CLAIM=$Jwt_Token_Principal_Claim --set pit.ID_TOKEN_SIGNED=$Id_Token_Signed --set pit.JWT_TOKEN_PUBLIC_KEY_CERT_ENCODED=$Jwt_Token_Public_Key_Cert_Encoded --set pit.JWT_TOKEN_PUBLIC_KEY=$Jwt_Token_Public_Key --set env.database.max_pool_size=$max_Pool_Size --set env.database.min_pool_size=$min_Pool_Size --set env.scheduler.time="59 * * ? * *" --set image.tag=$tag --set image.paymentsapi.repository="${ACR_NAME}.azurecr.io/temenos/ms-paymentorder-service" --set image.paymentsingester.repository="${ACR_NAME}.azurecr.io/temenos/ms-paymentorder-ingester" --set image.paymentorderscheduler.repository="${ACR_NAME}.azurecr.io/temenos/ms-paymentorder-scheduler" --set image.paymentordermdal.repository="${ACR_NAME}.azurecr.io/temenos/ms-paymentorder-scheduler" --set image.fileingester.repository="${ACR_NAME}.azurecr.io/temenos/ms-paymentorder-fileingester" --set imagePullSecrets="${IMAGE_PULL_SECRET}" --set env.scheduler.temn_msf_scheduler_inboxcleanup_schedule=$inbox_Cleanup --set env.scheduler.schedule=$schedule --set env.audit.query_enable_system_events=$query_enable_system_events --set env.audit.query_enable_response=$query_enable_response  --set kafkatopic.consumergroupid="${kafkaconsumergroupid}" --set kafkatopic.inboxerrortopic="${kafkainboxerrortopic}" --set kafkatopic.errorproducerid="${kafkaerrorproducerid}" --set kafkatopic.ingestertopic="${kafkaingester}" --set env.azurestorageaccountname="${STORAGE_ACCOUNT_NAME}" --set env.azurestorageaccountkey=$storageAccountKey