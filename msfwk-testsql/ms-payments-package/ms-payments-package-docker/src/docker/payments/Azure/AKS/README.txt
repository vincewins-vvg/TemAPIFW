# Kubernates Deployment Steps

Foobar is a Python library for dealing with word pluralization.

## Deploying the yml files

Move to the specific folder Ex: MS\msfwk-testsql\ms-payments-package\ms-payments-package-docker\src\docker\payments\Azure\AKS and open cmd prompt.Use below cmd
to start the sh files holding deployment files paths
```bash
 AKS-helm-mysql-install - mysql
```

## Deploying the yml files

To Check the Pod up and Running 

```
 kubectl get svc -n <namespace>
```

namespace - The namespace hich you created 


## Commands to delete the pods
```
kubectl delete <podname>
```
 