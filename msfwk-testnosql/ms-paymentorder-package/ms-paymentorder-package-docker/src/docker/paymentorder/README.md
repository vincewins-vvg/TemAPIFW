# README -- Entitlement Helm package

This file contains the prerequisite and deployment related steps for helm pack.

## Folder structure

Unzip the helm pack (entitlement-helm-mongo-pack.zip)

1.	There will images folder which consists of the images saved in tar format which are obtained using docker save command  (Number of tar files depend on the number of services required for the MS)
	These images should be pushed into the repository.
		
	Use docker load command to get the images.
	Eg: docker load --input <image>
	

2.	Helm chart containting the script files for deployment. 


3. 	Sample Scipts to start/stop the helm chart (bat and sh files)

## Pre-requisite:

Please ensure DB set up is present in the environment.

1. 	Db set up. (NoSQL for Entitlement MS)
	
Sample values to be set in your values.yaml for db setup

#Mongo:

```
env:
  database:
    DATABASE_KEY: 
    MONGODB_DBNAME: ms_entitlement 
    MONGODB_CONNECTIONSTR: mongodb://mongodb-0.mongodb-svc.mongodb.svc.cluster.local:27017,mongodb-1.mongodb-svc.mongodb.svc.cluster.local:27017,mongodb-2.mongodb-svc.mongodb.svc.cluster.local:27017
    POSTGRESQL_CONNECTIONURL:
```
	
#Postgres:	
	
```
env:
  database:
    DATABASE_KEY: 
    MONGODB_DBNAME: ms_entitlement 
    MONGODB_CONNECTIONSTR: mongodb://mongodb-0.mongodb-svc.mongodb.svc.cluster.local:27017,mongodb-1.mongodb-svc.mongodb.svc.cluster.local:27017,mongodb-2.mongodb-svc.mongodb.svc.cluster.local:27017
    POSTGRESQL_CONNECTIONURL:
```



2.	If Images are  pushed to external repositories, the name of repositories, image and tag should be mentioned in values.yaml. 

Sample values to be set in your values.yaml for images

Eg: Consider our external repository is "acr.azurecr.io" and tag is "21.0.0", then image references would be as follows:

```
image:
  tag: DEV
  pullPolicy: IfNotPresent
  entitlementapi:
    repository: temenos/ms-entitlement-service
  entitlementingester:
    repository: temenos/ms-entitlement-ingester
  entitlementinboxoutbox:
    repository: temenos/ms-entitlement-inboxoutbox   
```

3. Mention the imagePullSecrets in your values.yaml

Eg: Consider your secret name is "imageRepo", then imagePullSecrets would be as follows:

```
imagePullSecrets: imageRepo
```


## Sample helm command to deploy:


``` 
helm install entitlement ./svc -n entitlement --set env.database.DATABASE_KEY=mongodb --set env.database.POSTGRESQL_CONNECTIONURL=jdbc:postgresql://ent-postgresqldb-service.postgresql.svc.cluster.local:5432/ms_entitlement 
```

## Sample kubectl commmands:

#To Check the services deployed:

Syntax:
```
kubectl get svc -n <namespace> 
```

Eg:
``` 
kubectl get svc -n entitlement
```

#To Check the pods deployed:

Syntax:
```
kubectl get pods -n <namespace> 
```

Eg:
``` 
kubectl get pods -n entitlement
```

#To Check the configmap deployed:

Syntax:
```
kubectl get configmap -n <namespace> 
```

Eg:
``` 
kubectl get configmap -n entitlement
```

#To check logs of a pod: 

```
kubectl logs -f <pod-name> -n <namespace> 
```