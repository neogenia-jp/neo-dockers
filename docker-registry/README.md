### 社内Docker Registry設定

  社内サーバに立てている`Docker Hub`の内容のミラーリングサーバと、社内用（非公開）のDockerイメージを格納出来る社内用のDockerイメージサーバです。
  社内用Dockerイメージサーバは作ったイメージのバックアップ運用などはまだ未検討なので実験サーバです。
  
### 概要

  大きく2つのサーバの設定内容です。
  
  - Docker Hubから取得するDockerイメージのミラーリングサーバ(以下 `mirror-registry`)
  - 社内だけで有効なbuild済みのDockerイメージ格納サーバ（以下 `registry`)

### 導入サーバの前提

  - OS: CentOS 7.7.1511
  - Docker: 1.11.0

##### 用語
  <dl>
    <dt>registry host</dt>
    <dd>上記の導入サーバの前提で書いているCentOSを指します。</dd>
    <dt>mirroring registry server</dt>
    <dd>registry host上で動いているDocker Hubミラーリング用のDockerコンテナを指します。</dd>
    <dt>private registry server</dt>
    <dd>registry host上で動いているDockerイメージ提供用のDockerコンテナを指します。</dd>
    <dt>registry client</dt>
    <dd>各ユーザが使っているDockerのdaemonのことです。各ユーザから見た場合はDocker daemonがサーバになりますが、mirroring/private registry serverとの関係としてはクライアントになります。docker-machineを使っている場合は作成したdocker-machineがこれに当たります。</dd>
    <dt>docker client</dt>
    <dd>各ユーザが使っているDockerことです。日常直接操作しているDockerコマンドがこれに当たります。</dd>
  </dl>

### 各サーバの概要

  この`README.md`では概要のみで具体的にな設定内容については`doc`ディレクトリ以下の
  
  - [00-docker-registry-server-setting.md](https://github.com/neogenia-jp/neo-dockers/blob/feature-docker-registry/docker-registry/doc/00-docker-registry-server-setting.md)

    `registry host`の設定内容
  
  - [010-docker-registry-client-setting.md](https://github.com/neogenia-jp/neo-dockers/blob/feature-docker-registry/docker-registry/doc/010-docker-registry-client-setting.md)

    `registry client`の設定内容
    
  を参照してください。

#### ◆ registry host
##### 目的
  
  `mirroring registry server`, `private registry server`もdockerコンテナなのでそれらを動かすためのDockerホストです。ミラーリングしたイメージや社内用として`docker push`されたイメージはこのサーバの物理ディレクトリに保存されます。
  
#### ◆ mirroring registry server
##### 目的

  Docker Hubから毎回ダウンロードするとイメージのビルドがかなり遅くなる場合があるため、この`mirror-registry`を通して`docker pull`することで初回のみDocker Hubからイメージをダウンロードし、以降同じイメージはこの`mirroring registry server`上にキャッシュされているイメージのダウンロードとなりトラフィックの節約を行います。
  
##### 概要
   
  `registry client`は自分が持っていないDockerイメージを取得する際、Docker Hubから取得する前に`mirroring registry server`から取得しようとします。
  `mirroring registry server`は自分が持っていないイメージであればDocker Hubから取得しキャッシュした上で`registry client`にイメージを返します。
  
  `mirroring registry server`が落ちている場合は`registry client`自身がDocker Hubからイメージを取得するため`docker client`からは透過的にイメージのキャッシュ処理が行われることになります。
  
#### ◆ private registry server
##### 目的

  一般に公開できないが、ビルド済みイメージを共有したい場合に任意の環境に構築出来るDocker Hubのようなものです。
  完全にbuild済みのものを保存しているので、（イメージを作りなおさない限り）`apt-get`などタイミングにより異なる結果になることもなく常に同じイメージで作業できます。
  
##### 概要

  各`docker client`がビルドしたDockerイメージは`registry client`を通じて任意のイメージを`docker push`できます。
  また、`private registry server`にアクセス出来る任意`docker client`から`docker pull`可能です。

#### ◆ registry client
##### 概要

  docker daemon起動時の引数として上記の`mirroring registry server`と`private registry server`が渡されたうえで起動しているdocker daemonのことです。
  
#### ◆ docker client
##### 概要

  `mirroring registry server`に関しては特に設定は不要で、操作も通常通り行っていれば透過的にキャッシュを使用することになります。
  `private registry server`に関しても設定は不要で、dockerコマンドの引数に`private registry server`を指定することで`push`や`pull`の対象を切り替えることになります。
  
  
