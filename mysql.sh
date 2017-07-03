#!/bin/bash

if [[ ! "$(ls -A /var/lib/mysql)" ]]; then
	echo Initializing new Mysql installation
	/sbin/setuser mysql /usr/sbin/mysqld --initialize-insecure --user=mysql 2>&1 
fi

exec /sbin/setuser mysql /usr/bin/mysqld_safe 2>&1 
