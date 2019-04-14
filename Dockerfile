FROM ubuntu:18.04

ENV TZ=America/Toronto \
    APACHE_DIR=/etc/apache2

EXPOSE 80

HEALTHCHECK --interval=5m --timeout=10s \
    CMD test "$(zmpkg.pl status 2>&1|tail -n1)" = "running"

VOLUME /var/lib/mysql /var/cache/zoneminder/events /var/cache/zoneminder/images

RUN apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends software-properties-common \
    && add-apt-repository ppa:iconnor/zoneminder-1.32 \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install file zoneminder \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Disable serve-cgi-bin, b/c it takes over the root /cgi-bin ScriptAlias
RUN echo "ServerName localhost" >> ${APACHE_DIR}/apache2.conf \
    && a2enconf zoneminder \
    && a2enmod cgi rewrite \
    && a2disconf serve-cgi-bin

# Send logs to stdout/stderr
RUN sed -ri \
    -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
    -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
    -e 's!^(\s*TransferLog)\s+\S+!\1 /proc/self/fd/1!g' \
    "${APACHE_DIR}/apache2.conf" \
    "${APACHE_DIR}/sites-enabled/000-default.conf"

# Delete all lines starting with </VirtualHost>, then redirect / to /zm
RUN sed -i '/<\/VirtualHost>/Q' ${APACHE_DIR}/sites-enabled/000-default.conf \
    && echo 'RedirectMatch ^/$ /zm' >> "${APACHE_DIR}/sites-enabled/000-default.conf" \
    && echo '</VirtualHost>' >> "${APACHE_DIR}/sites-enabled/000-default.conf"

# Update ZM config
# TODO implement fix https://github.com/ZoneMinder/zoneminder/commit/567b60ffa76b60b244a8731090521b58fb070779
RUN sed -ie 's|\(ZM_PATH_MAP=\).*|\1/dev/shm|g' /etc/zm/conf.d/zmcustom.conf \
    && sed -e 's|\(ZM_PATH_ZMS=\).*|\1/zm/cgi-bin/nph-zms|g' /etc/zm/conf.d/zmcustom.conf

ADD 'https://raw.githubusercontent.com/ZoneMinder/zmdockerfiles/master/utils/entrypoint.sh' /zoneminder-entrypoint.sh
COPY entrypoint.sh init.sql /
RUN chmod 755 /entrypoint.sh /zoneminder-entrypoint.sh && \
    mkdir /var/run/zm && \
    chown www-data:www-data /var/run/zm

ENTRYPOINT ["/entrypoint.sh"]
CMD ["zoneminder"]
