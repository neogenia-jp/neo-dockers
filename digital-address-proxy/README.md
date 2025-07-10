# 郵便番号・デジタルアドレス検索APIプロキシサーバ

## 概要

日本郵政が提供する郵便番号検索APIと、デジタルアドレス検索APIをプロキシサーバとして提供します。
javascriptの `AJAX` や `fetch` を使って、簡単に郵便番号やデジタルアドレスを検索できます。

## イメージ作成方法

```shell
cd digital-address-proxy
docker build -f docker/Dockerfile -t neogenia/digital-address-proxy .
```

## 事前準備

日本郵政の郵便番号・デジタルアドレス for BIZ のアカウントを取得してください。
[郵便番号・デジタルアドレス for BIZ](https://guide-biz.da.pf.japanpost.jp/api/)

システムリスト　→　新規登録　で、以下の情報を入力してください。
- システム名: 任意
- URL: このプロキシAPIをホストするサーバーのURL
- 利用システムの固定IPアドレス: **127.0.0.1**

登録後に表示される｢クライアントID｣と｢クライアントシークレット｣を、`credentials.json` というファイルに記載してください。
特にクライアントシークレットはこの画面でしか表示されないので、注意してください。
`grant_type` は `client_credentials` のままでOKです。
```json
{
  "grant_type": "client_credentials",
  "client_id": "your-client_id",
  "secret_key": "your-secret_key"
}
```

`credentials.json` のサンプルは `resources/credentials.json` にありますので参考にしてください。

## 起動方法

以下は docker-compose を使った起動方法です。

`credentials.json` が（`docker-compose.yml` から見て） `./config/credentials.json` においてある場合、
以下のように bindマウントを記述してください。

```yaml
# docker-sompose.yml
version: "3.3"
services:
  digita_address_proxy:
    container_name: digital-address-proxy
    image: neogenia/digital-address-proxy:20250710
    ports:
      - "80:80"
    volumes:
      - type: bind
        source: ./config/credentials.json  # ここに相対ファイルパスを書く
        target: /var/credentials.json
        read_only: true
    environment:
      CREDENTIALS_FILE_PATH: /var/credentials.json
```
