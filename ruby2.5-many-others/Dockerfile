ARG RUBY_VERSION=2.5.9
FROM neogenia/ruby:$RUBY_VERSION

# install dependency packages
RUN apt-get update && apt-get -y install \
        libmysqld-dev \
        unzip \
        git \
        imagemagick libmagickwand-dev \
        mysql-client \
        libgnutls30 \
        monit

# install nodejs, npm packages
RUN curl -L https://deb.nodesource.com/setup_10.x | bash - \
 && apt-get -y install nodejs \
 && npm install -g gulp \
 && npm install -g typescript

# install headless chrome
RUN curl -L https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# clean apt-get files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# install Japanese fonts
ARG FONT_FILE=IPAexfont00401
RUN curl -L -O https://moji.or.jp/wp-content/ipafont/IPAexfont/${FONT_FILE}.zip \
 && unzip ${FONT_FILE}.zip \
 && mkdir -p /usr/share/fonts/japanese/TrueType/ \
 && mv ${FONT_FILE}/*.tt[fc] /usr/share/fonts/japanese/TrueType/ \
 && rm -r ${FONT_FILE}*

# misc settings
RUN usermod -u 1000 www-data
RUN usermod -s /bin/bash www-data

CMD ["bash"]

LABEL vendor     "Neogenia Ltd."
LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

RUN gem install bundler

