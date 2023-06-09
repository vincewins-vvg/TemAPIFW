#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#



docker-compose -f paymentorder-mssql.yml build

cd database/mssql

kubectl apply -f namespace.yaml

kubectl apply -f mssql-db.yaml

kubectl apply -f mssql-db-secrets.yaml

cd ../..