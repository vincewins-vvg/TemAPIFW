ARG DB_BASE_IMAGE
FROM ${DB_BASE_IMAGE}

# Switch to root user for access to apt-get install
USER root

RUN apt update

RUN apt install ca-certificates

# Install node/npm
RUN apt-get -y update  && \
        apt-get install -y curl && \
        curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
        apt-get install -y nodejs && \
        apt-get install -y dos2unix

# Install tedious, the driver for SQL Server for Node.js
RUN npm install tedious


# Bundle app source
COPY . /usr/src/app

RUN dos2unix *

# Grant permissions for the import-data script to be executable
RUN chmod +x /usr/src/app/import-data.sh

EXPOSE 1433

# Switch back to mssql user and run the entrypoint script
USER mssql
ENTRYPOINT /bin/bash /usr/src/app/entrypoint.sh


