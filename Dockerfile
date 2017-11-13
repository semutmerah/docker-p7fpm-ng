FROM alpine:edge

MAINTAINER Rasyid Fahroni <rasyid@rasyidfahroni.com>

LABEL "contains"="nginx, php7"

ARG SERVER_NAME=web.local
ARG ERROR_REPORTING=E_ALL
ARG OPCACHE=1
ENV NGINX="/etc/nginx" PHP7="/etc/php7"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories;\
apk update;\
apk upgrade;\
apk add --no-cache openrc \
libseccomp \
wget \
nginx \
curl \
git \
php7-fpm \
php7-pdo \
php7-pdo_mysql \
php7-mysqlnd \
php7-mysqli \
php7-mcrypt \
php7-mbstring \
php7-ctype \
php7-zlib \
php7-gd \
php7-exif \
php7-intl \
php7-sqlite3 \
php7-xml \
php7-xsl \
php7-curl \
php7-openssl \
php7-iconv \
php7-json \
php7-phar \
php7-soap \
php7-dom \
php7-zip \
php7-session \
php7-opcache

RUN rm -Rf /etc/nginx/nginx.conf
ADD config/nginx/ $NGINX/
ADD ./start.sh /

RUN mkdir /run/nginx;\
mkdir /etc/nginx/sites-enabled/;\
sed -i "s/server_name .*/server_name ${SERVER_NAME};/" /etc/nginx/sites-available/default.conf;\
ln -s /etc/nginx/sites-available/* /etc/nginx/sites-enabled/;\
sed -i "s/user = .*/user = nginx/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/group = .*/group = www-data/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/listen = .*/listen = \/run\/php7.0-fpm.sock/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/;listen.owner = .*/listen.owner = nginx/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/;listen.group = .*/listen.group = www-data/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/;listen.mode = .*/listen.mode = 0660/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/;log_level = .*/log_level = warning/" /etc/php7/php-fpm.conf;\
sed -i "s/;emergency_restart_threshold = .*/emergency_restart_threshold = 10/" /etc/php7/php-fpm.conf;\
sed -i "s/;emergency_restart_interval = .*/emergency_restart_interval = 1m/" /etc/php7/php-fpm.conf;\
sed -i "s/;process_control_timeout = .*/process_control_timeout = 10s/" /etc/php7/php-fpm.conf;\
sed -i "s/error_reporting = .*/error_reporting = ${ERROR_REPORTING}/" /etc/php7/php.ini;\
sed -i "s/;cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/" /etc/php7/php.ini;\
sed -i "s/;opcache.enable=.*/opcache.enable=${OPCACHE}/" /etc/php7/php.ini;\
chmod +x /start.sh

EXPOSE 80 443

CMD ["/start.sh"]
