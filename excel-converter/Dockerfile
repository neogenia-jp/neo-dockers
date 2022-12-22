FROM ubuntu:bionic-20190612

LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

############################################################
# install libreoffice, ruby
RUN apt-get update && apt-get -y install libreoffice ruby wget
RUN gem install libreconv

############################################################
# set Japanese locale
RUN apt-get install -y locales
RUN echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=ja_JP.UTF-8

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:en
ENV LC_ALL ja_JP.UTF-8

# install Japanese fonts
RUN apt-get install -y 'fonts-takao-*'

RUN apt-get install -y netcat

# TODO: ベースイメージ切り替える時に、上の方に持っていって整理したい
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata

RUN mkdir /var/scripts/
ADD convert* /var/scripts/
RUN chmod +x /var/scripts/convert.rb /var/scripts/convert_server*.sh

WORKDIR /var/scripts/

EXPOSE 2222 2223 2224

############################################################
# clean apt-get files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

CMD ["/var/scripts/convert_servers.sh"]

