#!/bin/sh
#exec chroot --userspec=mysql /usr/bin/mysqld_safe 2>&1 
exec /sbin/setuser mysql /usr/bin/mysqld_safe >>/var/log/mysql.log 2>&1 
