#!/bin/bash
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#


if [[ ! -z "$CASSANDRA_KEYSPACE" && $1 = 'cassandra' ]]; then
  # Create default keyspace for single node cluster
  CQL="CREATE KEYSPACE $CASSANDRA_KEYSPACE WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};"
  until echo $CQL | cqlsh; do
    echo "cqlsh: Cassandra is unavailable for keyspace creation - retry later"
    sleep 2
  done &
  
  # Create tables
  until cqlsh -f DDL.cql; do
    echo "cqlsh: Cassandra is unavailable for table creation - retry later"
    sleep 2
  done &
fi

exec /docker-entrypoint.sh "$@"