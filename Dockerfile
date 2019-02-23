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
    && echo -e "\nRedirectMatch ^/$ /zm\n</VirtualHost>" \
    >> "${APACHE_DIR}/sites-enabled/000-default.conf"

ADD 'https://raw.githubusercontent.com/ZoneMinder/zmdockerfiles/master/utils/entrypoint.sh' /zoneminder-entrypoint.sh
COPY entrypoint.sh init.sql /
RUN chmod 755 /entrypoint.sh /zoneminder-entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["zoneminder"]
