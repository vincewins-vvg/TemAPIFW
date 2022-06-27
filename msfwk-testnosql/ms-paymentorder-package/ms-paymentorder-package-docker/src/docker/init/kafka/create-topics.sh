#!/bin/bash
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#


if [[ -z "$KAFKA_CREATE_TOPICS" ]]; then
    exit 0
fi

while ! nc -z $KAFKA_HOST $KAFKA_PORT ; do
    echo "Waiting for Kafka on $KAFKA_HOST:$KAFKA_PORT"
    sleep 2
done

# Expected format:
#   name:partitions:replicas:cleanup.policy
IFS="${KAFKA_CREATE_TOPICS_SEPARATOR-,}"; for topicToCreate in $KAFKA_CREATE_TOPICS; do
    echo "creating topics: $topicToCreate"
    IFS=':' read -r -a topicConfig <<< "$topicToCreate"
    config=
    if [ -n "${topicConfig[3]}" ]; then
        config="--config=cleanup.policy=${topicConfig[3]}"
    fi
    COMMAND="JMX_PORT='' ${KAFKA_HOME}/bin/kafka-topics.sh \\
		--create \\
		--zookeeper ${KAFKA_ZOOKEEPER_CONNECT} \\
		--topic ${topicConfig[0]} \\
		--partitions ${topicConfig[1]} \\
		--replication-factor ${topicConfig[2]} \\
		${config} \\
		--if-not-exists &"
    eval "${COMMAND}"
done

wait
