#REM
#REM *******************************************************************************
#REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
#REM *******************************************************************************
#REM

#Cluster information
export clusterName=ms-paymentorderscluster
export clusterRegion=eu-west-2
export nodeName=ms-paymentordercluster-nodes
#Repository name
export repositoryName=ms-paymentorderimagerepository

#Serviceaccountname
export serviceAccountName=paymentorder-serviceaccount

helm uninstall kafka-oss -n kafka

helm uninstall poappinit -n poappinit

helm uninstall paymentorder -n paymentorder

kubectl delete namespace poappinit

kubectl delete namespace paymentorder

#To delete the postgresql-db 
cd db/postgresql

kubectl delete -f postgresql-db.yaml

kubectl delete -f namespace.yaml

kubectl delete -f db-secrets.yaml

cd ../..

#To delete the ECR repository 
aws ecr delete-repository --repository-name $repositoryName --force

aws kinesis delete-stream --stream-name ms-paymentorder-inbox-topic 
aws kinesis delete-stream --stream-name paymentorder-event-topic 
aws kinesis delete-stream --stream-name ms-paymentorder-inbox-error-topic 
aws kinesis delete-stream --stream-name payment-outbox-topic 
aws kinesis delete-stream --stream-name error-paymentorder 
aws kinesis delete-stream --stream-name table-update-paymentorder 
aws kinesis delete-stream --stream-name table-update 
aws kinesis delete-stream --stream-name paymentorder-outbox 
aws kinesis delete-stream --stream-name ms-eventstore-inbox-topic 
aws kinesis delete-stream --stream-name multipart-topic 
aws kinesis delete-stream --stream-name ms-paymentorder-ingester-consumer 
aws kinesis delete-stream --stream-name ms-paymentorder-ingester-error-producer

#To delete the nodegroup attached to the cluster
eksctl delete nodegroup --cluster=$clusterName --region $clusterRegion --name=$nodeName

#To delete the Serviceaccount attached to the EKS cluster
eksctl delete iamserviceaccount $serviceAccountName --cluster $clusterName

# To delete cluster
eksctl delete cluster $clusterName --region $clusterRegion --wait

# To delete s3 bucket
aws s3 rb s3://paymentorder --force