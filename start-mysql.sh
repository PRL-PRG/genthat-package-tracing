#!/bin/bash
set -e

DB_DIR=$(pwd)/data

# initialize the data dir
[ -d $DB_DIR ] || mkdir -p $DB_DIR

# start mysql
docker run \
       -p 6612:3306 \
       -v $DB_DIR:/var/lib/mysql \
       --name genthat-mysql \
       -e MYSQL_ROOT_PASSWORD=genthat \
       -e MYSQL_DATABASE=genthat \
       -e MYSQL_USER=genthat \
       -e MYSQL_PASSWORD=genthat \
       -d mysql:latest

# wait for mysql
docker run --rm --link genthat-mysql:mysql digit/wait-for-mysql
