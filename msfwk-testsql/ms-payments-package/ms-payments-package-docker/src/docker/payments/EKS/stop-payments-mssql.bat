@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off

REM Cluster information
SET clusterName=ms-paymentcluster
SET clusterRegion=eu-west-2
SET nodeName=ms-paymentcluster-nodes
REM Repository 
SET repositoryName=ms-paymentimagerepository
SET serviceAccountName=payments-serviceaccount
SET storage="s3://paymentsstorage"

helm uninstall kafka-oss -n kafka

helm uninstall posqlappinit -n posqlappinit

helm uninstall payments -n payments

kubectl delete namespace posqlappinit

REM kubectl delete namespace kafka

cd db/mssql

kubectl delete -f mssql-db.yaml

kubectl delete -f namespace.yaml

kubectl delete -f mssql-db-secrets.yaml

cd ../..

REM To delete the ECR repository 
aws ecr delete-repository --repository-name %repositoryName% --force

REM To delete the schema registry ,kafka and zookeeper ECR repositories
aws ecr delete-repository --repository-name cp-schema-registry --force
aws ecr delete-repository --repository-name cp-kafka --force
aws ecr delete-repository --repository-name cp-zookeeper --force

REM To delete the kinesis data streams
aws kinesis delete-stream --stream-name ms-paymentorder-inbox-topic 
aws kinesis delete-stream --stream-name paymentorder-event-topic 
aws kinesis delete-stream --stream-name ms-paymentorder-inbox-error-topic 
aws kinesis delete-stream --stream-name payment-outbox-topic
aws kinesis delete-stream --stream-name payment-outbox
aws kinesis delete-stream --stream-name error-paymentorder 
aws kinesis delete-stream --stream-name table-update-paymentorder 
aws kinesis delete-stream --stream-name table-update 
aws kinesis delete-stream --stream-name paymentorder-inbox-topic 
aws kinesis delete-stream --stream-name ms-eventstore-inbox-topic 
aws kinesis delete-stream --stream-name multipart-topic 
aws kinesis delete-stream --stream-name ms-paymentorder-ingester-consumer 
aws kinesis delete-stream --stream-name ms-paymentorder-ingester-error-producer
aws kinesis delete-stream --stream-name multipart-1
aws kinesis delete-stream --stream-name reprocess-event
aws kinesis delete-stream --stream-name Test-topic

REM To delete the nodegroup attached to the EKS cluster
eksctl delete nodegroup --cluster=%clusterName% --region %clusterRegion% --name=%nodeName%

REM REM To delete the Serviceaccount attached to the EKS cluster
eksctl delete iamserviceaccount %serviceAccountName% --cluster %clusterName%

REM REM To delete the EKS cluster
eksctl delete cluster %clusterName% --region %clusterRegion% --wait

REM REM To delete the s3 bucket
aws s3 rb %storage% --force