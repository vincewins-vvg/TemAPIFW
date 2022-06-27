#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

ARG API_BASE_IMAGE
FROM ${API_BASE_IMAGE}

ARG api_artifactid
ARG api_java_options

ENV artifactid ${api_artifactid}
ENV java_options ${api_java_options}
ENV JAVA_OPTS ${java_options}

COPY ${artifactid} /app/${artifactid}

COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh
RUN sed -i 's/\r//' /wait-for-it.sh

ENTRYPOINT /usr/bin/java -jar $java_options /app/$artifactid
