ARG RUBY_VERSION=3.2.6
FROM neogenia/ruby:$RUBY_VERSION

# install dependency packages
RUN apt-get update && apt-get -y install \
        libmysqld-dev \
        mysql-client \
        curl \
        unzip \
        git \
        #imagemagick libmagickwand-dev \
        monit

# install headless chrome
# arm64版のChromeがないため、chromiumを使う
# 参考: https://askubuntu.com/questions/1511625/how-to-install-chromium-browser-without-snap-or-flatpak-in-ubuntu-24-04/1511626#1511626
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:xtradeb/apps -y \
    && apt-get update \
    && apt-get install -y chromium

# install Japanese fonts
# TODO: `apt install -y fonts-ipafont` でいける？
ARG FONT_FILE=IPAexfont00401
RUN curl -L -O https://moji.or.jp/wp-content/ipafont/IPAexfont/${FONT_FILE}.zip \
 && unzip ${FONT_FILE}.zip \
 && mkdir -p /usr/share/fonts/japanese/TrueType/ \
 && mv ${FONT_FILE}/*.tt[fc] /usr/share/fonts/japanese/TrueType/ \
 && chmod 644 /usr/share/fonts/japanese/TrueType/* \
 && fc-cache -fv \
 && rm -r ${FONT_FILE}* 

# install node.js, yarn (for webpacker) and some packages
RUN curl -L 'https://dl.yarnpkg.com/debian/pubkey.gpg' | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && curl -L 'https://deb.nodesource.com/setup_22.x' | bash - \
 && apt-get install -y nodejs yarn \
 && yarn global add typescript

# clean apt-get files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN gem install bundler:2.4.22

## misc settings for Ubuntu 24.04
RUN usermod -u 1001 ubuntu \
 && usermod -u 1000 www-data \
 && usermod -s /bin/bash www-data

