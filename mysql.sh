#!/bin/bash

if [[ ! "$(ls -A /var/lib/mysql)" ]]; then
	echo Initializing new Mysql installation
	/sbin/setuser mysql /usr/sbin/mysqld --syslog --initialize-insecure --user=mysql 2>&1
fi

exec /sbin/setuser mysql /usr/bin/mysqld_safe --syslog 2>&1
