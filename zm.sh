#!/bin/bash

set -ex

sv check mysql

waitSeconds=5
echo "Starting Zoneminder in ${waitSeconds} seconds"
sleep ${waitSeconds}

mysql -u root < /usr/share/zoneminder/db/zm_create.sql
mysql -u root -e "grant select,insert,update,delete,create,alter,index,lock tables on zm.* to '${MYSQL_USER}'@localhost identified by '${MYSQL_PASS}';"
mysql -u root zm < /config.sql

exec /sbin/setuser www-data /usr/bin/zmpkg.pl start 2>&1
