#!/bin/bash -x
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# configuration details

export SUBSCRIPTION_ID="e77b124b-df70-4526-a09b-c8d2619386e3"
export RESOURCE_GROUP_NAME="paymentorder"
export AKS_CLUSTER_NAME="paymentorderakscluster"
export EVENT_HUB_NAME_SPACE="paymentorder-Kafka"
export eventHubConnection=""
export tag="DEV"
export ACR_NAME="paymentorderacr"
export NAMESPACE="payments"
export IMAGE_PULL_SECRET="paymentorderregcredentials"
export STORAGE_ACCOUNT_NAME="paymentorder"

export EVENT_HUB="paymentorder"
export EVENT_HUB_CG="paymentordercg"

#kafka
export kafkaingester="ms-paymentorder-event-topic"
export kafkaconsumergroupid="ms-paymentorder-ingester-consumer"
export kafkainboxerrortopic="ms-paymentorder-inbox-error-topic"
export kafkaerrorproducerid="ms-paymentorder-ingester-error-producer"

#DATABASE
export DATABASE_KEY="sql"
#export MYSQL_CONNECTIONURL="jdbc:mysql://paymentorder-db-service.payments.svc.cluster.local:3007"
export dbinit_Connection_Url="jdbc:mysql://paymentorder-db-service.payments.svc.cluster.local:3007/payments"
export MYSQL_CONNECTIONURL=jdbc:mysql://paymentorder-db-service:3007/payments
export driver_Name="com.mysql.jdbc.Driver"
export db_Dialect="org.hibernate.dialect.MySQL5InnoDBDialect"
export database_Name=payments

export MYSQL_USERNAME="root"
export MYSQL_PASSWORD="password"
export MYSQL_CRED="N"

export eventDirectDelivery=\"true\"
export max_Pool_Size="150"
export min_Pool_Size="10"

export inbox_Cleanup="60"
export Jwt_Token_Issuer=https://localhost:9443/oauth2/token
export Jwt_Token_Principal_Claim=sub
export Id_Token_Signed=true
export Jwt_Token_Public_Key="TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuenlpczFaamZOQjBiQmdLRk1Tdg0KdmtUdHdsdkJzYUpxN1M1d0Era3plVk9WcFZXd2tXZFZoYTRzMzhYTS9wYS95cjQ3YXY3K3ozVlRtdkRSeUFIYw0KYVQ5MndoUkVGcEx2OWNqNWxUZUpTaWJ5ci9Ncm0vWXRqQ1pWV2dhT1lJaHdyWHdLTHFQci8xMWluV3NBa2ZJeQ0KdHZIV1R4WllFY1hMZ0FYRnVVdWFTM3VGOWdFaU5Rd3pHVFUxdjBGcWtxVEJyNEI4blczSENONDdYVXUwdDhZMA0KZStsZjRzNE94UWF3V0Q3OUo5LzVkM1J5MHZiVjNBbTFGdEdKaUp2T3dSc0lmVkNoRHBZU3RUY0hUQ01xdHZXYg0KVjZMMTFCV2twekdYU1c0SHY0M3FhK0dTWU9EMlFVNjhNYjU5b1NrMk9CK0J0T0xwSm9mbWJHRUdndm13eUNJOQ0KTXdJREFRQUI"
export Jwt_Token_Public_Key_Cert_Encoded=""

export schedule="5"
export CLASS_PATH="true"

export API_KEY="LynF1VlkC9sjyeSEodLCuqyt_4nHQnrUitbZll8TuUXTAzFuNT1ASA=="
export RUNTIME_ENV="AZURE"

#Rolling Update Env Variables
export rollingUpdate="false"
export apiMaxSurge="1"
export apiMaxUnavailable="0"
export ingesterMaxSurge="1"
export ingesterMaxUnavailable="0"

# ConfigMap Location
export configLocation="svc/paymentorder-configmap.yaml"