FROM atmoz/sftp

LABEL Vendor     "Neogenia Ltd."
LABEL maintainer "WATARU MAEDA <w.maeda@neogenia.co.jp>"

RUN \cp -fp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN echo sftpuser1:mDJN08t2hpube!skjbKna_sVnbE3qt8:1000:1000:/sftp_root >> /etc/sftp-users.conf \
 && chmod 600 /etc/sftp-users.conf

VOLUME /home/sftpuser1
