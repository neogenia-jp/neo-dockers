FROM ubuntu:16.04

LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

ENV DEBIAN_FRONTEND=noninteractive

# install packaged
RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    unzip wget moreutils \
    imagemagick libmagick++-dev gcc \
    ruby-dev \
    make \
    git subversion mercurial \
    monit mysql-server libmysqlclient-dev redmine

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
RUN rm -r /var/lib/apt/lists/*

ADD resources/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 700 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

ADD resources/scripts /var/scripts
RUN chmod +x /var/scripts/*.sh

WORKDIR /var/scripts

ARG gmail_addr
ARG gmail_passwd

# monit config
ADD resources/monit_conf/* /etc/monit/conf.d/

# redmine config
ADD resources/redmine/conf/database.yml /etc/redmine/default/
ADD resources/redmine/conf/configuration.yml /usr/share/redmine/config/
# replace env_vars in config files.
RUN sed -i -e "s!@GMAIL_ADDR@!${gmail_addr}!g" -e "s!@GMAIL_PASSWD@!${gmail_passwd}!g" /usr/share/redmine/config/configuration.yml

EXPOSE 3000 3306
