#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

ARG INGESTER_APP_BASE_IMAGE
FROM ${INGESTER_APP_BASE_IMAGE}

ADD appinit/ /app/temp/

WORKDIR app/temp/

CMD java -cp "lib/ms-framework-db-migration.jar:lib/libs/*:" com.temenos.microservice.framework.tools.dbMigration.DbMigrationInstall