FROM phusion/baseimage

EXPOSE 80 3306

CMD ["/sbin/my_init"]

ENV MYSQL_USER=zmuser \
	MYSQL_PASS=zmpass

RUN apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends \
		apache2 \
		curl \
		ffmpeg \
		libvlc-dev \
		libvlccore-dev \
		software-properties-common \
		vim \
	&& add-apt-repository ppa:iconnor/zoneminder \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install zoneminder \
	&& apt-get clean \
	&& rm -rf /tmp/* /var/tmp/*  \
	&& rm -rf /var/lib/apt/lists/*

# Mysql
RUN rm /etc/mysql/my.cnf \
	&& cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf \
	&& sed -i '/\[mysqld\]/a sql_mode = NO_ENGINE_SUBSTITUTION' /etc/mysql/my.cnf \
	&& mkdir -p /var/run/mysqld/ \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld/

# Apache2 and Zoneminder
RUN chown root:www-data /etc/zm/zm.conf \
	&& chown -R www-data:www-data /usr/share/zoneminder/ \
	&& sed -i '/[\Date\]/a date.timezone = America\/Toronto' /etc/php/7.0/apache2/php.ini \
	&& sed -i '/ServerAdmin/a \\tServerName localhost' /etc/apache2/sites-enabled/000-default.conf \
	&& a2enconf zoneminder \
	&& a2enmod cgi rewrite

RUN mkdir -p /etc/service/apache2 /var/log/apache2 \
	&& touch /var/log/apache2.log \
	&& chown -R www-data /var/log/apache2.log /var/log/apache2
COPY apache2.sh /etc/service/apache2/run

RUN mkdir -p /etc/service/mysql /var/log/mysql \
	&& touch /var/log/mysql.log \
	&& chown -R mysql /var/log/mysql.log /var/log/mysql
COPY mysql.sh /etc/service/mysql/run

RUN mkdir -p /etc/service/zm /var/log/zm \
	&& touch /var/log/zm.log \
	&& chown -R www-data /var/log/zm.log /var/log/zm
COPY zm.sh /etc/service/zm/run

RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh

VOLUME /var/lib/mysql
