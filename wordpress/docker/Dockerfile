FROM ubuntu:bionic-20180224

LABEL Vendor     "Neogenia Ltd."
LABEL maintainer "WATARU MAEDA <w.maeda@neogenia.co.jp>"

ENV DEBIAN_FRONTEND=noninteractive

############################################################
# timezone, lang settings
ENV LANG=C.UTF-8
RUN ln -sf /usr/share/zoneinfo/Japan /etc/localtime

############################################################
# install nginx
RUN apt-get update && apt-get install -y --no-install-recommends \
        monit \
        apache2-utils \
        nginx \
        openssl \
        locales tzdata \
        less vim-tiny

# install MySQL, dev tools
RUN apt-get install -y --no-install-recommends \
    software-properties-common \
    wget rsync \
    mariadb-server libmysqlclient-dev mycli

# install PHP
#RUN add-apt-repository ppa:ondrej/php -y -u \
# && apt-get install -y --no-install-recommends \
#    php php-fpm php-common php-mysql php-gd php-mbstring php-xmlrpc php-zip php-mcrypt
RUN apt-get install -y --no-install-recommends \
    php php-fpm php-common php-mysql php-gd php-mbstring php-xmlrpc php-zip

# clear apt cache
RUN rm -r /var/lib/apt/lists/*

# install WordPress
#RUN cd tmp && wget https://ja.wordpress.org/latest-ja.tar.gz \
#  && cd /var/www && tar xzvf /tmp/latest-ja.tar.gz \
#  && rm /tmp/latest-ja.tar.gz

WORKDIR /var/www

ADD resources/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 700 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

ADD resources/scripts /var/scripts

# monit config
ADD resources/monit_conf/* /etc/monit/conf.d/

# nginx config
ADD resources/nginx/conf/nginx.conf /etc/nginx/nginx.conf
ADD resources/nginx/conf/sites-available/default /etc/nginx/sites-available/default
ADD resources/nginx/html /var/www/html

EXPOSE 8080

