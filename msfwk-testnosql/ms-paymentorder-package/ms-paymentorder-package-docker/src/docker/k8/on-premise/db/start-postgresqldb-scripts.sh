#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#


export tls_enabled=$1

docker-compose -f paymentorderPostgresql.yml build

cd database/postgresql

kubectl apply -f namespace.yaml


# SSL parameters [Note: Do not change the filenames, change only the paths if necessary]
export pg_hba_conf_location=conf/pg_hba.conf
export server_cert_location=certs/server.crt
export server_key_location=keys/server.key
# Required only if 2-way(mutual) TLS is enabled
export ca_cert_location=certs/ca.crt      

if [ "$tls_enabled" == "ssl" ]; then 
	kubectl create configmap postgresql-config --from-file=$pg_hba_conf_location -n postgresql	
	if [ "$2" == "mutual" ]; then 
		kubectl create secret generic postgresql-cert --from-file=$ca_cert_location --from-file=$server_cert_location -n postgresql
	else
		kubectl create secret generic postgresql-cert --from-file=$server_cert_location -n postgresql
	fi
	kubectl create secret generic postgresql-key --from-file=$server_key_location -n postgresql
	kubectl apply -f db-secrets.yaml
	if [ "$2" == "mutual" ]; then 
		kubectl apply -f postgresql-db-tls-mutual.yaml
	else 
		kubectl apply -f postgresql-db-tls.yaml
	fi	
else 
	kubectl apply -f db-secrets.yaml
	kubectl apply -f postgresql-db.yaml
fi

cd ../..