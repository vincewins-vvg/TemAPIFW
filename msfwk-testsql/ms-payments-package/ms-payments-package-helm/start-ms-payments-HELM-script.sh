#!/bin/bash -e
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

if [ -z "$_doDeploy" ]; then export _doDeploy=$1 ;fi
if [ "${_doDeploy}" = true ]; then export _doHelm="deploy" ;fi
if [ "${_doDeploy}" = false ]; then export _doHelm="install" ;fi

cd ../ms-payments-package-docker/src/docker

# Update file permissions & format conversion
chmod -R 755 *
find . -name '*.sh' | xargs dos2unix

#STEP1: packk8SQLZip -- To get the folder structure for SQL Helm pack
./packk8SQL.sh build

#STEP2: mvn assembly plugin -- To generate zip for SQL Helm pack
cd ../../
mvn -f sql-helm-pom.xml ${_doHelm}