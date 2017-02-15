# Redmine All in One Dokcer

## Usage

```
docker build --build-arg cert_email=xxx@examle.com -t redmine .
docker run --name redmine -ti -p 80:80 -p443:443 redmine
```

Please access `https://localhost:443/` in your browser.

## Software architecture

- Docker container
  - MySQL Server
  - Redmine
  - Nginx (reverse proxy, http2)
  - crond (for Let's encrypt certbot)

## Build arguments

- app_domain: domain for gosting
  e.g, redmine.exapmle.com
- cert_email: email address for SSL cert of Let's encrypt.
  e.g, xxx@examle.com
- gmail_addr: Gmail address for notification of redmine.
  e.g, xxx@gmail.com
- gmail_passwd: Gmail password.
  e.g, 12345678

Full specifications is
```
docker build -t redmine \
 --build-arg app_domain=redmine.example.com \
 --build-arg cert_email=xxx@example.com \
 --build-arg gmail_addr=xxx@gmail.com \
 --build-arg gmail_passwd=12345678 \
 .
```

## Data migration

### Database (MySQL)
Please put sql (by mysqldump) to `resources/scripts/old_data.dmp`.

### Attachment files
Please put tgz to `resources/redmine/data/files.tgz`.

### Mercurial(hg) repos
Please put tgz to `resources/redmine/data/hg.tgz`.


## Let's encrypt

### Initialize

example:

```
/usr/share/redmine# cd /etc/letsencrypt/live/
/etc/letsencrypt/live# ls
redmine.neogenia.co.jp
/etc/letsencrypt/live# rm -rf redmine.neogenia.co.jp/
/etc/letsencrypt/live# cd /var/scripts/
/var/scripts# ./run_certbot.sh

IMPORTANT NOTES:
 - If you lose your account credentials, you can recover through
   e-mails sent to w.maeda@neogenia.co.jp.
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/redmine.neogenia.co.jp/fullchain.pem. Your
   cert will expire on 2017-05-16. To obtain a new version of the
   certificate in the future, simply run Let's Encrypt again.
 - Your account credentials have been saved in your Let's Encrypt
   configuration directory at /etc/letsencrypt. You should make a
   secure backup of this folder now. This configuration directory will
   also contain certificates and private keys obtained by Let's
   Encrypt so making regular backups of this folder is ideal.
 - If you like Let's Encrypt, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le

/var/scripts# /etc/init.d/nginx reload
 * Reloading nginx configuration nginx
   ...done.
/var/scripts#
```

### Update

Updates are done automaticary by crond.

