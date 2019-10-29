ARG DB_BASE_IMAGE
FROM ${DB_BASE_IMAGE}

# Add a database
ENV MYSQL_DATABASE payments

# Add the content of the ddl-scripts/ directory to your image
# All scripts in docker-entrypoint-initdb.d/ are automatically
# executed during container startup, enable below line before 
# adding any scripts
# COPY ./ddl-scripts/ /docker-entrypoint-initdb.d/