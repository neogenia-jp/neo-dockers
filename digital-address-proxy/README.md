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

以下はdocker-composeを使った起動方法です。

次のような記載があるymlファイルを作成してください。

```yaml
services:
  digita_address_proxy:
    container_name: digital-address-proxy
    image: neogenia/digital-address-proxy:latest
    ports:
      - "80:80"
    volumes:
      - ${CREDENTIALS_FILE_PATH}:/var/www/resources/credentials.json
    environment:
      CREDENTIALS_FILE_PATH   : /var/www/resources/credentials.json
```

`${CREDENTIALS_FILE_PATH}` は 事前準備で作成した`credentials.json` へのパスを、docker-compose.yml ファイルのあるディレクトリからの相対パスまたは絶対パスで指定してください。

