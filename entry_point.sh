#!/bin/bash

set -e 

sleep 3

gradle test

./scripts/pgsql_restore.sh 2020-08-19.dump

cd /usr/local/tomcat/bin

./catalina.sh run
