#!/bin/bash

set -e

waitSeconds=5
echo "Starting Zoneminder in ${waitSeconds} seconds"
sleep ${waitSeconds}

sv check mysql

mysql -u root < /usr/share/zoneminder/db/zm_create.sql
mysql -u root -e "GRANT select,insert,update,delete,create,alter,index,lock tables ON zm.* TO '${MYSQL_USER}'@localhost IDENTIFIED BY '${MYSQL_PASS}';"
mysql -u root zm < /config.sql

exec /sbin/setuser www-data /usr/bin/zmpkg.pl start 2>&1
