#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#


cd database/mysql

kubectl delete -f mysql-db.yaml

kubectl delete -f namespace.yaml

kubectl delete -f db-secrets.yaml

cd ../..