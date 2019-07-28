#!/usr/bin/env bash

DATABASE=postgresql
TOMCAT=tomcat9
CATALINA_HOME=/var/lib/${TOMCAT}

# define maven options
export MAVEN_OPTS="-Xms1024m -Xmx2048m -noverify "

# retain current dir
CURRENT_DIR=$(pwd)

# find flowable home
FLOWABLE_HOME=$(readlink -f `pwd`/$(dirname $0)/../)
DIR_LOG=${FLOWABLE_HOME}/log

if [ ! -d "${DIR_LOG}" ]; then
    mkdir -p ${DIR_LOG}
else
    # delete log file
    rm ${DIR_LOG}/build-{idm,modeler,admin,task}.log >/dev/null 2>&1
fi

# build all modules
${FLOWABLE_HOME}/scripts/build-all.sh

STATUS=$?
if [ $STATUS -eq 0 ]; then
    echo "stop ${TOMCAT}.service"
    sudo systemctl stop ${TOMCAT}.service

    for MODULE in idm modeler task admin; do
        echo -n "Building ${MODULE}.war in ${FLOWABLE_HOME}/modules/flowable-ui-${MODULE}"
        cd ${FLOWABLE_HOME}/modules/flowable-ui-${MODULE} && mvn clean install -P${DATABASE} -DskipTests >${DIR_LOG}/build-${MODULE}.log 2>&1
        STATUS_MODULE=$?

        if [ $STATUS_MODULE -eq 0 ]; then
            echo " ok"
            echo "clean war directory for flowable-${MODULE} in ${CATALINA_HOME}/{work,webapps}/flowable-${MODULE}"
            sudo rm -rf ${CATALINA_HOME}/{work,webapps}/flowable-${MODULE}
            echo "deploy war flowable-${MODULE} in ${CATALINA_HOME}/webapps/flowable-${MODULE}"
            sudo unzip -d ${CATALINA_HOME}/webapps/flowable-${MODULE} ${FLOWABLE_HOME}/modules/flowable-ui-${MODULE}/flowable-ui-${MODULE}-app/target/flowable-${MODULE}.war  >/dev/null 2>&1
        else
            echo " Ko, see log in ${DIR_LOG}/build-${MODULE}.log"
        fi
    done
    echo "start ${TOMCAT}.service"
    sudo systemctl start ${TOMCAT}.service
#    sudo tail -n50 -f /var/log/${TOMCAT}/catalina.out
    sudo systemctl status ${TOMCAT}.service

else
	say -v Cellos "Dum dum dum dum dum dum dum he he he ho ho ho fa lah lah lah lah lah lah fa lah full hoo hoo hoo"
    echo "Error while building root pom. Halting."
fi

cd ${CURRENT_DIR}
