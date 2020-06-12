# Redmine All in One Dokcer

## Usage

```
docker build --build-arg -t redmine .
docker run --name redmine -ti -p 3000:3000 redmine
```

Please access `http://localhost:3000/` in your browser.

## Software architecture

- Docker container
  - MySQL Server
  - Redmine

## Build arguments

- gmail_addr: Gmail address for notification of redmine.
  e.g, xxx@gmail.com
- gmail_passwd: Gmail password.
  e.g, 12345678

Full specifications is
```
docker build -t redmine \
 --build-arg gmail_addr=xxx@gmail.com \
 --build-arg gmail_passwd=12345678 \
 .
```

## Data migration

### Database (MySQL)
Please put sql (by mysqldump) to `resources/scripts/old_data.dmp`.

### Attachment files
Please mounto to `/usr/share/redmine/instances/default/files/`.

### Mercurial(hg) repos
Please mount to `/var/hg/`.

