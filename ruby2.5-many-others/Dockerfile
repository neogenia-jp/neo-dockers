FROM ubuntu:xenial-20171201

LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

ENV DEBIAN_FRONTEND=noninteractive

############################################################
# install dependency packages
RUN apt-get update && apt-get -y install \
        build-essential \
        libreadline-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        libyaml-dev \
        zlib1g-dev \
        libmysqld-dev \
        libfontconfig \
        wget \
        unzip \
        git \
        mysql-client \
        vim-tiny \
        locales \
        tzdata \
        monit

############################################################
# install ruby
ENV RUBY_VERSION 2.5.0-rc1
RUN wget -O - http://ftp.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/ruby-${RUBY_VERSION}.tar.xz | tar Jx \
 && (cd ruby-${RUBY_VERSION} && ./configure --disable-install-doc && make install ) \
 && rm -rf /ruby-${RUBY_VERSION}

############################################################
# install nodejs, npm packages
RUN wget -O - https://deb.nodesource.com/setup_6.x | bash - \
 && apt-get -y install nodejs \
 && npm install -g gulp \
 && npm install -g typescript

############################################################
# install phantomjs
RUN wget -O - https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar jx \
 && cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin \
 && chmod a+x /usr/local/bin/phantomjs \
 && rm -r phantomjs-2.1.1-linux-x86_64

# install Japanese fonts
RUN wget http://dl.ipafont.ipa.go.jp/IPAexfont/IPAexfont00301.zip \
 && unzip IPAexfont00301.zip \
 && mkdir -p /usr/share/fonts/japanese/TrueType/ \
 && mv IPAexfont00301/*.ttf /usr/share/fonts/japanese/TrueType/ \
 && rm -r IPAexfont00301*

#####################################################
# misc settings
RUN usermod -u 1000 www-data
RUN usermod -s /bin/bash www-data

############################################################
# clean apt-get files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

CMD ["bash"]

