### registry hostの設定
 `systemd`で自動起動するための設定(`usr`以下)と`registry`Dockerコンテナの設定(`var`以下)
 
#### 必要ファイル
  リポジトリ内の`neo-dockers/docker-registry/server`を`registry host`の`/`に読み替えてその配置に通りファイルを置いてください。
  
  
  ```
  docker-registry
  └── server
      ├── usr
      │   └── lib
      │       └── systemd
      │           └── system
      │               ├── docker-mirror-registry.service
      │               └── docker-registry.service
      └── var
          └── docker
              ├── mirror-registry
              │   └── config.yml
              └── registry
                  └── config.yml
  ```

#### systemdで`mirroring/private registry server`の自動起動設定を行う
  
  それぞれ内容としては単純で`docker.service`でDocker Daemonが起動した後に、既に作成済みの各コンテナを`docker start`させるという設定です。
  
  - `mirroring registry server`の自動起動設定
  
  ```sh
  systemctl enable docker-mirror-registry.service
  ```
  
  - `private registry server`の自動起動設定
  
  ```sh
  systemctl enable docker-registry.service
  ```
  
#### `mirroring/private registry server`コンテナの作成、起動
  
  `mirroring`と`private`はともに同じ`registry`Dockerイメージで起動時の設定ファイルと待受ポートが異なるだけです。
  
  - `mirroring registry server`コンテナ起動
  ```sh
  docker run -d -p 5001:5000 --name v2-mirror   -v /var/docker/mirror-registry:/var/lib/registry registry:2 serve /var/lib/registry/config.yml
  ```
    
  キャッシュされたイメージはコンテナにマウントされたCentOS内の`/var/docker/mirror-registry`以下に保存されます。
  
  - `private registry server`コンテナ起動  
  ```sh
  docker run -d -p 5002:5000 --name v2-registry -v /var/docker/registry:/var/lib/registry        registry:2 serve /var/lib/registry/config.yml
  ```
  `docker push`されたイメージはコンテナにマウントされたCentOS内の`/var/docker/registry`以下に保存されます。
  

#### registryに対するWeb APIアクセス

  `docker registry`は各種WEB APIがあるのでそれ経由でregistryの状態を確認できます。

  - `mirroring registry server`にどんなイメージがミラーリングされているかを一覧で取得
  ```
  % curl 192.168.1.165:5001/v2/_catalog
  {"repositories":["library/busybox","library/mariadb","library/redis","library/ubuntu","microsoft/aspnet"]}
  ```

