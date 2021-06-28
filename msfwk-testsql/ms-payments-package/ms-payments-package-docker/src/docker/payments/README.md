# README -- serviceorchestrator Helm package

This file contains the prerequisite and deployment related steps for helm pack.

## Folder structure

Unzip the helm pack (serviceorchestrator-helm-pack.zip)

1.	There will images folder which consists of the images saved in tar format which are obtained using docker save command  (Number of tar files depend on the number of services required for the MS)
	These images should be pushed into the repository.
	
	Use docker load command to get the images.
	Eg: docker load --input <image>
	

2.	Helm chart containting the script files for deployment. 


3. 	Sample Scipts to start/stop the helm chart (bat and sh files)



## Pre-requisite:

Please ensure DB and Kafka set up are present in the environment.


1. 	Db set up. (SQL for serviceorchestrator MS)
	
Sample values to be set in your values.yaml for db setup

#SQL:
```
env:
  database:
    database_key: sql
    host: serviceorchestrator-db-service
    database_name: ms_serviceorchestrator
    db_username: root
    db_password: password
    driver_name: com.mysql.jdbc.Driver
    dialect: org.hibernate.dialect.MySQL5InnoDBDialect
    db_connection_url: jdbc:mysql://serviceorchestrator-db-service:3306/ms_serviceorchestrator
    max_pool_size: "5"
    min_pool_size: "1"
```	

#MSSQL:
```
env:
  database:
    database_key: sql
	host: db-service
	database_name: ms_serviceorchestrator
    db_username: sa
    db_password: Rootroot@12345
	driver_name: com.microsoft.sqlserver.jdbc.SQLServerDriver
	dialect: org.hibernate.dialect.SQLServer2012Dialect
	DB_CONNECTION_URL: jdbc:sqlserver://db-service:1433;databaseName=ms_serviceorchestrator
	max_pool_size: "5"
    min_pool_size: "1"
```
	
	
2.	Any kafka service

Sample values to be set in your values.yaml for kafka

	#MSF specific variables
```
env:
  kafka:
	temnmsfstreamvendor: kafka
    temnqueueimpl: kafka
```	
    
	#Strimzi kafka 
```
env:
  kafka:
    kafkabootstrapservers: my-cluster-kafka-bootstrap.kafka:9092
    schema_registry_url: http://schema-registry-svc.kafka.svc.cluster.local
```
    
	#Confluent kafka 
```
env:
  kafka:
    kafkabootstrapservers: 10.107.79.246:9092
    schema_registry_url: http://kafka-oss-cp-schema-registry.kafka.svc.cluster.local:8081
```


3.	Kafka topics to be created for serviceorchestrator MS

```
ms-serviceorchestrator-inbox-topic
```


4.	If Images are  pushed to external repositories, the name of repositories, image and tag should be mentioned in values.yaml. 

Sample values to be set in your values.yaml for images

Eg: Consider our external repository is "acr.azurecr.io" and tag is "21.0.0", then image references would be as follows:

```
image:
  tag: 21.0.0
  pullPolicy: IfNotPresent  
  serviceorchestratorapi:
    repository: acr.azurecr.io/temenos/ms-serviceorchestrator-service
  serviceorchestratoringester:
    repository: acr.azurecr.io/temenos/ms-serviceorchestrator-ingester
  serviceorchestratordelivery:
    repository: acr.azurecr.io/temenos/ms-serviceorchestrator-inboxoutbox
  serviceorchestratorcatchupprocessor:
    repository: acr.azurecr.io/temenos/ms-serviceorchestrator-catchup-processor
```


5. Mention the imagePullSecrets in your values.yaml

Eg: Consider your secret name is "imageRepo", then imagePullSecrets would be as follows:

```
imagePullSecrets: imageRepo
```

## Sample helm command to deploy:

``` 
helm install serviceorchestrator ./svc -n serviceorchestrator
```

## Sample kubectl commmands:

#To Check the services deployed:

Syntax:
```
kubectl get svc -n <namespace> 
```

Eg:
``` 
kubectl get svc -n serviceorchestrator
```

#To Check the pods deployed:

Syntax:
```
kubectl get pods -n <namespace> 
```

Eg:
``` 
kubectl get pods -n serviceorchestrator
```

#To Check the configmap deployed:

Syntax:
```
kubectl get configmap -n <namespace> 
```

Eg:
``` 
kubectl get configmap -n serviceorchestrator
```

#To check logs of a pod: 

```
kubectl logs -f <pod-name> -n <namespace> 
```


 