FROM zoneminderhq/zoneminder:latest-ubuntu18.04

ENV APACHE_DIR=/etc/apache2 \
    TZ=America/Toronto

HEALTHCHECK --interval=5m --timeout=10s \
    CMD test "$(zmpkg.pl status 2>&1|tail -n1)" = "running"

# TODO remove once this is merged:
# https://github.com/ZoneMinder/zmdockerfiles/pull/80
RUN sed -i 's/34/36/g' /etc/apt/sources.list.d/zoneminder.list \
    && apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends \
        zoneminder \
    && apt-get clean

# Configure Apache. Redirect / to /zm/
RUN sed -i '/<\/VirtualHost>/Q' ${APACHE_DIR}/sites-enabled/000-default.conf \
    && echo 'RedirectMatch ^/$ /zm/' >> "${APACHE_DIR}/sites-enabled/000-default.conf" \
    && echo '</VirtualHost>' >> "${APACHE_DIR}/sites-enabled/000-default.conf" \
    && echo "ServerName localhost" >> ${APACHE_DIR}/apache2.conf

# Can be used to configure some settings
# Install with: `cat settings.sql|mysql zm`
COPY settings.sql ./

# Workaround: https://github.com/ZoneMinder/zmdockerfiles/pull/75
RUN sed -i 's|zoneminder/zm|zm/|g' /usr/local/bin/entrypoint.sh

# Workaround: https://github.com/ZoneMinder/zmdockerfiles/issues/79
COPY entrypoint-workaround.sh /usr/local/bin/entrypoint-workaround.sh
RUN chmod +x /usr/local/bin/entrypoint-workaround.sh
ENTRYPOINT /usr/local/bin/entrypoint-workaround.sh
