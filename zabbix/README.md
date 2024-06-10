# Zabbix サーバ

## 起動方法

```sh
docker-compose up --build
```

## 管理画面へのログイン

ID: Admin
Password: zabbix

ログインしたらすぐにパスワードを変更しましょう。

サイドメニューより 「User settings」をクリックし、Password 欄の `Changepassword` ボタンをクリックすると変更できます。

また、Language を Japanese に変更しておきましょう。


## 起動後の初期設定

### プロキシの登録

以下のようなログがずっと出続けるため、プロキシの登録が必要。
```
zabbix-server_1            |    204:20210409:153939.493 cannot parse proxy data from active proxy at "172.16.238.5": proxy "zabbix-proxy-mysql" not found
zabbix-proxy-mysql_1       |    176:20210409:153939.494 cannot send proxy data to server at "zabbix-server": proxy "zabbix-proxy-mysql" not found
zabbix-server_1            |    201:20210409:153940.496 cannot parse proxy data from active proxy at "172.16.238.5": proxy "zabbix-proxy-mysql" not found
zabbix-proxy-mysql_1       |    176:20210409:153940.496 cannot send proxy data to server at "zabbix-server": proxy "zabbix-proxy-mysql" not found
zabbix-server_1            |    202:20210409:153941.498 cannot parse proxy data from active proxy at "172.16.238.5": proxy "zabbix-proxy-mysql" not found
zabbix-proxy-mysql_1       |    176:20210409:153941.499 cannot send proxy data to server at "zabbix-server": proxy "zabbix-proxy-mysql" not found
```

管理画面にて[管理]→[プロキシ]を開き、新規プロキシとして `zabbix-proxy-mysql` を登録する。
- プロキシ名: `zabbix-proxy-mysql`
- プロキシモード: アクティブ
- プロキシのアドレス: `zabbix-proxy-mysql`


### Probremに出ている問題の対応

https://qiita.com/uzresk/items/5c617a564840d3d9fac7#probrem%E3%81%AB%E5%87%BA%E3%81%A6%E3%81%84%E3%82%8B%E5%95%8F%E9%A1%8C%E3%82%92%E7%9B%B4%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B


### ホスト自動登録の設定

Zabbixでは、アクティブエージェントが接続してきたときに、自動的に監視対象ホストとして登録させることができます。
そのためには、アクションの作成が必要です。

管理画面にて[設定]→[アクション]を選択し、イベントソースとして[自動登録]を選択し、[アクションの作成]をクリックします。

- [アクション]タブで、アクションに名前を付けます。例えば「アクティブホストの自動登録」
- [アクションの実行条件]タブで、任意の条件を指定します。特に設定しなくて大丈夫です。
- [アクションの実行内容]タブで、「ホストを追加」、「テンプレートへのリンク: Linux by Zabbix agent active」を追加します。

[公式ドキュメント：2 アクティブエージェントの自動登録](https://www.zabbix.com/documentation/2.2/jp/manual/discovery/auto_registration)


## HTTPS対応

EzGate と一緒に稼働させることで簡単に HTTPS 対応できます。
`docker-compose.with_ezgate.yml` に定義がありますので、ドメイン名やメールアドレスなどを必要に応じて書き換えてください。
起動方法は、以下のようになります。

```sh
# 新規に稼働させる時
docker-compose -f docker-compose.yml -f docker-compose.with_ezgate.yml up -d --build

# EzGateだけを起動し直す時
docker-compose -f docker-compose.yml -f docker-compose.with_ezgate.yml stop ezgate
docker-compose -f docker-compose.yml -f docker-compose.with_ezgate.yml up -d --build ezgate

# EzGateの設定をリロードするとき
docker exec -ti zabbix_ezgate_1 /var/scripts/reload_config.rb
```

## Slack通知

https://devlog.arksystems.co.jp/2021/07/27/13746/
上記サイトの説明で `{$ZABBIX_URL}` とある箇所は `{$ZABBIX.URL}` が正解かと思われる。

## 参考リンク

[Zabbix 5.0 を Docker Compose で起動する手順](https://qiita.com/zembutsu/items/d98099bf68399c56c236)
[Zabbix5.0をdocker-composeで速攻起動する](https://qiita.com/uzresk/items/5c617a564840d3d9fac7)
[DockerでのZabbix 5.0の環境構築メモ](https://qiita.com/migaras/items/3aa24b74a55a6fc715d1)

