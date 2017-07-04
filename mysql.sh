#!/bin/bash

set -ex

if [[ ! -e /var/lib/mysql/ibdata1 ]]; then
	echo Initializing new Mysql installation
	/usr/sbin/mysqld --initialize-insecure
fi

exec /sbin/setuser mysql /usr/bin/mysqld_safe --syslog
