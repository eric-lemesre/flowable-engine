#!/usr/bin/env bash

#DATABASE=db2
#DATABASE=h2mem
#DATABASE=mysql
#DATABASE=oracle
DATABASE=postgresql
#DATABASE=sqlserver

export DATABASE
echo "current database is $DATABASE"
echo "you can set database in FLOWABLE_HOME/scripts/database-env.sh"
