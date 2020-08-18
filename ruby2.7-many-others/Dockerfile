ARG RUBY_VERSION=2.7.0
FROM neogenia/ruby:$RUBY_VERSION

LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

############################################################
# install dependency packages
RUN apt-get update && apt-get -y install \
        libmysqld-dev \
        unzip \
        git \
        imagemagick libmagickwand-dev \
        mysql-client \
        monit

############################################################
# install nodejs, npm packages
RUN wget -O - https://deb.nodesource.com/setup_10.x | bash - \
 && apt-get -y install nodejs \
 && npm install -g gulp \
 && npm install -g typescript

############################################################
# install headless chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# install Japanese fonts
ARG FONT_FILE=IPAGTTC00303
RUN wget https://ipafont.ipa.go.jp/IPAfont/${FONT_FILE}.zip \
 && unzip ${FONT_FILE}.zip \
 && mkdir -p /usr/share/fonts/japanese/TrueType/ \
 && mv ${FONT_FILE}/*.tt[fc] /usr/share/fonts/japanese/TrueType/ \
 && rm -r ${FONT_FILE}*

#####################################################
# misc settings
RUN usermod -u 1000 www-data
RUN usermod -s /bin/bash www-data

############################################################
# clean apt-get files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

CMD ["bash"]

RUN gem install bundler:1.16.6
