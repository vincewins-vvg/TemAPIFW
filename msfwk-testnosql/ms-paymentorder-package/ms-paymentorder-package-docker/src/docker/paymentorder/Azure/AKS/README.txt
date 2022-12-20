# Kubernates Deployment Steps

Foobar is a Python library for dealing with word pluralization.

## Deploying the yml files

Move to the specific folder Ex: MS\frmwktestsuite\ms-paymentorder\ms-paymentorder-package\ms-paymentorder-package-docker\src\docker\paymentorder\Azure\AKS and open cmd prompt.Use below cmd
to start the sh files holding deployment files paths
```bash
 AKS-helm-install.sh -- mongo
 AKS-helm-postgres-install - postgresql
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
 