FROM centos:7.9.2009

ENV ANSIBLE_HOST_KEY_CHECKING False

# install some packages
RUN yum -y install python3 openssh-clients

# pip のアップグレード（標準でインストールされるのは古すぎてエラーが出るため）
RUN python3 -m pip install -U pip

# install ansible
RUN pip3 install ansible

CMD /bin/bash
