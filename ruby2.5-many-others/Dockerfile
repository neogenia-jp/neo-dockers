ARG RUBY_VERSION=2.5.0
FROM neogenia/ruby2.5:$RUBY_VERSION

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
RUN wget -O - https://deb.nodesource.com/setup_6.x | bash - \
 && apt-get -y install nodejs npm \
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

