FROM atmoz/sftp

LABEL Vendor     "Neogenia Ltd."
LABEL maintainer "WATARU MAEDA <w.maeda@neogenia.co.jp>"

RUN \cp -fp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  
# パスワードを設定してください
ARG password

RUN echo sftpuser1:$password:33:33:/www_root >> /etc/sftp-users.conf \
 && chmod 600 /etc/sftp-users.conf

#VOLUME /home/sftpuser1

