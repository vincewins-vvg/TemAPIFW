ARG API_BASE_IMAGE
FROM ${API_BASE_IMAGE}

ARG api_artifactid
ARG api_java_options

ENV artifactid ${api_artifactid}
ENV java_options ${api_java_options}
ENV JAVA_OPTS ${java_options}

COPY ${artifactid} /usr/local/tomcat/webapps/${artifactid}

COPY jacocoagent.jar /usr/local/tomcat/webapps/jacocoagent.jar