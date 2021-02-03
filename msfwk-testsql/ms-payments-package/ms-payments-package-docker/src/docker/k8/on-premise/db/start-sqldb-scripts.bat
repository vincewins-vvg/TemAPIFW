@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

kubectl apply -f namespace.yaml

kubectl apply -f mysql-db.yaml

kubectl apply -f db-secrets.yaml
