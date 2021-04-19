FROM centos:7.9.2009

LABEL vendor "Neogenia Ltd."
LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

# install openssh-server and client and console tools
RUN yum -y install epel-release \
 && yum -y install openssh-server openssh-clients moreutils tmux git \
 && yum clean all

# create ssh host-keys
RUN ssh-keygen -A

# settings for sshd
RUN sed -e 's/^#AllowAgentForwarding .\+$/AllowAgentForwarding yes/' \
        -e 's/^PasswordAuthentication .\+$/PasswordAuthentication no/' \
        -e 's/^#PermitEmptyPasswords no/PermitEmptyPasswords yes/' \
        -i /etc/ssh/sshd_config

# set authorized_keys for root user
RUN cd /root \
 && ssh-keygen -t ecdsa -f /root/.ssh/id_ecdsa -N '' \
 && cat .ssh/id_ecdsa.pub >> .ssh/authorized_keys

# add resource files
ADD resources/pam_callback.sh /usr/local/bin/
ADD resources/send_notify /usr/local/bin/
RUN chmod 555 /usr/local/bin/pam_callback.sh /usr/local/bin/send_notify
ADD resources/startup.sh /var/startup.sh
RUN chmod 500 /var/startup.sh

# set pam_exec callbacks
RUN echo 'session     optional      pam_exec.so /usr/local/bin/pam_callback.sh' >> /etc/pam.d/password-auth

EXPOSE 22

CMD ["/var/startup.sh"]
