#@echo off
#REM --------------------------------------------------------------
#REM - Script to stop NGINX Ingress Controller
#REM --------------------------------------------------------------

kubectl delete ns ingress-nginx
