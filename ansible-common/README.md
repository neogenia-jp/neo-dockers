# docker-ansible

## ディレクトリ構成
```
.
├── README.md
├── docker
│   ├── ansible
│   │   └── Dockerfile      ansibleのDocerfile
│   └── target
│        └── Dockerfile      targetのDockerfile
├── docker-compose.yml        docker-composeファイル
├── build.sh                  ansible-server をビルドするためのスクリプト
├── exec-playbook.sh          ansible-playbook を直接実行するためのスクリプト
└── sample_playboook/
     ├── inventry.ini         hostsファイル
     └── playbook.yml         playbookファイル
```

## サンプルPlayBookの実行

検証用ターゲットコンテナに対して、サンプルPlayBookを実行する手順を説明します。
このサンプルを実行しても検証用コンテナに対してのみ作用しますので、他の環境には一切影響ありません。

1. Dockerコンテナの起動
```
docker-compose up -d --build
```

2. Ansibleコンテナに接続
```
docker exec -it ansible bash
```

3. target01, target02に対し、sshの接続確認
```
ssh target01    # yesで接続
exit
ssh target02    # yesで接続
exit
```

4. target01, target02に対し、ansibleコマンドを実行
```
ansible-playbook -i inventry.ini playbook.yml
```

5. target01, target02に再接続し、hogeが追加されていることを確認
```
ssh target01
ls
exit
ssh target02
ls
```

## 特定のPlayBookの実行

他のディレクトリにあるPlayBookを実行する手順を説明します。
検証用ターゲットコンテナを使用せず、ansible-serverコンテナからアクセス可能なターゲットに対して作用します。

1. playbook が置いてあるディレクトリの確認

ここでは、 `/home/neo/playbook1/` に置いてあるものとして説明します。
適宜読み替えてください。

2. 環境変数で playbook ディレクトリを指定し、Ansibleサーバを単体で起動します。
```
PLAYBOOK_ROOT=/home/neo/playbook1/ docker-compose up -d --build ansible
```

3. bashでコンテナに入ります
```
docker exec -it ansible bash
```

4. playbookを実行します
```
# コンテナ内で実行
# 必要に応じてコマンドライン引数を書き換えてください
ansible-playbook -i inventry.ini playbook.yml

# または、Dockerホストから直接playbookを実行できるスクリプトを使ってください
./exec-playbook.sh /home/neo/playbook1/ -i inventry.ini playbook.yml
```

## SSH接続設定

ターゲットサーバへのSSH接続設定をカスタマイズする場合は、
`inventories/` 配下のインベントリファイルに以下のように記述してください。

```
[webservers:vars]
ansible_port=(sshのポート番号、デフォルト22)
ansible_user=(ssh接続先のユーザー名)
ansible_ssh_pass=(パスワード)
ansible_ssh_private_key_file=(秘密鍵のパス (~/.ssh/id_rsa など))
```

また、秘密鍵ファイルの指定だけ行いたい場合は、以下のようにコマンドラインオプションで指定する方法もあります。

```
ansible-playbook --private-key=/path/to/private_key_file -i inventories/development site.yml
```

