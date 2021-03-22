REM -------- Scripts to Stop the Ops Manager and MongoDB kubernetes operator -------- 

cd database/mongo/rs

kubectl delete -f mongo-services.yaml

cd ../../mongo-operator

kubectl delete -f replica-set.yaml

cd ../..

