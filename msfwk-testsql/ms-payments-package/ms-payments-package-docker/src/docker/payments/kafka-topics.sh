#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

##############################################################################################################

# -- PLEASE RUN THESE STEPS INSIDE THE KUBERNETES KAFKA CONTAINER TO CREATE KAFKA TOPICS


###############################################################################################################
export PAYMENTS_AVRO_TOPIC=table-update-paymentorder
export PAYMENTS_AVRODATA_TOPIC=table-update
export PAYMENTS_OUTBOX_TOPIC=paymentorder-outbox
export EVENTSTORE_TOPIC=ms-eventstore-inbox-topic
export PAYMENTS_INBOX_TOPIC=ms-paymentorder-inbox-topic
export PAYMENTS_EVENT_TOPIC=paymentorder-event-topic
export PAYMENTS_ERROR_TOPIC=error-paymentorder
export PAYMENTS_INBOX_ERROR_TOPIC=ms-paymentorder-inbox-error-topic
export PAYMENTS_MULTIPART_TOPIC=multipart-topic

export BOOTSTRAP_URL="my-cluster-kafka-bootstrap.kafka:9092"

export REPLICATION_FACTOR=3

export PARTITION=3


## ./bin/kafka-topics.sh --create --bootstrap-server <bootstrapURL> --replication-factor <repl_factor> --partitions <partition> --topic <topic-name>

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTS_AVRO_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTS_AVRODATA_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTS_OUTBOX_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $EVENTSTORE_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTS_INBOX_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTS_EVENT_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTS_ERROR_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTS_INBOX_ERROR_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTS_MULTIPART_TOPIC


##############################################################################################################

# -- PLEASE RUN THE BELOW COMMAND INSIDE THE KUBERNETES KAFKA CONTAINER TO LIST THE TOPICS PRESENT


###############################################################################################################




./bin/kafka-topics.sh --list --bootstrap-server  $BOOTSTRAP_URL