#Jenkinsサーバ用Dockerfile

##概要
  CI環境構築用のDockerコンテナです。
  
  下記の環境が構築されます。
  
  - Jenkins自体もDockerホストになっており、各アプリケーション用のDockerコンテナを起動してテストを行う
  
  - このDockerfile自体で提供するJOB
    - 単純なHello, World ジョブ(動作確認用)
    - [neogenia-jp/practice](https://github.com/neogenia-jp/practice)の[sample-testブランチ](https://github.com/neogenia-jp/practice/tree/sample-test)にpushされた時に動くpractice-build-hookジョブ
    
      Githubの側にGithubへのpushがトリガーとなって実行されるwebhookを登録しており、そのhookから起動されるジョブ。このジョブで後述のpractice-buildジョブを起動します。
    - [neogenia-jp/practice](https://github.com/neogenia-jp/practice)の[sample-testブランチ](https://github.com/neogenia-jp/practice/tree/sample-test)をテストするジョブ
    
      githubから取得してsample-testブランチ内にあるDockerfileからテスト環境を構築、テスト実行まで行います。
     
### 各種バージョン
  - ホストOS: Ubuntu 14.04.3 LTS
  - ホストOS上のDocker: 1.7.1
  
##Dockerイメージ作成
  - リポジトリをclone

  ```sh
  $ git clone git@github.com:neogenia-jp/neo-dockers.git`
  $ cd neo-dockers/jenkins
  ```
  
  - Dockerイメージ作成
  
  ```sh
  $ docker build -t jenkins:v1 .
  ```
  
  - Dockerコンテナ起動
    jenkinsコンテナの中でDockerを使うので、jenkinsコンテナ自体は特権モード(--privileged)で起動する

  ```sh
  $ docker run --privileged -p 8443:8443 -d --name jenkins jenkins:v1
  ```
  
  下記が出力されていればjenkinsの起動が完了しています。
  
  ```sh
  $ docker logs -f jenkins
    ... 略 ...
    INFO: Finished Download metadata. 9,892 ms
  ```
  
  - jenkinsにアクセス
  - 
    - ssl証明書警告画面
    
      ブラウザから`https://(your docker host ip):8443/`にアクセスします。
      独自に発行したSSL証明書なので警告が出るはずです。信頼するを選択して進めてください。

    - ログイン画面
      - ユーザ名: neogenia-jenkins
      - パスワード: n-j-ne0gen1a
    
      でログインします。

###各種補足
#### jenkins内でのDocker実行について
jenkins自体もDockerホストになっており、Docker in Dockerという構成になっています。
このため、jenkins内でのDockerデーモン起動用にwrapdockerというスクリプトがありここでdockerデーモン用の各種設定をして起動しています。(Docker in Docker などでGoogle検索すると色々情報があると思います)

#### ssh設定
jenkinsからneogenia-jpのgithubリポジトリにアクセスするため、`neogenia-bot`というgithubユーザ用のssh証明書とgithub.comへのsshの設定を行っています。

#### ssl設定
jenkinsは組み込みのwebサーバのJettyで実行されており、https接続用の証明書ファイルなどが
`/var/lib/jenkins/.ssl`フォルダに格納されています。

sslの証明書は

`keytool -genkey -alias jenkins-ssl-cert -keyalg RSA -keystore _ssl/.keystore -validity 7300`

で作成しています。パスフレーズは`resources/run.sh`を参照してください。

##作成したJenkinsコンテナについて
jenkins自体に変更を加えて（プラグイン追加、ジョブ追加など)もdockerコンテナを削除してしまうと保存されません。

今後Dockerfileとは別にビルド済みDockerイメージをプライベートな環境でホスティングするようなイメージでいるため、このDockerイメージ自体を継承(Dockerfileの`FROM`）する想定で、各種環境ごとのカスタマイズは各環境自体で行うように想定しています。（例えば`VOLUME`が必要であれば継承した側で設定)

ただし、横断的に有用であるような設定はこのDockerfileに反映したほうが良いため、コンテナの設定であれば、このDockerfileを、Jenkinsの設定変更であれば、後述のjenkinsバックアップの方法で取得した内容で`resources/jenkins`の内容を置き換えてください。

##バックアップ
Jenkinsを実際に起動した上で管理画面から各種設定、プラグイン作成などを行うことになりますが、↑で記述したように現状はコンテナの内容はホストに連動させないようになっています。

また、プラグインなどを追加した場合そのままバックアップすると不要なファイルも多いため、Jenkinsコンテナ内にJenkinsのバックアップ用のスクリプトを格納していますので、下記の手順でバックアップファイルを作成してホスト側で利用してください。

下記のようなケースを想定しています。
(以下ホストOS側でのプロンプトを`$`、jenkinsコンテナ内でのプロンプトを`$$`と表記します)

- Jenkinsコンテナを起動
  このDockerコンテナに追加した方が良いと思われるようなJenkinsの設定を管理画面で行い、それを保存したいとする。

- Jenkinsコンテナにアタッチする
  jenkinsのホストOSから

  ```sh
  $ docker exec -it jenkins /bin/bash
  ```
  
- Jenkinsのバックアップを行う
  で接続し、バックアップスクリプト(`jenkins_backup.sh`)を実行する。
  
  ```sh
  $$ cd /var/lib/jenkins_helper/backup
  $$ ./jenkins_backup.sh /var/lib/jenkins jenkins_backup.tar.bz2
  ```
  
  (./jenkins_backup.sh Jenkinsのホーム バックアップファイル名（現状は.tar.bz2固定）)
  
  バックアップが完了すると、下記の場所にファイルが作成されます。
  
  ```sh
  $$ /var/lib/jenkins_helper/backup/tmp
  $$ ls
  jenkins_backup.tar.bz2
  ```
  
  この設定でバックアップされるものは

    - 各Jenkinsの設定情報
    - JOB情報
    - インストールしたPluginの情報
  
  です。ビルド履歴などはバックアップ対象外です。

  バックアップまで終了したら一旦コンテナから出ます。
  
  ```sh
  $$ exit
  ```
  
- ホストOS側からJenkinsコンテナ内のバックアップファイルを取得

  `docker cp`コマンドで先ほど作成したJenkinsのバックアップファイルをホスト側にコピーします。

  ```sh
  $ docker cp jenkins:/var/lib/jenkins_helper/backup/tmp/jenkins_backup.tar.bz2 .
  ```
  
  このjenkins_backup.tar.bz2の内容(正確にはこのアーカイブの中の`jenkins-backup`ディレクトリ以下）がこのDockerfileの`resources/jenkins/`以下の内容に相当します。反映する場合は適宜置き換えてください。
  
  
