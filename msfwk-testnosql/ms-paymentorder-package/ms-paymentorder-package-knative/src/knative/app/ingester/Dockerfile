ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG artifactid
ARG java_options
ARG db_artifact

ENV artifactid ${artifactid}
ENV java_options ${java_options}
ENV JAVA_OPTS ${java_options}
ENV db_artifact ${db_artifact}

COPY ${artifactid} /app/${artifactid}
COPY app/dbjars/${db_artifact} /app/ms-entity.jar

RUN chmod -R +x /app

CMD java ${java_options} -jar /app/${artifactid}
