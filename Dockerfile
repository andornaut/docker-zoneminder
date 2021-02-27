FROM zoneminderhq/zoneminder:latest-ubuntu18.04

ENV APACHE_DIR=/etc/apache2 \
    TZ=America/Toronto

HEALTHCHECK --interval=5m --timeout=10s \
    CMD test "$(zmpkg.pl status 2>&1|tail -n1)" = "running"

# Configure Apache. Redirect / to /zm/
RUN sed -i '/<\/VirtualHost>/Q' ${APACHE_DIR}/sites-enabled/000-default.conf \
    && echo 'RedirectMatch ^/$ /zm/' >> "${APACHE_DIR}/sites-enabled/000-default.conf" \
    && echo '</VirtualHost>' >> "${APACHE_DIR}/sites-enabled/000-default.conf" \
    && echo "ServerName localhost" >> ${APACHE_DIR}/apache2.conf

# Can be used to configure some settings
COPY settings.sql ./
