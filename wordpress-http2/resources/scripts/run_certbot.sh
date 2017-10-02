#bin/bash

mkdir -p mkdir /var/www/letsencrypt

letsencrypt certonly \
      --text \
      --webroot \
      --webroot-path /var/www/letsencrypt \
      --email ${LETS_ENCRYPT_CERT_MAIL}  \
      -d ${APP_DOMAIN} \
      --agree-tos \
      --renew-by-default $*

