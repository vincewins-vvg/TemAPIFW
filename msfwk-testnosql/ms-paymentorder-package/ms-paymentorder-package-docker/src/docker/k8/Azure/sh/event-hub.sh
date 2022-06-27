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

# Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.    
az eventhubs namespace create --name "${EVENT_HUB_NAME_SPACE}" --resource-group "${RESOURCE_GROUP_NAME}" -l "${LOCATION}" --enable-kafka true

