# Develop environment suite for MariaDB FTS

Target environment and frameworks are,
- MariaDB
- Mroonga
- Mecab

## build

```
./build.sh [version_string]

# check
docker iamges
```

## push to DockerHub

```
# login
# - login to DockerHub using your DockerID and password.
# - require parmission for neogenia organization.
docker login

# push
docker push neogenia/mariadb-mroonga
```

