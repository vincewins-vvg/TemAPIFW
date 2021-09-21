@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

cd database/oracle

kubectl apply -f namespace.yaml

kubectl apply -f db-secrets.yaml

cd ../..