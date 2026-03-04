ARG RUBY_VERSION=2.7.0
FROM neogenia/ruby:$RUBY_VERSION

# install dependency packages
RUN apt-get update && apt-get -y install \
        default-libmysqlclient-dev \
        mysql-client \
        curl \
        unzip \
        git \
        #imagemagick libmagickwand-dev \
        monit

# install headless chrome \
# NOTE: chromium-browserのdev（開発版）を使用する
# 参考: https://uepon.hatenadiary.com/entry/2021/01/02/213113
#
# 理由:
#   通常のchromium-browserを実行すると、snapを使用してchromiumをインストールする必要が出てくるため。
#
#   chromium-browserを実行すると以下のエラーが出てしまう
#     Command '/usr/bin/chromium-browser' requires the chromium snap to be installed.
#        Please install it with:
#        snap install chromium \
#   しかし、snapはsystemdやsnapdなどに依存し、Dockerコンテナ内で使うのは簡単ではないと考えられる。
#
#   また、以下を参考にapt-getするリポジトリを追加し、chromiumのインストールを試みたが、
#   Ubuntu Focalのリポジトリにはchromiumが存在しないため、インストール不可能だった。
#   https://askubuntu.com/questions/1511625/how-to-install-chromium-browser-without-snap-or-flatpak-in-ubuntu-24-04/1511626#1511626
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:saiarcot895/chromium-dev -y
RUN apt-get update
RUN apt-get install -y chromium-browser chromium-chromedriver

# install Japanese fonts
ARG FONT_FILE=IPAexfont00401
RUN curl -L -O https://moji.or.jp/wp-content/ipafont/IPAexfont/${FONT_FILE}.zip \
 && unzip ${FONT_FILE}.zip \
 && mkdir -p /usr/share/fonts/japanese/TrueType/ \
 && mv ${FONT_FILE}/*.tt[fc] /usr/share/fonts/japanese/TrueType/ \
 && rm -r ${FONT_FILE}*

# install node.js, yarn (for webpacker) and some packages
RUN curl -L 'https://dl.yarnpkg.com/debian/pubkey.gpg' | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && curl -L 'https://deb.nodesource.com/setup_16.x' | bash - \
 && apt-get install -y nodejs yarn \
 && yarn global add typescript

# clean apt-get files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# update bundler 2.1.x because default-version is 1.17 in ruby 2.7
RUN gem install bundler:2.1.4

# misc settings
RUN usermod -u 1000 www-data
RUN usermod -s /bin/bash www-data

