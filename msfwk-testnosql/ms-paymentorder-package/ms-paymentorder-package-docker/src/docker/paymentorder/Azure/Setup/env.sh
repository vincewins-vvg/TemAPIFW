#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# configuration details

export SUBSCRIPTION_ID="e77b124b-df70-4526-a09b-c8d2619386e3"
export RESOURCE_GROUP_NAME="paymentorder"
export AKS_CLUSTER_NAME="paymentordercluster"
export NAMESPACE="paymentorder"
export LOCATION="UK South"
export AKS_NAME="paymentordercluster"
export ACR_NAME="paymentorderacr"
export SERVICE_PRINCIPAL_NAME="paymentorderacr"
export SECRET_NAME="paymentorderregcredentials"
export VERSION="DEV"

export DB_IMAGE="dev.local/temenos/ms-paymentorder-initscripts"
export API_IMAGE="dev.local/temenos/ms-paymentorder-service"
export DB_POSTGRES_IMAGE="ms-paymentorder-postgres:latest"
export INGESTER_IMAGE="dev.local/temenos/ms-paymentorder-ingester"
export FILEINGESTER_IMAGE="dev.local/temenos/ms-paymentorder-fileingester"
export SCHEDULER_IMAGE="dev.local/temenos/ms-paymentorder-scheduler"

export FILE_SHARE_NAME="paymentordershare"
export STORAGE_ACCOUNT_NAME="paymentorder"

export EVENT_HUB_NAME_SPACE="paymentorder-Kafka"
export EVENT_HUB="paymentorder"
export EVENT_HUB_CG="paymentordercg"

export EVENT_HUB_INBOX_TOPIC="ms-paymentorder-inbox-topic"
export EVENT_HUB_AVRO_TOPIC="table-update-paymentorder"
export EVENT_HUB_INBOX_ERROR_TOPIC="ms-paymentorder-inbox-error-topic"
export EVENT_HUB_ERROR_TOPIC="error-paymentorder"
export EVENT_HUB_EVENTSTORE_TOPIC="ms-eventstore-inbox-topic"
export EVENT_HUB_OUTBOX="paymentorder-outbox"
export EVENT_HUB_EVENT_TOPIC="paymentorder-event-topic"
export EVENT_HUB_CONSUMER_GROUPID="ms-paymentorder-ingester-consumer"
export EVENT_HUB_ERRORSTREAM_PRODUCERID="ms-paymentorder-ingester-error-producer"
export EVENT_HUB_MULTIPART_TOPIC="ms-paymentorder-inbox-topic"

export EVENT_HUB_INBOX_TOPIC_CG="mspaymentorderinboxtopiccg"
export EVENT_HUB_AVRO_TOPIC_CG="tableupdatepaymentordercg"
export EVENT_HUB_INBOX_ERROR_TOPIC_CG="mspaymentorderinboxerrortopiccg"
export EVENT_HUB_ERROR_TOPIC_CG="errorpaymentordercg"
export EVENT_HUB_EVENTSTORE_TOPIC_CG="mseventstoreinboxtopiccg"
export EVENT_HUB_OUTBOX_CG="paymentorderoutboxcg"
export EVENT_HUB_EVENT_TOPIC_CG="paymentordereventtopiccg"
export EVENT_HUB_CONSUMER_GROUPID_CG="mspaymentorderingesterconsumercg"
export EVENT_HUB_ERRORSTREAM_PRODUCERID_CG="mspaymentorderingestererrorproducercg"
export EVENT_HUB_MULTIPART_TOPIC_CG="mspaymentorderinboxtopiccg"
