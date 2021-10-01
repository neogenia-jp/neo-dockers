FROM ubuntu:12.04

# set timezone
RUN \cp -fp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN apt-get upgrade -y

#php install
RUN apt-get update && apt-get install -y \
            php5-cli \
            php5-fpm \
            php5-mysqlnd \
            php5-mcrypt \
            --no-install-recommends

#phpredis install
RUN apt-get install -y \
            curl \
            php5-dev \
            unzip \
            build-essential \
            --no-install-recommends

RUN curl https://codeload.github.com/phpredis/phpredis/zip/2.2.7 -o /tmp/phpredis.zip

RUN cd /tmp && unzip -o /tmp/phpredis.zip && \
            cd /tmp/phpredis-2.2.7 && \
            phpize && \
            ./configure && \
            make install && \
            cd /tmp &&  rm -rf /tmp/phpredis-2.2.7 /tmp/phpredis.zip 

RUN echo "extension=redis.so" > /etc/php5/fpm/conf.d/redis.ini
RUN echo "extension=redis.so" > /etc/php5/cli/conf.d/redis.ini

#nginx install
RUN apt-get install -y \
            nginx \
            --no-install-recommends

# install monit
# ※apt-get では monit のバージョンが古く、起動したプロセスが環境変数を引き継げない問題があるため、
#   配布元より新し目のバイナリをダウンロードしてインストールする
ENV MONIT_VERSION 5.25.1
RUN cd /tmp \
 && curl -L https://bitbucket.org/tildeslash/monit/downloads/monit-${MONIT_VERSION}-linux-x64.tar.gz | tar xzf /dev/stdin \
 && cp monit-${MONIT_VERSION}/bin/monit /usr/bin/monit \
 && cp monit-${MONIT_VERSION}/conf/monitrc /etc/monitrc \
 && echo 'include /etc/monit/conf.d/*' >> /etc/monitrc \
 && rm -rf monit-${MONIT_VERSION}

#support tools
RUN apt-get install -y \
            vim-tiny \
            --no-install-recommends

# install some modules required batch
RUN apt-get install -y \
            perl-modules \
            ruby \
            mysql-client \
            --no-install-recommends

#mail setting
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
            postfix \
            libsasl2-modules \
            --no-install-recommends
ADD resources/postfix/etc/postfix/main.cf       /etc/postfix/main.cf
ADD resources/postfix/etc/postfix/sasl_passwd   /etc/postfix/sasl_passwd


#clear files
RUN rm -r /var/lib/apt/lists/*

# composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php && \
    mv composer.phar /usr/local/bin/composer

# CPAN (for LWP::UserAgent)
RUN yes '' | cpan || true  # エラーを無視
RUN cpan -i \
    URI  \
    IO::HTML \
    HTTP::Daemon \
    Encode::Locale  \
    File::Listing  \
    HTML::Entities  \
    IO::Socket::SSL \
    HTTP::Cookies  \
    Net::HTTP  \
    WWW::RobotRules
# LWP::UserAgent は最新版だとインストールエラーになるので、バージョンを指定する
RUN cpan -i \
    O/OA/OALDERS/libwww-perl-6.43.tar.gz \
    LWP::Protocol::https

EXPOSE 80

LABEL vendor "Neogenia Ltd."
LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

