#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

ARG API_BASE_IMAGE
FROM ${API_BASE_IMAGE}

ARG api_artifactid
ARG api_java_options
ARG db_artifact

ENV artifactid ${api_artifactid}
ENV java_options ${api_java_options}
ENV JAVA_OPTS ${java_options}
ENV db_artifact ${db_artifact}

COPY app/api/${artifactid} /app/${artifactid}
COPY app/dbjars/${db_artifact} /app/ms-entity.jar

ENTRYPOINT /usr/bin/java -jar $java_options /app/$artifactid
