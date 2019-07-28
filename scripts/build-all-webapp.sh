#!/usr/bin/env bash
# retain current dir
CURRENT_DIR=$(pwd)
# find flowable home
FLOWABLE_HOME=$(readlink -f `pwd`/$(dirname $0)/../)
DIR_LOG=${FLOWABLE_HOME}/log
if [ ! -d "${DIR_LOG}" ]; then
    mkdir -p ${DIR_LOG}
else
    # delete log file
    rm ${DIR_LOG}/build-modules.log >/dev/null 2>&1
fi

if [ ! -d "${FLOWABLE_HOME}/target" ]; then
    mkdir -p ${FLOWABLE_HOME}/target
else
    # delete log file
    rm ${FLOWABLE_HOME}/target/*.war >/dev/null 2>&1
fi

echo "Building all webapps in ${FLOWABLE_HOME}/target"

cd ${FLOWABLE_HOME}
for module in flowable-ui-admin flowable-ui-idm flowable-ui-modeler flowable-ui-task; do \
    cd ${FLOWABLE_HOME}/modules/$module
    echo "building $module"
    mvn package -Ppostgresql >>${DIR_LOG}/build-webapps.log 2>&1
    echo "copy war $module in ${FLOWABLE_HOME}/target"
    cp ${FLOWABLE_HOME}/modules/$module/$module-app/target/*.war ${FLOWABLE_HOME}/target
    cd ${FLOWABLE_HOME}
done


cd ${CURRENT_DIR}
