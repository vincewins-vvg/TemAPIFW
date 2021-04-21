#!/bin/bash -e
# --------------------------------------------------------------
# - Script to start Traceability Service
# --------------------------------------------------------------

if [ -z "$_pack" ]; then export _pack=$1 ;fi
if [ -z "$_archievefilename" ]; then export _archievefilename=$2 ;fi
if [ -z "$_dockercommand" ]; then export _dockercommand=$3 ;fi
if [ -z "$_msfname" ]; then export _msfname=${MSF_NAME} ;fi
if [ -z "$_database" ]; then export _database=${DATABASE} ;fi


# retriving archive file extension
if [ -z "$_archievefileext" ]; then export _archievefileext=${_archievefilename: -3} ;fi

if [ ${_dockercommand} != "down" ] 
then 
	if [ ${_archievefileext} == "war" ] 
	then 
	    mkdir -p ${_pack}/WEB-INF && mkdir -p ${_pack}/WEB-INF/lib 
        cp app/dbjars/${_msfname}-entity-${_database}.jar ${_pack}/WEB-INF/lib/ms-entity.jar
        cd app/api
        jar -uvf ${_archievefilename} WEB-INF/lib/ms-entity.jar
        cd ../../
        rm -rf ${_pack}/WEB-INF 	
    fi  
   
    if [ ${_archievefileext} == "jar" ] 
	then 
      mkdir -p ${_pack}/repack 
      cp ${_pack}/${_archievefilename} ${_pack}/repack/ 	  
      cd ${_pack}/repack
      jar xf ${_archievefilename}
      rm ${_archievefilename}
      cp ../../dbjars/${_msfname}-entity-${_database}.jar BOOT-INF/lib/ms-entity.jar 	  
      jar -cfm0 ../${_archievefilename} META-INF/MANIFEST.MF .
      cd ../../../ 
      rm -rf  ${_pack}/repack
    fi   
fi 