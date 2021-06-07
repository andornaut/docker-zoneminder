#!/bin/bash

# Prevent error:
# Cannot write to event folder /var/cache/zoneminder/events
chown -R www-data:www-data /var/cache/zoneminder/*

# Workaround this bug:
# https://github.com/ZoneMinder/zmdockerfiles/issues/79
rm -rf /run/zm/*

exec /usr/local/bin/entrypoint.sh
