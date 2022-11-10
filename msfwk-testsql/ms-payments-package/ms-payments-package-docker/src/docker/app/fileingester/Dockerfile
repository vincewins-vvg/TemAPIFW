#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

ARG BASE_IMAGE
ARG STAGING_IMAGE

FROM ${STAGING_IMAGE} AS staging
ARG artifactid
ENV artifactid ${artifactid}

ADD java-* /tmp/
RUN mkdir -p /tmp/app \
	&& mkdir -p /tmp/java \
	&& mv /tmp/java-*/* /tmp/java/ \
	&& microdnf -y install shadow-utils \
	&& groupadd -f appgroup && useradd appuser -G appgroup \
	&& chown -R appuser:appgroup /tmp \
	&& chmod -R +x /tmp 
COPY fileingester/${artifactid} /tmp/app/${artifactid}


FROM ${BASE_IMAGE}
ARG artifactid
ARG java_options
ENV artifactid ${artifactid}
ENV java_options ${java_options}
ENV JAVA_OPTS ${java_options}
ENV JAVA_HOME=/java
ENV PATH="/java/bin:$PATH"

RUN mkdir -p /java \
	&& mkdir -p /app
COPY --from=staging /etc/passwd /etc/passwd
COPY --from=staging /tmp/java /java/
COPY --from=staging /tmp/app /app/ 
WORKDIR /app
USER appuser
CMD java ${java_options} -jar ${artifactid}
