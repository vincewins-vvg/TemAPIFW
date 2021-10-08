ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG artifactid
ARG java_options

ENV artifactid ${artifactid}
ENV java_options ${java_options}
ENV JAVA_OPTS ${java_options}

COPY ${artifactid} /app/${artifactid}
RUN mkdir -p /target

RUN mkdir -p /target/logs

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /usr
RUN chmod -R +x /usr
RUN chown -R appuser:appgroup /target
RUN chmod -R +x /target
USER appuser

CMD java ${java_options} -jar /app/${artifactid}
