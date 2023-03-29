@REM
@REM *******************************************************************************
@REM * Copyright © Temenos Headquarters SA 2021. All rights reserved.
@REM *******************************************************************************
@REM

@echo off
REM --------------------------------------------------------------
REM - Script to start Payments Service
REM --------------------------------------------------------------

SET tls_enabled=%1

docker-compose -f paymentorderPostgresql.yml build

cd database/postgresql

kubectl apply -f namespace.yaml

REM SSL parameters [Note: Do not change the filenames, change only the paths if necessary]
SET pg_hba_conf_location=conf/pg_hba.conf
SET server_cert_location=certs/server.crt
SET server_key_location=keys/server.key
REM Required only if 2-way(mutual) TLS is enabled
SET ca_cert_location=certs/ca.crt      

if "%tls_enabled%"=="ssl" (
    
	kubectl create configmap postgresql-config --from-file=%pg_hba_conf_location% -n postgresql	
	if "%2"=="mutual" (
		kubectl create secret generic postgresql-cert --from-file=%ca_cert_location% --from-file=%server_cert_location% -n postgresql
	) else (
		kubectl create secret generic postgresql-cert --from-file=%server_cert_location% -n postgresql
	)
	kubectl create secret generic postgresql-key --from-file=%server_key_location% -n postgresql
	kubectl apply -f db-secrets.yaml
	if "%2"=="mutual" (
		kubectl apply -f postgresql-db-tls-mutual.yaml
	) else (
		kubectl apply -f postgresql-db-tls.yaml
	)
) else (
	kubectl apply -f db-secrets.yaml
	kubectl apply -f postgresql-db.yaml
)

cd ../..