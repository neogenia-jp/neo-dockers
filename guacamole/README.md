# Apache Guacamole with HTTPS

Apache Guacamole is HTML5-based remote desktop client.
supported remote desktop protocols:
- RDP
- VNC
- SSH

https://guacamole.apache.org/

Enjoy remote desktop environment !

## Usage

```
sudo ./run.sh <DOMAIN_NAME> <HTTPS_CERT_EMAIL>
open 'http://localhost:8080/guacamole/'
```

For example:
```
sudo ./run.sh localhost.localdomain test@example.com
```

## How to setup Let's Encrypt

Use `setup_letsencrypt.sh`.

```
$ sudo docker exec -ti guacamole_nginx_1 bash
root@69dd3eff37fc:/# rm -rf /etc/letsencrypt/*
root@69dd3eff37fc:/# /var/scripts/setup_letsencrypt.sh --force-renewal
root@69dd3eff37fc:/# service nginx reload
```

## How to initialize (reset mysql data)

Please remove mysql data volume.

```
$ sudo docker volume ls
DRIVER              VOLUME NAME
local               guacamole_guac_mysql_data_volume
$ sudo docker volume rm guacamole_guac_mysql_data_volume
guacamole_guac_mysql_data_volume
$
```

