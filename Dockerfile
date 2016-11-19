FROM alpine:edge

MAINTAINER Rasyid Fahroni <rasyid@rasyidfahroni.com>

LABEL "contains"="nginx, php7"

ENV NGINX /etc/nginx
ENV PHP7 /etc/php7
ENV error_reporting E_ALL

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories;\
apk update;\
apk upgrade;\
apk --no-cache add openrc \
libseccomp \
nginx \
php7-fpm \
php7-curl \
php7-gd \
php7-mysqli \
php7-session \
php7-zlib \
php7-opcache \
php7-xml \
nano

COPY config/nginx/ $NGINX/
COPY ./start.sh /

RUN mkdir /run/nginx;\
ln -s /etc/nginx/sites-available/* /etc/nginx/sites-enabled/;\
sed -i "s/user = .*/user = nginx/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/group = .*/group = www-data/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/listen = .*/listen = \/run\/php7.0-fpm.sock/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/;listen.owner = .*/listen.owner = nginx/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/;listen.group = .*/listen.group = www-data/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/;listen.mode = .*/listen.mode = 0640/" /etc/php7/php-fpm.d/www.conf;\
sed -i "s/;log_level = .*/log_level = warning/" /etc/php7/php-fpm.conf;\
sed -i "s/;emergency_restart_threshold = .*/emergency_restart_threshold = 10/" /etc/php7/php-fpm.conf;\
sed -i "s/;emergency_restart_interval = .*/emergency_restart_interval = 1m/" /etc/php7/php-fpm.conf;\
sed -i "s/;process_control_timeout = .*/process_control_timeout = 10s/" /etc/php7/php-fpm.conf;\
sed -i "s/error_reporting = .*/error_reporting = ${error_reporting}/" /etc/php7/php.ini;\
sed -i "s/;cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/" /etc/php7/php.ini;\
sed -i "s/;opcache.enable=.*/opcache.enable=1/" /etc/php7/php.ini;\
chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
