FROM ubuntu:18.04

ENV TZ=America/Toronto

EXPOSE 80

HEALTHCHECK --interval=5m --timeout=10s \
    CMD test "$(zmpkg.pl status 2>&1|tail -n1)" = "running"

VOLUME /var/lib/mysql /var/lib/zoneminder/events /var/lib/zoneminder/images

RUN apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends software-properties-common \
    && add-apt-repository ppa:iconnor/zoneminder-1.32 \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install file zoneminder \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && a2enconf zoneminder \
    && a2enmod cgi rewrite

RUN sed -i 's|/zm/|/|g' /etc/apache2/conf-enabled/zoneminder.conf \
    && sed -i 's|Alias /zm /usr/share/zoneminder/www|Alias / /usr/share/zoneminder/www/|g' /etc/apache2/conf-enabled/zoneminder.conf
    
ADD 'https://raw.githubusercontent.com/ZoneMinder/zmdockerfiles/master/utils/entrypoint.sh' /zoneminder-entrypoint.sh
COPY entrypoint.sh init.sql /
RUN chmod 755 /entrypoint.sh /zoneminder-entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["zoneminder"]
