#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#
##############################################################################################################

# -- PLEASE RUN THESE STEPS INSIDE THE KUBERNETES KAFKA CONTAINER TO CREATE KAFKA TOPICS


###############################################################################################################

export PAYMENTORDER_TABLE_UPDATE_TOPIC=table-update-paymentorder
export PAYMENTORDER_OUTBOX_TOPIC=paymentorder-outbox
export EVENTSTORE_INBOX_TOPIC=ms-eventstore-inbox-topic
export PAYMENTORDER_INBOX_TOPIC=ms-paymentorder-inbox-topic
export PAYMENTORDER_EVENT_TOPIC=paymentorder-event-topic
export PAYMENTORDER_ERROR_TOPIC=error-paymentorder
export PAYMENTORDER_INBOX_ERROR_TOPIC=ms_paymentorder-inbox-error-topic
export PAYMENTORDER_MULTIPART_TOPIC=multipart-topic

export BOOTSTRAP_URL="my-cluster-kafka-bootstrap.kafka:9092"

export REPLICATION_FACTOR=3

export PARTITION=3


## ./bin/kafka-topics.sh --create --bootstrap-server <bootstrapURL> --replication-factor <repl_factor> --partitions <partition> --topic <topic-name>

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTORDER_TABLE_UPDATE_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTORDER_OUTBOX_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $EVENTSTORE_INBOX_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTORDER_INBOX_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTORDER_EVENT_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTORDER_ERROR_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTORDER_INBOX_ERROR_TOPIC

./bin/kafka-topics.sh --create --bootstrap-server $BOOTSTRAP_URL --replication-factor $REPLICATION_FACTOR --partitions $PARTITION --topic $PAYMENTORDER_MULTIPART_TOPIC

##############################################################################################################

# -- PLEASE RUN THE BELOW COMMAND INSIDE THE KUBERNETES KAFKA CONTAINER TO LIST THE TOPICS PRESENT


###############################################################################################################




./bin/kafka-topics.sh --list --bootstrap-server  $BOOTSTRAP_URL