# Wordpress with http2

## Usage

```
docker build --build-arg cert_email=xxx@examle.com -t wordpress .
docker run --name wp -ti -p 80:80 -p443:443 wordpress
```

Please access `https://localhost:443/` in your browser.

## Software architecture

- Docker container
  - MariaDB Server
  - PHP 5.6 + FPM
  - Wordpress
  - Nginx (reverse proxy, http2)
  - crond (for Let's encrypt certbot)

## Build arguments

- app_domain: domain for hosting
  e.g, wordpress.exapmle.com
- cert_email: email address for SSL cert of Let's encrypt.
  e.g, xxx@examle.com

Full specifications is
```
docker build -t wordpress \
 --build-arg app_domain=www.neogenia.co.jp \
 --build-arg cert_email=contact@neogenia.co.jp \
 .
```

## Data migration

### Database (MySQL)
Please put sql (by mysqldump) to `resources/scripts/data/old_data.sql`.

### wp-content files
Please put tgz to `resources/scripts/data/wp-content.tgz`.


## Let's encrypt

### Initialize

https://qiita.com/tkykmw/items/9b6ba55bb2a6a5d90963

test:

```
# /var/scripts/run_certbot.sh --test-cert
```

for production:

```
# /var/scripts/run_certbot.sh --force-renewal
```

### Update

Updates are done automatically by crond.

manual update:

```
# letsencrypt renew --no-self-upgrade
# servie nginx reload
```

