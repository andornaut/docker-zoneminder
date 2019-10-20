#!/bin/bash

set -e

init_zm_db(){
    # Wait long enough for a new mysql server to be initialized.
    sleep 15
    echo 'Updating initial "zm" database config'
    mysql -u root zm < /init.sql
}

if [[ -d /var/lib/mysql/zm ]]; then
    echo 'Skipping initial configuration, because "zm" database exists'
else
    init_zm_db &
fi

chown -R www-data:www-data /var/cache/zoneminder

case "$1" in
  zoneminder)
    rm -f /var/run/zm/zmaudit.pid
    exec /zoneminder-entrypoint.sh
    ;;
  *)
    exec "$@"
    ;;
esac
