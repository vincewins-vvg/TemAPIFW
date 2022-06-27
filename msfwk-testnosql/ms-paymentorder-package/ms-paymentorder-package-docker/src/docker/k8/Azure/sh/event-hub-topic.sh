#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# configuration details
export RESOURCE_GROUP_NAME="paymentorder"
export LOCATION="UK South"
export EVENT_HUB_NAME_SPACE="PaymentOrder-Kafka"
export EVENT_HUB="paymentorder"
export EVENT_HUB_OUTBOX="PaymentOrder-outbox"
export EVENT_HUB_INBOX_TOPIC="PaymentOrder-inbox-topic"
export EVENT_HUB_EVENT_TOPIC="PaymentOrder-event-topic"
export EVENT_HUB_CG="paymentordercg"
export EVENT_HUB_OUTBOX_CG="paymentorderoutboxcg"
export EVENT_HUB_CG="paymentordercg"
export EVENT_HUB_OUTBOX_CG="paymentorderoutboxcg"
export EVENT_HUB_EVENT_CG="paymentordereventcg"
export EVENT_HUB_INBOX_CG="paymentorderinboxcg"


# Create an event hub. Specify a name for the event hub. 
az eventhubs eventhub create --name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

#Outbox EventListener EventHub //Outbox Listener
az eventhubs eventhub create --name "${EVENT_HUB_OUTBOX}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"


#Create an event hub. Specify a name for the event hub. 
az eventhubs eventhub create --name "${EVENT_HUB_INBOX_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

#Outbox EventListener EventHub //Outbox Listener
az eventhubs eventhub create --name "${EVENT_HUB_EVENT_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

#Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_CG}"

#Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_OUTBOX}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_OUTBOX_CG}"

#Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_INBOX_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_INBOX_CG}"

#Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_EVENT_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_EVENT_CG}"

# #Reterive storage account connection string
# export AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string -g "${RESOURCE_GROUP_NAME}" -n "${RESOURCE_STORAGE_NAME}" | python -c "import json,sys;apis=json.load(sys.stdin); print(apis['connectionString'])" )

