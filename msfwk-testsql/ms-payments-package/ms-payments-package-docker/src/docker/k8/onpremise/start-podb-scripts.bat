@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

cd kubectl/100_db

kubectl apply -f 101_mysql-db.yaml

cd ../..