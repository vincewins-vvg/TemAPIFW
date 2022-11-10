#!/bin/bash -e
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

if [ -z "$_doDeploy" ]; then export _doDeploy=$1 ;fi
if [ "${_doDeploy}" = true ]; then export _doHelm="deploy" ;fi
if [ "${_doDeploy}" = false ]; then export _doHelm="install" ;fi

cd ../ms-paymentorder-package-docker/src/docker

# Update file permissions & format conversion
chmod -R 755 *
find . -name '*.sh' | xargs dos2unix

#STEP1: packMongoK8Zip -- To get the folder structure for NoSQL Mongo Helm pack
./packMongoK8Zip.sh build

#STEP2: mvn assembly plugin -- To generate zip for NoSQL Mongo Helm pack
cd ../../
mvn -f mongo-helm-pom.xml ${_doHelm}

#STEP3: packPostgresqlK8Zip -- To get the folder structure for NoSQL Postgres Helm pack
cd src/docker
./packPostgresqlK8Zip.sh build

#STEP4: mvn assembly plugin -- To generate zip for NoSQL Postgres Helm pack
cd ../../
mvn -f postgres-helm-pom.xml ${_doHelm}