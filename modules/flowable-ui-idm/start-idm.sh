#!/usr/bin/env bash
# retain current dir
CURRENT_DIR=$(pwd)
# find flowable home
FLOWABLE_HOME=$(readlink -f `pwd`/$(dirname $0)/../../)

cd ${FLOWABLE_HOME}
echo "Building all submodules in ${FLOWABLE_HOME}"
mvn -T 1C clean install -DskipTests
STATUS=$?
if [ $STATUS -eq 0 ]
then
	cd ${FLOWABLE_HOME}/modules/flowable-ui-idm-app

	# Run war
	export MAVEN_OPTS="$MAVEN_OPTS -noverify -Xms512m -Xmx1024m -Xdebug -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8002,server=y,suspend=n"
	mvn clean install -Ppostgresql -DskipTests spring-boot:run
else
    echo "Error while building root pom. Halting."
fi

cd ${CURRENT_DIR}