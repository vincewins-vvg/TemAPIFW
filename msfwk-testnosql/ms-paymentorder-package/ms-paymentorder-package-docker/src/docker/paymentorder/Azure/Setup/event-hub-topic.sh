#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#


# Create an event hub. Specify a name for the event hub. 
az eventhubs eventhub create --name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_INBOX_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_CONSUMER_GROUPID}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_ERRORSTREAM_PRODUCERID}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_AVRO_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_INBOX_ERROR_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_ERROR_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_EVENTSTORE_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_OUTBOX}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_EVENT_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"

az eventhubs eventhub create --name "${EVENT_HUB_MULTIPART_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}"



#Consumer Group for event hub
az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_INBOX_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_INBOX_TOPIC_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_CONSUMER_GROUPID}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_CONSUMER_GROUPID_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_ERRORSTREAM_PRODUCERID}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_ERRORSTREAM_PRODUCERID_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_AVRO_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_AVRO_TOPIC_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_INBOX_ERROR_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_INBOX_ERROR_TOPIC_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_ERROR_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_ERROR_TOPIC_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_EVENTSTORE_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_EVENTSTORE_TOPIC_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_OUTBOX}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_OUTBOX_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_EVENT_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_EVENT_TOPIC_CG}"

az eventhubs eventhub consumer-group create --eventhub-name "${EVENT_HUB_MULTIPART_TOPIC}" --resource-group "${RESOURCE_GROUP_NAME}" --namespace-name "${EVENT_HUB_NAME_SPACE}" --name "${EVENT_HUB_MULTIPART_TOPIC_CG}"


