ARG DB_BASE_INIT_IMAGE
FROM ${DB_BASE_INIT_IMAGE}

# Copy wrapper to create keyspace and tables
COPY dynamodb_setup.sh /dynamodb_setup.sh

RUN chmod +x /dynamodb_setup.sh

# Update the entry point for this image
ENTRYPOINT ["/dynamodb_setup.sh"]
