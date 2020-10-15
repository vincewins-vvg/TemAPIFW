# --------------------------------------------------------------
# - Script for pre configuring the environment by downloading the necessary jars for running the Performance Profiling tool
#Note: This script should be run after starting all the docker containers using paymentorder-performance sh/bat
# --------------------------------------------------------------

export PO_HOME=`pwd`
export AGGREGATOR_DIR=$PO_HOME/aggregator

echo 'Downloading and moving logger, agent and aggregator jars to its respective locations'
# Download Logger and Agent jar and move it to ms-paymentorder-Docker/app/api path
mvn dependency:get -Dartifact=com.temenos.profiler:bytecodecount-logger:1.0.0-SNAPSHOT:jar -U
mvn dependency:get -Dartifact=com.temenos.profiler:bytecodecount-agent:1.0.0-SNAPSHOT:jar -U
mvn dependency:copy -Dartifact=com.temenos.profiler:bytecodecount-logger:1.0.0-SNAPSHOT:jar -DoutputDirectory=$PO_HOME/app/api -Dmdep.stripVersion=true -U
mvn dependency:copy -Dartifact=com.temenos.profiler:bytecodecount-agent:1.0.0-SNAPSHOT:jar -DoutputDirectory=$PO_HOME/app/api -Dmdep.stripVersion=true -U

# Download aggregator jar under AGGREGATOR_DIR folder
mvn dependency:get -Dartifact=com.temenos.profiler:bytecodecount-data-aggregator:1.0.0-SNAPSHOT:jar -U
mvn dependency:copy -Dartifact=com.temenos.profiler:bytecodecount-data-aggregator:1.0.0-SNAPSHOT:jar -DoutputDirectory=$AGGREGATOR_DIR -Dmdep.stripVersion=true -U

echo 'Waiting for all jars to download...'
sleep 60


echo 'Overwriting bytecodecount-aggregator.properties in the aggregator jar '
#Move bytecodecount-aggregator.properties to the location of the aggregator jar
mv $PO_HOME/bytecodecount-aggregator.properties $AGGREGATOR_DIR

#Overwrite bytecodecount-aggregator.properties from the ms-paymentorder-Docker pack to the location in the aggregator jar
cd $AGGREGATOR_DIR
jar uf bytecodecount-data-aggregator.jar bytecodecount-aggregator.properties