# --------------------------------------------------------------
# - Script for running the necessary jars associated with the Performance Profiling Tool
#Note: This script should be run only after running the tests associated with Performance
# --------------------------------------------------------------
export PO_HOME=`pwd`
export AGGREGATOR_DIR=$PO_HOME/aggregator
export PERFlOGS_DIR=$PO_HOME/perflogs

echo 'Moving API performance logs from docker env to perflogs folder in local'
docker cp ms-paymentorder-docker_api_1:usr/local/tomcat/logs/ $PERFlOGS_DIR

#Delete the logs which are not required
cd $PERFlOGS_DIR/logs
rm -r `ls | grep -v "^[0-9]\_"`

#Run the aggregator jar
java -jar $AGGREGATOR_DIR/bytecodecount-data-aggregator.jar