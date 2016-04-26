### registry clientの設定
  `registry host`で起動している各コンテナを参照するようにDocker Daemonを起動します。
  

#### docker daemonの起動オプション変更

- `docker-machine`を使っている場合
  `docker-machine`を使っている場合`docker-machine`の作成時に`daemon`の起動オプションを設定して作らないと行けないため既に`default`という`docker-machine`が存在している状態から説明します。
  
  以下`docker-machine`は`default`という名前で作成するものとします。変更する場合は適宜読み替えてください。
  
  ```sh
  # defaultが動いている場合はまず止めます。
  docker-machine stop default
  
  # defaultを一旦削除します。このときビルド済みイメージもすべて消えるので注意
  docker-machine rm default
  
  # 起動オプションを指定してdocker-machineを再作成します。192.168.1.165がregistry host(CentOS)のアドレスです。
  docker-machine create \
  --driver virtualbox \
  --engine-registry-mirror http://192.168.1.165:5001 \
  --engine-insecure-registry 192.168.1.165:5002 \
  default
  ```
  
  これでvmの作成、起動まで行われるので machine起動後`docker-machine ssh`でログインし、
  
  ```
    docker@default:~$ grep 192.168.1.165 < /var/log/docker.log
    --insecure-registry 192.168.1.165:5002
    --registry-mirror http://192.168.1.165:5001
  ```
  
  となれば設定OK
