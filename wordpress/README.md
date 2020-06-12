# Wordpress

## Usage

```
docker build -t wordpress .
docker run --name wp -ti -p 8080:8080 wordpress
```

Please access `http://localhost:8080/` in your browser.

## Software architecture

- Docker container
  - MariaDB Server
  - PHP 7.2 + FPM
  - Wordpress
  - Nginx

## Data migration

### wp-content files
Please mount to `/var/www/wordpress/`

### Database (MySQL)
Please put sql (by mysqldump) to `/var/www/wordpress/old_data.sql.gz`.

