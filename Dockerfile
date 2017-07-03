FROM phusion/baseimage

ENV DB_USER=zmuser \
	DB_PASS=zmpass

EXPOSE 80

CMD ["/sbin/my_init", "--", "/zm.sh"]

RUN apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends \
		software-properties-common \
	&& add-apt-repository ppa:iconnor/zoneminder \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends \
	    apache2 \
		ffmpeg \
		libapache2-mod-php7.0 \
		libvlc-dev \
		libvlccore-dev \
		mysql-server \
		php-mysql \
		vlc-data \
		zoneminder \
	&& apt-get clean \
	&& rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Apache2 and Zoneminder
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && a2disconf serve-cgi-bin \
	&& a2enconf zoneminder \
	&& a2enmod cgi rewrite \
	&& adduser www-data video \
	&& mkdir -p /tmp/zoneminder-tmpfs /var/run/zm \
	&& chmod 740 /etc/zm/zm.conf \
	&& chown root:www-data /etc/zm/zm.conf \
	&& chown -R www-data:www-data /usr/share/zoneminder /var/run/zm \
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log \
	&& sed -i '/[\Date\]/a date.timezone = America\/Toronto' /etc/php/7.0/apache2/php.ini \
	&& sed -i 's|^\(\(\s\)*DocumentRoot\(\s\)*\).*|\1/usr/share/zoneminder/www|g' /etc/apache2/sites-enabled/000-default.conf \
	&& sed -i 's|\(ScriptAlias \)/zm/cgi-bin|\1/cgi-bin|g' /etc/apache2/conf-enabled/zoneminder.conf \
	&& sed -i 's|\(Alias /zm\)|#\1|g' /etc/apache2/conf-enabled/zoneminder.conf

# Mysql
RUN rm /etc/mysql/my.cnf \
	&& mkdir -p /var/run/mysqld/ \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld/ \
	&& cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf \
	&& sed -i '/\[mysqld\]/a sql_mode = NO_ENGINE_SUBSTITUTION' /etc/mysql/my.cnf \
	&& sed -i "s/\(ZM_DB_PASS\(\s\)*=\).*/\1${DB_PASS}/g" /etc/zm/zm.conf \
	&& sed -i "s/\(ZM_DB_USER\(\s\)*=\).*/\1${DB_USER}/g" /etc/zm/zm.conf

COPY apache2.sh /etc/service/apache2/run
COPY mysql.sh /etc/service/mysql/run
COPY config.sql zm.sh /
COPY pre.sh /etc/my_init.d/

# https://github.com/ZoneMinder/ZoneMinder/blob/master/Dockerfile#L103
VOLUME /var/lib/mysql /var/lib/zoneminder/events  /var/lib/zoneminder/images
