#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

#@echo off
#REM --------------------------------------------------------------
#REM - Script to start NGINX Ingress Controller
#REM --------------------------------------------------------------

cd external

kubectl apply -f paymentorder-ingress.yaml -n paymentorder

cd ..

#REM EOF