FROM ubuntu:focal-20220426

LABEL Vendor     "Neogenia Ltd."
LABEL maintainer "WATARU MAEDA <w.maeda@neogenia.co.jp>"

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG=C.UTF-8

############################################################
# install nginx
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        monit cron \
        apache2-utils \
        nginx \
        openssl \
        locales tzdata \
        letsencrypt \
        less vim-tiny \
 && apt-get clean \
 && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN ln -sf /usr/share/zoneinfo/Japan /etc/localtime

############################################################
# nginx settings
ADD resources/nginx/nginx.conf /etc/nginx/
ADD resources/nginx/cert_challenge /etc/nginx/sites-enabled/default
ADD resources/nginx/default_site /etc/nginx/sites-available/default_https

# nginx設定ファイルに記載されている環境変数を置換
ARG app_domain
ENV APP_DOMAIN=$app_domain
RUN sed -i -e "s!@APP_DOMAIN@!${app_domain}!g" \
           /etc/nginx/sites-available/default_https

############################################################
# monit settings
ADD resources/monit/* /etc/monit/conf.d/

############################################################
# add 'reload nginx' into setting of cron
RUN sed -i -e "s|q renew|q renew --deploy-hook '/usr/sbin/service nginx reload'|g" \
              /etc/cron.d/certbot

ADD resources/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 700 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80 443

#####################################################
# copy script files
ADD resources/scripts /var/scripts
RUN chmod 700 /var/scripts/*

RUN mkdir /var/www/letsencrypt
