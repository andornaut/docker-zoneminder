#!/bin/bash

set -e

waitSeconds=3

echo 'Waiting for Mysql'
sv check mysql
echo "Starting Zoneminder in ${waitSeconds} seconds"
sleep ${waitSeconds}

mysql -u root < /usr/share/zoneminder/db/zm_create.sql
mysql -u root -e "grant select,insert,update,delete,create,alter,index,lock tables on zm.* to '${MYSQL_USER}'@localhost identified by '${MYSQL_PASS}';"
mysql -u root zm < /config.sql

# Settings rights for volume
# https://github.com/ZoneMinder/ZoneMinder/blob/master/utils/docker/setup.sh#L66
chown -R www-data:www-data /var/lib/zoneminder/events
chown -R www-data:www-data /var/lib/zoneminder/images

exec /sbin/setuser www-data /usr/bin/zmpkg.pl start >>/var/log/zm.log 2>&1
