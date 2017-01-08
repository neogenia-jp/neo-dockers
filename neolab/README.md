# Neogenia ラボサイト

## Docker

使い方

```
docker build -t neolab .
docker run -d -p 8080:80 neolab
```

## BlueMix Container へのデプロイ手順

予めコンテナをビルドしておく。
`cf ic` プラグインをインストールしておくこと。
`cf login` で使用するBlueMixアカウントでログインしておくこと。
アカウントを切り替える場合は `cf logout` で一旦ログアウトすること。

```
# CFログイン
cf ic login

# IBM Containers Plugin の名前空間の設定、初期化
cf ic namespace set lobin002
cf ic init

# PUSHに先駆けてタグ付が必要
docker tag <image_id> registry.ng.bluemix.net/lobin002/neolab

# PUSH
docker push registry.ng.bluemix.net/lobin002/neolab

# コンテナ起動
cf ic run -p 80:80 -d --name neolab registry.ng.bluemix.net/lobin002/neolab
cf ic ps

# ログ確認
cf ic logs -f jenkins

# パブリックIP割当
cf ic ip list
cf ic ip request # 新しいIPを要求する場合
cf ic ip bind <ip_addr> <container_id>

```

コンテナを入れ替える

```
# IP解放
cf ic ip list
cf ic ip unbind <ip_addr> <container_id>

# コンテナを削除
cf ic stop <container_id>
cf ic rm <container_id>

# コンテナ起動からやり直す。PUSHは先にしておいても良い。
```
