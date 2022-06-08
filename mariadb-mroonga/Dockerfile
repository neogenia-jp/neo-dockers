ARG MARIA_DB_VERSION=10.8.2
FROM mariadb:$MARIA_DB_VERSION

MAINTAINER tomoprog <t.yamamoto@neogenia.co.jp>

# install mroonga
RUN apt update \
    && apt install -y mariadb-plugin-mroonga

# install mecab tokenizer
RUN apt update \
    && apt install -y software-properties-common \
    && add-apt-repository -y universe \
    && add-apt-repository -y ppa:groonga/ppa \
    && apt update \
    && apt install -y groonga-tokenizer-mecab

# clear apt chach
RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

# install mroonga plugin in MariaDB
RUN ln -s /usr/share/mysql/mroonga/install.sql /docker-entrypoint-initdb.d
