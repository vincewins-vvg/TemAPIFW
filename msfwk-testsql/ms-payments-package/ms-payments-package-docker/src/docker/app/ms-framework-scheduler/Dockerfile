#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG artifactid
ARG java_options
ARG SCHEDULER_MAIN_CLASS

ENV artifactid ${artifactid}
ENV java_options ${java_options}
ENV JAVA_OPTS ${java_options}
ENV SCHEDULER_MAIN_CLASS ${SCHEDULER_MAIN_CLASS}

COPY ${artifactid} /app/${artifactid}

RUN mkdir -p /target

RUN mkdir -p /target/logs

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /usr
RUN chmod -R +x /usr
RUN chown -R appuser:appgroup /target
RUN chmod -R +x /target
USER appuser

WORKDIR app/

CMD java -cp "ms-paymentorder-scheduler.jar:" -Dloader.main=${SCHEDULER_MAIN_CLASS} org.springframework.boot.loader.PropertiesLauncher