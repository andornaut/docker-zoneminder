#!/bin/bash

# Prevent error:
# Cannot write to event folder /var/cache/zoneminder/events
chown -R www-data:www-data /var/cache/zoneminder/events/

# Workaround this bug:
# https://github.com/ZoneMinder/zmdockerfiles/issues/79
exec /usr/local/bin/entrypoint.sh
