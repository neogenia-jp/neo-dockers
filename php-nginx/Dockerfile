FROM centos:7.9.2009

LABEL vendor     "Neogenia Ltd."
LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

# support tools
RUN yum install -y yum-utils vim git zip unzip

# install nginx
RUN rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm \
 && yum install -y nginx

# install PHP 7.2 with some extensions
ARG PHP_VERSION=72
RUN yum install -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
 && yum-config-manager --enable remi-php${PHP_VERSION} \
 && yum install -y php \
                   php-mbstring \
                   php-gd \
                   php-xml \
                   php-cli \
                   php-mysqlnd \
                   php-mcrypt \
                   php-opcache php-pecl-apcu php-fpm \
                   php-pecl-xdebug

# install composer
ARG COMPOSER_VERSION=1.10.15
RUN curl -sS https://getcomposer.org/installer | php -- --version=${COMPOSER_VERSION} \
 && mv composer.phar /usr/local/bin/composer

# install node.js
RUN yum install -y https://rpm.nodesource.com/pub_12.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm \
 && yum install -y nodejs

# nginx settings
ADD resources/nginx/etc/nginx/nginx.conf /etc/nginx/nginx.conf
ADD resources/nginx/etc/nginx/sites-enabled/* /etc/nginx/sites-enabled/

# php settings
RUN sed -i -e "s!/run/php-fpm/php-fpm.pid!/var/run/php-fpm.pid!g" \
           /etc/php-fpm.conf
RUN sed -i -e "s!user = apache!user = nginx!g" \
           -e "s!group = apache!group = nginx!g" \
           -e "s!listen = 127.0.0.1:9000!listen = /var/run/php-fpm.sock!g" \
           -e "s!;listen.owner = nobody!listen.owner = nginx!g" \
           -e "s!;listen.group = nobody!listen.group = nginx!g" \
#           -e "s!pm.start_servers = 5!pm.start_servers = 1!g" \
#           -e "s!pm.min_spare_servers = 5!pm.min_spare_servers = 1!g" \
           /etc/php-fpm.d/www.conf
RUN echo 'clear_env = no' >> /etc/php-fpm.d/www.conf
RUN sed -i -e "s!;apc.enable_cli=0!apc.enable_cli=1!g" \
           /etc/php.d/40-apcu.ini

EXPOSE 8083

WORKDIR /var/www

RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

# アプリケーション実行用のユーザを新規作成
RUN useradd -u 1000 www-data

CMD ["bash"]

