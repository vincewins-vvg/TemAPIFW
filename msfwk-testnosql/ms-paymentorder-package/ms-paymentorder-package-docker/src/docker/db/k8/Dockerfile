#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

ARG INGESTER_APP_BASE_IMAGE
FROM ${INGESTER_APP_BASE_IMAGE}

ADD dbMigration/ /app/temp/

WORKDIR app/temp/lib

CMD java -cp "ms-framework-db-migration.jar:libs/*:" com.temenos.microservice.framework.tools.dbMigration.MSFDataMigration