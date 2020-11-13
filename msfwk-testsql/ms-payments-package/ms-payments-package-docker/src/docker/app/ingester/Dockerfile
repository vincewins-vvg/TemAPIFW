ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG artifactid
ARG java_options

ENV artifactid ${artifactid}
ENV java_options ${java_options}
ENV JAVA_OPTS ${java_options}

COPY ${artifactid} /app/${artifactid}
COPY jacocoagent.jar /app/jacocoagent.jar

RUN chmod -R +x /app

CMD java ${java_options} -jar /app/${artifactid}
