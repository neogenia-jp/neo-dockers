# 汎用 Ansible Playbook

## 事前準備（初期化）

`ansible-galaxy` コマンドで 外部Role を取得します。
```bash
ansible-galaxy install -p roles -r requirements.yml
```

## Roles

梱包されている Role の概要説明です。
詳細は、各 Role ディレクトリにある REAMDE を参照してください。

### common

### install_packages

汎用的な yum install を行うための Role です。
インストールしたいパッケージは外部変数で定義できます。

### install_ruby26

Ruby 2.6 をインストールします。
追加で gem をインストールすることも出来ます。

### install_zabbix_agent

Zabbix Agent をインストールし、設定します。

### users

OSユーザの管理を行います。
ユーザ登録、削除に合わせてSSH鍵の登録も行うことが出来ます。

## 参考リンク集

[Ansible でコマンドの出力を後の task で使う](https://blog.1q77.com/2014/02/ansible-register/)
