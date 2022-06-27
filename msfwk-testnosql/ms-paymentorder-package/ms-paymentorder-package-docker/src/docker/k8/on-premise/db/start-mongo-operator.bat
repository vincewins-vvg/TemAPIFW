@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

REM -------- Scripts to Start the Ops Manager and MongoDB kubernetes operator -------- 

SET NAMESPACE="mongodb"
SET USER_NAME="msftemenos"
SET PASSWORD="Passw0rd."
SET API_KEY_SECRET="om-msf-temenos"
SET CONFIG_MAP="ops-manager-connection"
SET PUBLIC_API_KEY="83c4a1c7-2c21-4bd8-8365-36d4466d4bec"


kubectl create secret generic %API_KEY_SECRET% --from-literal="user=%USER_NAME%" --from-literal="publicApiKey=%PUBLIC_API_KEY%" -n %NAMESPACE%

kubectl get om ops-manager -o jsonpath='{.status.opsManager.url}' -n %NAMESPACE%

kubectl create configmap %CONFIG_MAP%  --from-literal="baseUrl=http://ops-manager-svc.mongodb.svc.cluster.local:8080" -n %NAMESPACE%

cd database/mongo-operator

kubectl apply -f replica-set.yaml

cd ../mongo/rs

kubectl apply -f mongo-services.yaml

cd ../../..
