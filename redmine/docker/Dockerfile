FROM ubuntu:bionic-20200807

LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

ENV DEBIAN_FRONTEND=noninteractive

# install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    unzip curl moreutils \
    imagemagick libmagick++-dev gcc \
    ruby-dev \
    make \
    git subversion mercurial \
    monit mysql-server libmysqlclient-dev \
 && rm -r /var/lib/apt/lists/*

RUN \cp -fp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN mkdir -p /usr/share/redmine \
 && ln -s /usr/share/redmine /var/lib/redmine \
 && svn co https://svn.redmine.org/redmine/branches/4.1-stable /usr/share/redmine

# install plugin "work time"
ARG work_time_ver=0.4.0
RUN  cd /usr/share/redmine/plugins/ \
  && curl -L "https://github.com/tkusukawa/redmine_work_time/archive/${work_time_ver}.tar.gz" | tar xvzf - \
  && mv "redmine_work_time-${work_time_ver}" redmine_work_time

# install plugin "verification"
RUN  cd /usr/share/redmine/plugins/ \
  && git clone "https://github.com/skyach/verification.git"

# install plugin "estimate timelog"
ARG estimate_timelog_ver=0.7.0
RUN  cd /usr/share/redmine/plugins/ \
  && curl -L "https://github.com/toritori0318/redmine_estimate_timelog/archive/release_${estimate_timelog_ver}.tar.gz" | tar xvzf - \
  && mv "redmine_estimate_timelog-release_${estimate_timelog_ver}" redmine_estimate_timelog

# install plugin "code review"
ARG code_review_ver=1.0.0
RUN  cd /usr/share/redmine/plugins/ \
  && curl -L "https://github.com/haru/redmine_code_review/archive/${code_review_ver}.tar.gz" | tar xvzf - \
  && mv "redmine_code_review-${code_review_ver}" redmine_code_review

ADD resources/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 700 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

ADD resources/scripts /var/scripts
RUN chmod +x /var/scripts/*.sh

RUN gem install bundler

WORKDIR /var/scripts

ARG gmail_addr
ARG gmail_passwd

# monit config
ADD resources/monit_conf/* /etc/monit/conf.d/

# redmine config
ADD resources/redmine/conf/* /usr/share/redmine/config/
# replace env_vars in config files.
RUN sed -i -e "s!@GMAIL_ADDR@!${gmail_addr}!g" -e "s!@GMAIL_PASSWD@!${gmail_passwd}!g" /usr/share/redmine/config/configuration.yml

EXPOSE 3000 3306

RUN mkdir -p /var/log/redmine \
 && ln -s /usr/share/redmine/log /var/log/redmine/default

