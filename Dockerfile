FROM zoneminderhq/zoneminder:latest-ubuntu18.04

ENV TZ=America/Toronto \
    APACHE_DIR=/etc/apache2

# Uninstall zoneminder 1.32
RUN DEBIAN_FRONTEND=noninteractive apt-get remove --purge -qq zoneminder*

# Configure the zoneminder 1.34 PPA
RUN echo deb http://ppa.launchpad.net/iconnor/zoneminder-1.34/ubuntu bionic main > /etc/apt/sources.list.d/zoneminder.list \
    && apt-get -qq update

# Install zoneminder 1.34 (and disable serve-cgi-bin, because it takes over the root /cgi-bin ScriptAlias)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qq zoneminder \
    && a2enconf zoneminder \
    && a2enmod rewrite cgi \
    && a2disconf serve-cgi-bin

HEALTHCHECK --interval=5m --timeout=10s \
    CMD test "$(zmpkg.pl status 2>&1|tail -n1)" = "running"

# Configure Apache. Redirect / to /zm/
RUN sed -i '/<\/VirtualHost>/Q' ${APACHE_DIR}/sites-enabled/000-default.conf \
    && echo 'RedirectMatch ^/$ /zm/' >> "${APACHE_DIR}/sites-enabled/000-default.conf" \
    && echo '</VirtualHost>' >> "${APACHE_DIR}/sites-enabled/000-default.conf" \
    && echo "ServerName localhost" >> ${APACHE_DIR}/apache2.conf

# Can be used to configure some settings
COPY settings.sql ./
