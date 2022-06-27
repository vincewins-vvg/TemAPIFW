@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

REM -------- Scripts to Stop the Ops Manager and MongoDB kubernetes operator -------- 

cd database/mongo/rs

kubectl delete -f mongo-services.yaml

cd ../../mongo-operator

kubectl delete -f replica-set.yaml

cd ../..

