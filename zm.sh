#!/bin/bash
### In zm.sh (make sure this file is chmod +x):
# `chpst -u root` runs the given command as the user `root`.
# If you omit that part, the command will be run as root.

sleep 7s

mysql -u root < /usr/share/zoneminder/db/zm_create.sql
mysql -u root -e "grant select,insert,update,delete,create,alter,index,lock tables on zm.* to '${MYSQL_USER}'@localhost identified by '${MYSQL_PASS}';"
mysql -u root -e "grant select,insert,update,delete,create,alter,index,lock tables on zm.* to '${MYSQL_USER}'@'%' identified by '${MYSQL_PASS}';"

exec /sbin/setuser www-data /usr/bin/zmpkg.pl start >>/var/log/zm.log 2>&1
