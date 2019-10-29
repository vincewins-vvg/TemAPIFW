FROM openjdk:8-jre-alpine
ARG kafka_version
ARG kafka_package
WORKDIR /app
COPY create-topics.sh /app/
RUN apk update \
&& apk add bash \
&& apk add wget \
&& wget http://www-us.apache.org/dist/kafka/${kafka_version}/${kafka_package}.tgz \
&& tar xzf ${kafka_package}.tgz
ENV KAFKA_HOME=/app/${kafka_package} PATH=$PATH:.
RUN chmod +x /app/create-topics.sh

ENTRYPOINT ["create-topics.sh"]
