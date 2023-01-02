@echo off

SET accountId=600670497877
SET awsRegion=eu-west-2
SET kinesisRegion=eu-west-2
SET ecrregion=%awsRegion%
REM Cluster Information
SET clustername=ms-paymentcluster
SET clusterregion=eu-west-2
SET nodegroupname=ms-paymentcluster-nodes
SET repositoryname=ms-paymentimagerepository

eksctl create cluster --name %clustername% --region %clusterregion% --fargate 

aws eks --region %clusterregion% update-kubeconfig --name %clustername%

eksctl create nodegroup --cluster=%clustername% --name=%nodegroupname% --region %clusterregion%

aws ecr create-repository --repository-name cp-schema-registry --region %ecrregion%
aws ecr create-repository --repository-name cp-kafka --region %ecrregion%
aws ecr create-repository --repository-name cp-zookeeper --region %ecrregion%

aws ecr get-login-password --region %ecrregion% | docker login --username AWS --password-stdin %accountId%.dkr.ecr.%ecrregion%.amazonaws.com

docker pull confluentinc/cp-schema-registry:5.2.2
docker pull confluentinc/cp-kafka:5.2.2
docker pull confluentinc/cp-zookeeper:5.2.2

docker tag confluentinc/cp-schema-registry:5.2.2 %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-schema-registry:5.2.2
docker tag confluentinc/cp-kafka:5.2.2 %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-kafka:5.2.2
docker tag confluentinc/cp-zookeeper:5.2.2 %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-zookeeper:5.2.2

docker push %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-schema-registry:5.2.2
docker push %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-kafka:5.2.2
docker push %accountId%.dkr.ecr.%ecrregion%.amazonaws.com/cp-zookeeper:5.2.2

helm install kafka-oss cp-helm-charts --version 0.5.0 -n kafka --set cp-zookeeper.image=%accountId%.dkr.ecr.eu-west-2.amazonaws.com/cp-zookeeper --set cp-zookeeper.imageTag=5.2.2 --set cp-kafka.image=%accountId%.dkr.ecr.eu-west-2.amazonaws.com/cp-kafka --set cp-kafka.imageTag=5.2.2 --set cp-schema-registry.image=%accountId%.dkr.ecr.eu-west-2.amazonaws.com/cp-schema-registry --set cp-schema-registry.imageTag=5.2.2 --create-namespace
