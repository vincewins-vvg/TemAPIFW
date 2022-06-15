#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

cd database/postgresql

kubectl delete -f postgresql-db.yaml

kubectl delete -f db-secrets.yaml

kubectl delete -f namespace.yaml

cd ../..
