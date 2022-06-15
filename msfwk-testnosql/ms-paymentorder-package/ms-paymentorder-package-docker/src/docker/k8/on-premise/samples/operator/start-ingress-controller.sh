#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

#@echo off
#REM --------------------------------------------------------------
#REM - Script to start NGINX Ingress Controller
#REM --------------------------------------------------------------

export ingressController=$(kubectl get namespace -o jsonpath="{.items[?(@.metadata.name=='ingress-nginx')]true}")

if [ "$ingressController" != "true" ]; then
	kubectl apply -f nginx-ingress-controller.yaml
	sleep 30
fi

#ENDOF