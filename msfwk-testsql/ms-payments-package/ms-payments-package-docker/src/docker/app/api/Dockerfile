ARG API_BASE_IMAGE
FROM ${API_BASE_IMAGE}

ARG api_artifactid
ARG api_java_options
ARG ssl_enabled
ARG keystore_pass

ENV artifactid ${api_artifactid}
ENV java_options ${api_java_options}
ENV JAVA_OPTS ${java_options}

COPY ${artifactid} /usr/local/tomcat/webapps/${artifactid}

#COPY jacocoagent.jar /usr/local/tomcat/webapps/jacocoagent.jar

COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh
RUN sed -i 's/\r//' /wait-for-it.sh
COPY .keystore/.keystore /usr/local/tomcat/etc/ssl/certs/.keystore

RUN if [ "$ssl_enabled" = "true" ]; then sed -i 's+<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />+<Connector port="8443" SSLEnabled="true" clientAuth="false" maxThreads="150" protocol="org.apache.coyote.http11.Http11NioProtocol" keystoreFile="/usr/local/tomcat/etc/ssl/certs/.keystore" keystorePass="'"$keystore_pass"'" scheme="https" secure="true" sslProtocol="TLS"/><Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />+g' /usr/local/tomcat/conf/server.xml ; fi
