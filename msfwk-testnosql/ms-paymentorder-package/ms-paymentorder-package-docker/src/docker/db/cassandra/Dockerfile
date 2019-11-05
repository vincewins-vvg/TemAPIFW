ARG DB_BASE_IMAGE
FROM ${DB_BASE_IMAGE}

# Copy wrapper to create keyspace and tables
COPY entrypoint-wrap.sh /entrypoint-wrap.sh

# Copy the CQL Script
COPY ./DDL.cql /.

# Update the entry point for this image
ENTRYPOINT ["/entrypoint-wrap.sh"]

CMD ["cassandra", "-f"]