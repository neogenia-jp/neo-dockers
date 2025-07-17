FROM php:8.2-apache

COPY ./src /var/www/html
# rewriteモジュールを有効にする
RUN a2enmod rewrite
# リダイレクトを解除するため、既存のアクセスログファイルを削除して再作成
RUN rm -f /var/log/apache2/access.log \
    && rm -f /var/log/apache2/error.log \
    && rm -f /var/log/apache2/other_vhosts_access.log \
    && touch /var/log/apache2/access.log \
    && touch /var/log/apache2/error.log \
    && touch /var/log/apache2/other_vhosts_access.log \
    && chmod a+w /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log

# アクセスログの設定を上書きする
COPY ./resources/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/
COPY ./resources/etc/apache2/conf-enabled/other-vhosts-access-log.conf /etc/apache2/conf-enabled/
