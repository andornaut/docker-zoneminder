#!/bin/bash

set -e

# Set volume ownership
# https://github.com/ZoneMinder/ZoneMinder/blob/master/utils/docker/setup.sh#L66
chown -R mysql:mysql /var/lib/mysql
chown -R www-data:www-data /var/lib/zoneminder/events /var/lib/zoneminder/images
