ARG DB_BASE_IMAGE
FROM ${DB_BASE_IMAGE}

# Copy wrapper to create keyspace and tables
COPY mongo_setup.sh /mongo_setup.sh

RUN chmod +x /mongo_setup.sh
# Update the entry point for this image
ENTRYPOINT ["/mongo_setup.sh"]
