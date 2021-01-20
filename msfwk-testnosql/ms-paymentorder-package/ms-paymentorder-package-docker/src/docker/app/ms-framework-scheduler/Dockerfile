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

RUN chmod -R +x /app

WORKDIR app/

CMD java -cp "ms-paymentorder-scheduler.jar:" -Dloader.main=${SCHEDULER_MAIN_CLASS} org.springframework.boot.loader.PropertiesLauncher