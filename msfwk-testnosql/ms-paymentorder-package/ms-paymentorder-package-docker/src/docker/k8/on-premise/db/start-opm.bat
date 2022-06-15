@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

REM -------- Scripts to Start the Ops Manager and MongoDB kubernetes operator -------- 

SET NAMESPACE="mongodb"
SET USER_NAME="msftemenos"
SET PASSWORD="Passw0rd."
SET FIRST_NAME="MSF"
SET LAST_NAME="Temenos"
SET CRED_SECRET="ops-manager-admin-secret"


kubectl create namespace %NAMESPACE%

cd database/ops-manager

kubectl apply -f opm-crds.yaml -n %NAMESPACE%

cd ../mongo-operator

kubectl apply -f mongo-enterprise.yaml

kubectl create secret generic %CRED_SECRET%  --from-literal=Username="%USER_NAME%" --from-literal=Password="%PASSWORD%" --from-literal=FirstName="%FIRST_NAME%" --from-literal=LastName="%LAST_NAME%" -n %NAMESPACE%

cd ../ops-manager

kubectl apply -f ops-manager.yaml


cd ../..

