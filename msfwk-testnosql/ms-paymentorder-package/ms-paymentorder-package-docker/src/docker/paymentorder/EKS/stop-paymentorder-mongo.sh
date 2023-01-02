# @REM
# @REM *******************************************************************************
# @REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# @REM *******************************************************************************
# @REM
# @echo off

# Cluster information
export clusterName=ms-paymentorderscluster
export clusterRegion=eu-west-2
export nodeName=ms-paymentordercluster-nodes
# Repository Name 
export repositoryName=ms-paymentorderimagerepository

# Serviceaccountname
export serviceAccountName=paymentorder-serviceaccount

helm uninstall kafka-oss -n kafka

helm uninstall poappinit -n poappinit

helm uninstall paymentorder -n paymentorder

kubectl delete namespace poappinit

kubectl delete namespace paymentorder

cd db/mongo/rs
kubectl delete -f mongo-setup.yaml
kubectl delete -f mongo_services.yaml
kubectl delete -f rs.yaml
cd ../operator
kubectl delete -f service_account.yaml
kubectl delete -f role.yaml
kubectl delete -f role_binding.yaml
kubectl delete -f operator.yaml
cd ../crd
kubectl delete -f mongo_crd.yaml
cd ../
kubectl delete -f create-mongo-ns.yaml
cd ../..

#To delete the ECR repository 
aws ecr delete-repository --repository-name $repositoryName --force

# To delete the schema registry ,kafka and zookeeper ECR repositories
aws ecr delete-repository --repository-name cp-schema-registry --force
aws ecr delete-repository --repository-name cp-kafka --force
aws ecr delete-repository --repository-name cp-zookeeper --force

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

# To delete cluster
eksctl delete cluster $clusterName --region $clusterRegion --wait

# To delete s3 bucket
aws s3 rb s3://paymentorder --force