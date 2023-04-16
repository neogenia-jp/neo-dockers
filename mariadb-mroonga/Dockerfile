ARG MARIA_DB_VERSION=10.8.2
FROM mariadb:$MARIA_DB_VERSION

LABEL vendor     "Neogenia Ltd."
LABEL maintainer "tomoprog <t.yamamoto@neogenia.co.jp>"

# install mroonga
RUN apt update \
    && apt install -y mariadb-plugin-mroonga

# install mecab tokenizer
RUN apt update \
    && apt install -y software-properties-common \
                      gpg-agent \
    && add-apt-repository -y universe \
    && add-apt-repository -y ppa:groonga/ppa \
    && apt update \
    && apt install -y groonga-tokenizer-mecab

# clear apt cache
RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

# install mroonga plugin of MariaDB
RUN ln -s /usr/share/mysql/mroonga/install.sql /docker-entrypoint-initdb.d
