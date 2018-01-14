#!/bin/bash

set -ex

# Set volume ownership
# https://github.com/ZoneMinder/ZoneMinder/blob/master/utils/docker/setup.sh#L66
chown -R mysql:mysql /var/lib/mysql
chown -R www-data:www-data /var/cache/zoneminder/events /var/cache/zoneminder/images /tmp/zoneminder-tmpfs
