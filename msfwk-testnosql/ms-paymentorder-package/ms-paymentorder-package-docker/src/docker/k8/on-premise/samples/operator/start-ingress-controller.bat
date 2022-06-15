@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start NGINX Ingress Controller
REM --------------------------------------------------------------

kubectl get namespace -o jsonpath={.items[?(@.metadata.name=='ingress-nginx')]true} >> out.txt
set /p ingressController=< out.txt
del out.txt

if NOT "%ingressController%" == "true" (
	kubectl apply -f nginx-ingress-controller.yaml
	timeout /t 30 >nul
)

REM EOF