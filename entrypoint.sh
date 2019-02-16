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

case "$1" in
  zoneminder)
    exec /zoneminder-entrypoint.sh
    ;;
  *)
    exec "$@"
    ;;
esac