FROM zabbix/zabbix-web-apache-mysql:alpine-5.2-latest

USER root

# グラフの文字化け解消のために日本語フォントをインストールして差し替える
# https://qiita.com/ohhara_shiojiri/items/acf995bb70f64ec757f9
RUN apk update && apk upgrade \
 && apk add font-noto font-noto-cjk \
 && fc-cache -fv \
 && mv /usr/share/zabbix/assets/fonts/DejaVuSans.ttf /usr/share/zabbix/assets/fonts/DejaVuSans.ttf.bak \
 && ln -s /usr/share/fonts/noto/NotoSansCJK-Regular.ttc /usr/share/zabbix/assets/fonts/DejaVuSans.ttf

USER 1997

