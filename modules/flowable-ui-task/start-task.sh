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
	cd ${FLOWABLE_HOME}/modules/flowable-ui-task-app

	# Run war
	export MAVEN_OPTS="$MAVEN_OPTS -noverify -Xms512m -Xmx1024m"
	mvn clean install -Ppostgresql -DskipTests spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8003"
else
	say -v Cellos "Dum dum dum dum dum dum dum he he he ho ho ho fa lah lah lah lah lah lah fa lah full hoo hoo hoo"
    echo "Error while building root pom. Halting."
fi

cd ${CURRENT_DIR}
