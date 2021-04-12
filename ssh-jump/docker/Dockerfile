FROM centos:7.9.2009

# install openssh-server and client and console tools
RUN yum -y install openssh-server openssh-clients tmux git

# create ssh host-keys
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
 && ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa

# settings for sshd
RUN sed -e 's/^#AllowAgentForwarding .\+$/AllowAgentForwarding yes/' \
        -e 's/^PasswordAuthentication .\+$/PasswordAuthentication no/' \
        -e 's/^#PermitEmptyPasswords no/PermitEmptyPasswords yes/' \
        -i /etc/ssh/sshd_config

# set autorized_keys for root user
RUN cd /root \
 && ssh-keygen -t ecdsa -f /root/.ssh/id_ecdsa -N '' \
 && cat .ssh/id_ecdsa.pub >> .ssh/authorized_keys

EXPOSE 22

MAINTAINER WATARU MAEDA <w.maeda@neogenia.co.jp>

# sshdを起動
CMD ["/usr/sbin/sshd", "-D"]
