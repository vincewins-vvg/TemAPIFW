#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

ARG BASE_IMAGE
ARG STAGING_IMAGE

FROM ${STAGING_IMAGE} AS staging
ARG api_artifactid
ARG ssl_enabled
ARG keystore_pass
ENV artifactid ${api_artifactid}

ADD java-* /tmp/
RUN microdnf -y install tar gzip shadow-utils \
    && mkdir -p /tmp/tomcat/target/logs \
	&& mkdir -p /tmp/tomcat/temp \
	&& mkdir -p /tmp/tomcat/dump \
	&& mkdir -p /tmp/java \
	&& mkdir -p /tmp/app/lib/target/logs \
	&& mkdir -p /tmp/target/logs \
    && curl -k https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.63/bin/apache-tomcat-9.0.63.tar.gz -L -o "/tmp/tomcat.tar.gz" \
    && tar -zxf "/tmp/tomcat.tar.gz" -C /tmp/tomcat/ --strip-components=1 \
	&& sed -i 's/endorsed/e/g' /tmp/tomcat/bin/catalina.sh \
	&& sed -i 's/<Context>/<Context>\n\n\t<JarScanner scanClassPath="false">\n\t\t<JarScanFilter defaultPluggabilityScan="false"\/>\n\t<\/JarScanner>/' /tmp/tomcat/conf/context.xml \
	&& mv /tmp/java-*/* /tmp/java/ \
	&& groupadd -f appgroup && useradd appuser -G appgroup \
	&& chown -R appuser:appgroup /tmp \
	&& chmod -R 777 /tmp/tomcat/ \
	&& chmod -R 777 /tmp/target/ \
	&& chmod -R 777 /tmp/app/ \
	&& chmod -R +x /tmp/java/
COPY api/${artifactid} /tmp/tomcat/webapps/${artifactid}
COPY api/.keystore/.keystore /tmp/tomcat/.keystore	
RUN if [ "$ssl_enabled" = "true" ]; then sed -i 's+<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />+<Connector port="8443" SSLEnabled="true" clientAuth="false" maxThreads="150" protocol="org.apache.coyote.http11.Http11NioProtocol" keystoreFile="/tmp/tomcat/.keystore" keystorePass="'"$keystore_pass"'" scheme="https" secure="true" sslProtocol="TLS"/><Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />+g' /tmp/tomcat/conf/server.xml ; fi	
#COPY api/jacocoagent.jar /tmp/tomcat/webapps/jacocoagent.jar


FROM ${BASE_IMAGE}
ARG api_java_options
ENV java_options ${api_java_options}
ENV JAVA_OPTS ${java_options}
ENV JAVA_HOME=/java
ENV PATH="/java/bin:$PATH"

RUN mkdir -p /java \
	&& mkdir -p /app \
	&& mkdir -p /tomcat \
	&& mkdir -p /target
COPY --from=staging /etc/passwd /etc/passwd
COPY --from=staging /tmp/target /target/
COPY --from=staging /tmp/app /app/
COPY --from=staging /tmp/java /java/
COPY --from=staging /tmp/tomcat /tomcat/
EXPOSE 8080 
USER appuser
CMD ["/tomcat/bin/catalina.sh", "run"]