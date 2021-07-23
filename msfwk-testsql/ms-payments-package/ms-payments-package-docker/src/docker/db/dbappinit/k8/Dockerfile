ARG INGESTER_APP_BASE_IMAGE
FROM ${INGESTER_APP_BASE_IMAGE}

ADD appinit/ /app/temp/

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app
RUN chmod -R +x /app
USER appuser

WORKDIR app/temp/

CMD java -cp "lib/ms-framework-db-migration.jar:lib/libs/*:" com.temenos.microservice.framework.tools.dbMigration.DbMigrationInstall