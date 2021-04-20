# SSH Jump Server

SSH踏み台サーバのための Docker コンテナです。

## ビルド

```
./build.sh
```

## 使い方

Dockerホスト側に開く SSH サーバのポート番号を指定してください。
例えば 10022 としたい場合、以下のようにします。

```
docker run -p10022:22 -d --name ssh-jump neogenia/ssh-jump:latest
```

docker-composeを使用する場合は、環境変数で指定できます。

```
cd /path/to/repository_root
SSHD_PORT=10022 docker-compose up --build
```

コンテナが起動したら、root ユーザ用の秘密鍵を以下のようにして取得します。

```
docker cp ssh-jump:/root/.ssh/id_ecdsa /tmp/
```

外部サーバから root ユーザでSSHログインするにはこの秘密鍵を使用します。

```
ssh -i /tmp/id_ecdsa -p5432 root@docker-host-ip
```

この秘密鍵は個別ユーザを登録するために使用することとし、常用するものではありません。
なお、個別のユーザを登録するには、ansible common playbook の利用を推奨します。

## Agent Forward のテスト

`docker-compose-jump-test.yml` ファイルを指定して docker-compsose を起動します。

```sh
docker-compose -f docker-compose-jump-test.yml up
```

以下のようにして各コンテナのIPアドレスを確認してシェル変数にセットします。
```sh
# コンテナの起動確認
$ sudo docker ps
CONTAINER ID        IMAGE              COMMAND                  CREATED              STATUS              PORTS   NAMES
d4b748c5907d        neogenia/ssh-jump  "/usr/sbin/sshd -D"      About a minute ago   Up About a minute   22/tcp  ssh-jump
c13f226bbd9e        neogenia/ssh-jump  "/usr/sbin/sshd -D"      About a minute ago   Up About a minute   22/tcp  target-server

# 踏み台サーバのIPアドレスを確認、シェル変数にセット
$ docker inspect ssh-jump | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "172.31.0.3",
$ SSH_JUMP_SV_IP=172.31.0.3

# 同様に、最終接続先サーバのIPアドレスを確認、シェル変数にセット
$ docker inspect target-server | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "172.31.0.2",
$ TARGET_SV_IP=172.31.0.2
```

Ansibleを使い、各コンテナにユーザ登録を行います。
```sh
# rootログイン用の秘密鍵を取得し、ansibleコンテナにコピー
docker cp ssh-jump:/root/.ssh/id_ecdsa /tmp
docker cp /tmp/id_ecdsa ansible:/root/.ssh/

# なお、秘密鍵ファイルのパーミッションは 600 か 400 でないとエラーになるので注意。

# ansibleインベントリファイルに秘密鍵へのパスを指定
[servers:vars]
ansible_ssh_private_key_file=/root/.ssh/id_ecdsa

# ansibleコンテナにて、playbook を実行
ansible-playbook -i inventories/development site.yml

# または、コマンドライン引数で秘密鍵を直接指定することも出来ます
ansible-playbook --private-key=/root/.ssh/id_ecdsa -i inventories/development site.yml
```

SSH 接続元にて、Agent Forwarding の設定を行います。
ここでは、ログインユーザ名を `user1` であるとして説明します。
実際のユーザ名は、 ansible で定義したユーザ名に読み替えてください。

```sh
# まず ssh-agent を起動し環境変数を登録
host> eval `ssh-agent`

# エージェントに鍵ファイルを登録
# ここでは ansible で定義したユーザの公開鍵に対応する秘密鍵を指定してください
host> ssh-add ~/.ssh/id_rsa

# 正しく登録されたか確認
host> ssh-add -l

# エージェント転送を有効にして踏み台サーバにSSH接続
host> ssh -A user1@172.31.0.2
```

これで踏み台サーバにログイン出来るはずです。
以降は踏み台サーバでの作業です。

```sh
# エージェント転送によりSSH接続先に秘密鍵が転送されているか確認
[lobin@dafe75307b87 ~]$ ssh -l

# 踏み台よりターゲットサーバにログイン
[lobin@dafe75307b87 ~]$ ssh -A 172.31.0.3
```

ターゲットサーバにログイン出来たら成功です。
あとは必要に応じてSSHエージェントに秘密鍵を追加登録していくことが出来ます。

## Agent Forward を設定ファイルに書く

`~/.ssh/ssh_config` ファイルに以下を記述してください。
```
# どんな接続先に対しても Agent Forward を行う
Host *
  SendEnv LANG LC_*
  ForwardAgent no
```

これで `-A` オプション無しでもエージェント転送してくれるようになります。

多段sshの設定をするには、以下のように記述してください。

```
# 踏み台サーバ
Host the-ssh-jump
  HostName       172.31.0.2
  User           lobin
  #LocalForward   10025 localhost:10025
  ForwardAgent   yes

# ターゲットサーバ（踏み台経由）
Host target-server
  HostName       172.31.0.3
  User           lobin
  #LocalForward   10025 host2.hoge.fuga:25
  ProxyCommand   ssh -CW %h:%p the-ssh-jump  # 踏み台を経由する
  ForwardAgent   yes

# デフォルト設定
Host *
  SendEnv LANG LC_*
  ForwardAgent no  # デフォルトは Agent転送 なし
```

これで踏み台経由の多段SSHが単純なコマンドで出来るようになります。
（前提として SSH Agentに正しく認証鍵を登録しておく必要があります）

```sh
ssh target-server
```

必要に応じて `LocalForward` などの設定を追加することも出来ます。


## SSH Agent を自動起動する

シェルを開いたときに自動的に SSH Agent を起動して環境変数を設定してくれるようにしておくと便利です。

macOS の場合、`~/.zshrc` に以下を追記してください。
bash やその他のシェルを使用している環境では、適宜書き換えてください。

```
SSH_KEY_LIFE_TIME_SEC=36000
SSH_AGENT_FILE="$HOME/.ssh-agent-info"
test -f $SSH_AGENT_FILE && source $SSH_AGENT_FILE
if ! ssh-add -l >& /dev/null ; then
  ssh-agent -t ${SSH_KEY_LIFE_TIME_SEC:-3600} > $SSH_AGENT_FILE
  source $SSH_AGENT_FILE
  ssh-add
fi
```

[参考1](http://blog.manaten.net/entry/ssh-agent-forward)
[参考2](http://mashi.exciton.jp/archives/tag/%E7%A7%98%E5%AF%86%E9%8D%B5)


## SSH ログイン時の通知

踏み台サーバにSSHログインが行われた際に、通知を飛ばすことが出来ます。
現在対応している通知の方法は、以下のとおりです。

1. メール通知

    環境変数 `NOTIFY_MAIL_TO` に送信先メールアドレスを設定してください。

2. WebHook

    Mattermost などのチャットサービスに投稿するような用途を想定しています。
    環境変数 `NOTIFY_WEBHOOK_URL` に URL を設定してください。

実行例:
```
docker run -p10022:22 -d --name ssh-jump \
  -e CONTAINER_NAME=ssh-jump-$HOSTNAME \
  -e NOTIFY_WEBHOOK_URL=https://chat.neogenia.co.jp/hooks/xxxxxxxx \
  neogenia/ssh-jump:latest
```

docker-composeを使用する場合は、以下のようにします。
```
cd /path/to/repository_root
SSHD_PORT=10022 \
  CONTAINER_NAME=ssh-jump-$HOSTNAME \
  NOTIFY_WEBHOOK_URL=https://chat.neogenia.co.jp/hooks/xxxxxxxx \
  docker-compose up
```
