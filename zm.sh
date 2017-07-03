#!/bin/bash

set -e

waitSeconds=3
echo "Starting Zoneminder in ${waitSeconds} seconds"
sleep ${waitSeconds}

sv check mysql

if [[ ! -d /var/lib/mysql/zm ]]; then
    echo 'Initializing "zm" database'
    mysql -u root < /usr/share/zoneminder/db/zm_create.sql
    mysql -u root -e "GRANT select,insert,update,delete,create,alter,index,lock tables ON zm.* TO '${DB_USER}'@localhost IDENTIFIED BY '${DB_PASS}';"
    mysql -u root zm < /config.sql
fi

exec /sbin/setuser www-data /usr/bin/zmpkg.pl start 2>&1
