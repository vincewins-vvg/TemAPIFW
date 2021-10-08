#@echo off
#REM --------------------------------------------------------------
#REM - Script to start NGINX Ingress Controller
#REM --------------------------------------------------------------

cd external

kubectl apply -f payments-ingress.yaml -n payments

cd ..

#REM EOF