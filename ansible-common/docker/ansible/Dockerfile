FROM centos:7.9.2009

ENV ANSIBLE_HOST_KEY_CHECKING False

# install some packages
RUN yum -y install python3 openssh-clients

# pip のアップグレード（標準でインストールされるのは古すぎてエラーが出るため）
RUN python3 -m pip install -U pip

ENV PYTHONIOENCODING utf-8
ENV LC_ALL en_US.UTF-8

# install ansible
RUN pip3 install ansible

CMD /bin/bash

RUN mkdir -p /root/.ssh/

LABEL vendor "Neogenia Ltd."
LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

