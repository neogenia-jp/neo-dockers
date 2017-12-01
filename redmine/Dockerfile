FROM ubuntu:16.04

LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

ENV DEBIAN_FRONTEND=noninteractive

# install packaged
RUN apt-get update 
RUN apt-get install -y --no-install-recommends \
    tzdata \
    unzip wget \
    imagemagick libmagick++-dev gcc \
    ruby-dev \
    git subversion mercurial \
    cron monit nginx mysql-server libmysqlclient-dev redmine \
    letsencrypt

RUN \cp -fp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN mkdir -p /usr/share/redmine/plugins/

# install plugin "work time"
ARG work_time_ver=0.3.4
RUN  cd /tmp \
  && wget "https://bitbucket.org/tkusukawa/redmine_work_time/downloads/redmine_work_time-${work_time_ver}.zip" \
  && unzip redmine_work_time-${work_time_ver}.zip \
  && mv redmine_work_time /usr/share/redmine/plugins/ \
  && rm redmine_work_time-${work_time_ver}.zip

# install plugin "verification"
RUN  cd /usr/share/redmine/plugins/ \
  && git clone "https://github.com/rails/verification.git"

# install plugin "estimate timelog" with additional gem 'iconv'
RUN  cd /usr/share/redmine/plugins/ \
  && git clone "https://github.com/toritori0318/redmine_estimate_timelog.git" \
  && echo "gem 'iconv'" >> ../Gemfile

# install plugin "code review"
ARG code_review_ver=0.7.0
RUN  cd /tmp \
  && wget "https://bitbucket.org/haru_iida/redmine_code_review/downloads/redmine_code_review-${code_review_ver}.zip" \
  && unzip redmine_code_review-${code_review_ver}.zip \
  && mv redmine_code_review /usr/share/redmine/plugins/ \
  && rm redmine_code_review-${code_review_ver}.zip

# clear apt cache
#RUN rm -r /var/lib/apt/lists/*

ADD resources/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 700 /docker-entrypoint.sh

WORKDIR /usr/share/redmine

ENTRYPOINT ["/docker-entrypoint.sh"]

ARG app_domain=redmine.localhost
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

# redmine config
ADD resources/redmine/conf/database.yml /etc/redmine/default/
ADD resources/redmine/conf/configuration.yml /usr/share/redmine/config/
# replace env_vars in config files.
RUN sed -i -e "s!@GMAIL_ADDR@!${gmail_addr}!g" -e "s!@GMAIL_PASSWD@!${gmail_passwd}!g" /usr/share/redmine/config/configuration.yml

# redmine data
RUN mkdir -p /var/redmine_data
ADD resources/redmine/data/* /var/redmine_data/

EXPOSE 80 443 3000 3306
