FROM ubuntu:xenial-20170915

LABEL maintainer "WATARU MAEDA <w.maeda@neogenia.co.jp>"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# install MySQL, LetsEncrypt, dev tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    tzdata openssl wget vim-tiny less rsync \
    cron monit nginx \
    mariadb-server-10.0 libmysqlclient-dev mycli \
    letsencrypt
# install PHP 5.6
RUN add-apt-repository ppa:ondrej/php -y -u \
 && apt-get install -y --no-install-recommends \
    php5.6 php5.6-fpm php5.6-common php5.6-mysql php5.6-gd php5.6-mbstring php5.6-xmlrpc php5.6-zip php5.6-mcrypt

# clear apt cache
#RUN rm -r /var/lib/apt/lists/*

# install WordPress
RUN cd tmp && wget https://ja.wordpress.org/latest-ja.tar.gz \
  && cd /var/www && tar xzvf /tmp/latest-ja.tar.gz \
  && rm /tmp/latest-ja.tar.gz

WORKDIR /var/www/wordpress

ADD resources/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 700 /docker-entrypoint.sh

# set timezone
RUN \cp -fp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENTRYPOINT ["/docker-entrypoint.sh"]

ARG app_domain=wordpress.localhost
ARG cert_email=webmaster@example.com
ARG gmail_addr
ARG gmail_passwd

ENV APP_DOMAIN=$app_domain
ENV LETS_ENCRYPT_CERT_MAIL=$cert_email

ADD resources/scripts /var/scripts

# monit config
ADD resources/monit_conf/* /etc/monit/conf.d/

# nginx config
ADD resources/nginx/conf/nginx.conf /etc/nginx/nginx.conf
ADD resources/nginx/conf/sites-available/default /etc/nginx/sites-available/default
ADD resources/nginx/html /var/www/html
# replace env_vars in config files.
RUN sed -i -e "s!@APP_DOMAIN@!${app_domain}!g" \
           /etc/nginx/sites-available/default
# let's encrypt ssl files
RUN mkdir -p /etc/letsencrypt/live/${app_domain}
ADD resources/nginx/conf/ssl /etc/letsencrypt/live/${app_domain}

# cron config
ADD resources/cron_conf/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
# take over env_vars for cron jobs
RUN env |sed 's/^\(.*\)$/export \1/g' >>/root/.profile

# extract old wp-content files
RUN /var/scripts/extract-wp-content.sh

EXPOSE 80 443

