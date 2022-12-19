#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# Cluster information
export clusterName=ms-paymentcluster
export clusterRegion=eu-west-2
export nodeName=ms-paymentcluster-nodes
# Repository 
export repositoryName=ms-paymentimagerepository
export serviceAccountName=payments-serviceaccount

helm uninstall kafka-oss -n kafka

helm uninstall posqlappinit -n posqlappinit

helm uninstall payments -n payments

kubectl delete namespace posqlappinit

kubectl delete namespace kafka

cd db/mssql

kubectl delete -f mssql-db.yaml

kubectl delete -f namespace.yaml

kubectl delete -f db-secrets.yaml

cd ../..

# To delete the ECR repositories
aws ecr delete-repository --repository-name $repositoryName --force

# To delete the schema registry ,kafka and zookeeper ECR repositories
aws ecr delete-repository --repository-name cp-schema-registry --force
aws ecr delete-repository --repository-name cp-kafka --force
aws ecr delete-repository --repository-name cp-zookeeper --force

# To delete the kinesis data streams
aws kinesis delete-stream --stream-name ms-paymentorder-inbox-topic 
aws kinesis delete-stream --stream-name paymentorder-event-topic 
aws kinesis delete-stream --stream-name ms-paymentorder-inbox-error-topic 
aws kinesis delete-stream --stream-name ms-payment-outbox-topic 
aws kinesis delete-stream --stream-name error-paymentorder 
aws kinesis delete-stream --stream-name table-update-paymentorder 
aws kinesis delete-stream --stream-name table-update 
aws kinesis delete-stream --stream-name ms-paymentorder-outbox 
aws kinesis delete-stream --stream-name ms-eventstore-inbox-topic 
aws kinesis delete-stream --stream-name multipart-topic 
aws kinesis delete-stream --stream-name ms-paymentorder-ingester-consumer 
aws kinesis delete-stream --stream-name ms-paymentorder-ingester-error-producer
aws kinesis delete-stream --stream-name multipart-1
aws kinesis delete-stream --stream-name reprocess-event

# To delete the nodegroup attached to the cluster
eksctl delete nodegroup --cluster=$clusterName --region $clusterRegion --name=$nodeName

# To delete the Serviceaccount attached to the EKS cluster
eksctl delete iamserviceaccount $serviceAccountName --cluster $clusterName

# To delete the EKS cluster
eksctl delete cluster $clusterName --region $clusterRegion --wait

# To delete s3 bucket
aws s3 rb s3://paymentorder --force