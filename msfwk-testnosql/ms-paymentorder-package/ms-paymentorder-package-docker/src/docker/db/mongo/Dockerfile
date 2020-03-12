ARG DB_BASE_IMAGE
FROM ${DB_BASE_IMAGE}

ENTRYPOINT ["/usr/bin/mongod", "--bind_ip_all", "--replSet", "ms-mongo-set"]