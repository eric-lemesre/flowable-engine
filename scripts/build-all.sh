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

echo "Building all submodules in ${FLOWABLE_HOME}"

cd ${FLOWABLE_HOME}
mvn -Pdistro clean install -DskipTests >${DIR_LOG}/build-modules.log 2>&1

cd ${CURRENT_DIR}