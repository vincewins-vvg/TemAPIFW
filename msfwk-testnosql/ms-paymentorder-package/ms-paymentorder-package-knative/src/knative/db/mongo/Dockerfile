#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

ARG API_BASE_IMAGE
FROM ${API_BASE_IMAGE}

ADD dbMigration/ /app/temp/

WORKDIR app/temp/lib

CMD java -cp "ms-framework-db-migration-DEV.0.0-SNAPSHOT.jar:libs/*:" com.temenos.microservice.framework.tools.dbMigration.MSFDataMigration