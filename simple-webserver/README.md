# Simple WebServer

静的ページの配信用にシンプルな Webサーバと SFTP サーバを提供します。

使用ミドルウェア
- Webサーバ: nginx
- HTTPS証明書: Let's Encrypt
- SFTPサーバ: ssh

## Usage

```sh
# 初期設定（ドメイン、メールアドレスの設定が必須）
vi docker-compose.yml

# コンテナ構成をビルドして起動
docker-compose up --buiuld

# 停止
docker-compose down
```

初回コンテナ起動時に、設定したドメインで Let's Encrypt によるSSL証明書の取得処理が行われます。
実際にそのドメインで 80番ポートと、443番ポートに外部からアクセス可能になっている必要があります。

SFTPサーバは、デフォルトでは `10022` 番ポートで待ち受けするようになっています。
ファイアウォールなどでポートを開放しておく必要があります。
ポート番号を変更したい場合は、後述のカスタマイズの説明を参照のこと。

## コンテナ構成

`docker-compose.yml` には以下の２つのサービスが定義されています。

- `web_sv`: Webサーバ
- `sftp_sv`: SFTPサーバ

### 設定方法

#### 必須の設定

- ドメイン
  `docker-compose.yml` の `web_sv` のビルド引数 `app_domain` に設定してください。
- Let'sEncrypt用メールアドレス
  `docker-compose.yml` の `web_sv` の環境変数 `LETS_ENCRYPT_CERT_MAIL` に設定してください。
- HTTPコンテンツ
  `wwwroot/` ディレクトリに配置してください。
  外部からSFTPで接続した場合は、 `wwwroot/` ディレクトリが見えるようになっています。

#### カスタマイズ

- SFTPサーバのパスワード
  ログインユーザとパスワードは、以下の通りです。
  ユーザ名: `sftpuser1`
  パスワード: `mDJN08t2hpube!skjbKna_sVnbE3qt8`
  変更する場合は、 `sftp_server/Dockerfile` の以下の箇所を編集してください。
  ```dockerfile
  RUN echo sftpuser1:{password}:1000:1000:/sftp_root >> /etc/sftp-users.conf
  ```
- SFTPサーバのポート番号
  `docker-compose.yml` の `sftp_sv` のポートマッピングに設定してください。
  デフォルトで `10022` 番ポートに割り当てされています。
  例えば、`9022` 番ポートに割り当てる場合は `9022:22` と設定してください。
- nginxのコンフィグ
  `webserver/resources/nginx/default_site` を変更してください。
  変更を反映させるには、コンテナをリビルドする必要があります。
  TODO: リビルド不要で反映させるために、configファイルをマウントする方式に変更する

## ディレクトリ構成

- `web_server/`
  nginxのためのDockerビルドコンテキスト
- `sftp_server/`
  SFTPサーバのためのDockerビルドコンテキスト
- `nginx_logs/`
  nginx のログ出力ディレクトリ（コンテナにマウントされます）
- `wwwroot/`
  Webコンテンツを配置するためのディレクトリ（各コンテナにマウントされます）
