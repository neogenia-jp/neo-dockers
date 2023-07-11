# Wordpress + SFTP サーバ

## Wordpress

Wordpress公式の Docker イメージを使用しています。

### docker コンテナの制御方法

```bash
# 起動
docker compose up -d

# 停止
docker compose down

# 起動中のコンテナ一覧
docker ps

# コンテナログの表示
docker logs {コンテナ名}

# コンテナログのウォッチ
docker logs -f {コンテナ名}
(CTRL-C で終了)

# コンテナにアタッチ（コンテナ内に入ってシェルを開く）
docker exec -ti {コンテナ名} bash
```

### Apache, PHP のログの確認方法

```bash
# Dockerコンテナのログを標準出力とエラー出力に分離
docker logs wordpress > /tmp/access.log 2> /tmp/err.log

# 標準出力の方を見ればApacheのアクセスログが確認できます
less /tmp/access.log

# エラー出力の方を見ればPHPのエラーログが確認できます
less /tmp/err.log
```

## SFTP

TODO
