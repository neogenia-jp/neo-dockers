# Redmine All in One Dokcer

## Quick start

```
docker build -t redmine docker/
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

## Persistence

Mount a Docker volume or the file system of host to `/var/lib/mysql`.

```
# create a volume for the first time only.
docker volume create redmine_mysql_data

# mount the volume when you start the container using '-v' option.
# for example:
docker run \
 -v redmine_mysql_data:/var/lib/mysql ...
```

## Data migration

Place the data you want to migrate in the `data` directory,
and mount the some directories in your container.


### Database (MySQL)

Mount gzipped sql file (by mysqldump) to `/mnt/mysql_data.sql.gz` in your container.
The file is automatically loaded when the container is started.
```
# mount the file when you start the container using '-v' option.
docker run \
 -v /path/to/mysql_dump_file.sql.gz:/mnt/mysql_data.sql.gz ...
```

### Attachment files

Mount `data/files/` directory to `/usr/share/redmine/files/` in your container.
```
# mount a directory when you start the container using '-v' option.
docker run \
 -v `pwd`/data/files:/usr/share/redmine/files ...
```

or

Extract backup archive files to `/usr/share/redmine/files/` in your container.

### Mercurial(hg) repos

Mount `data/hg/` directory to `/var/hg/`.
```
# mount a directory when you start the container using '-v' option.
docker run \
 -v `pwd`/data/hg:/var/hg ...
```

or

Extract backup archive files to `/var/hg/` in your container.

