#!/bin/bash -x

export MSF_NAME=$1
export DATABASE=$2
mkdir -p ./app/repack/
cd app/repack/
echo $1

jar -xf ../${MSF_NAME}-package-aws* 
jar -xf ../../db/dbjars/${MSF_NAME}-entity-${DATABASE}.jar
jar -cfm ../${MSF_NAME}-package-aws* ./META-INF/MANIFEST.MF .  
cd ../
rm -rf repack
cd ../
