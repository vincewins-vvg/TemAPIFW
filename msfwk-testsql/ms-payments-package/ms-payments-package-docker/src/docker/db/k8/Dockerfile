ARG INGESTER_APP_BASE_IMAGE
FROM ${INGESTER_APP_BASE_IMAGE}

 

ADD dbMigration/ /app/temp/

 

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app
RUN chmod -R +x /app
USER appuser

 

WORKDIR app/temp/lib

 

CMD java -cp "ms-framework-db-migration.jar:libs/*:" com.temenos.microservice.framework.tools.dbMigration.MSFDataMigration

