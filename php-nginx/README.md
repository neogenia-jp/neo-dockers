# PHP and Nginx

Enjoy PHP with nginx environment !

- Centos 7.x
- PHP 7.x
- nginx & phpfpm
- composer
- NodeJS 12

## build

execute build script.

Syntax:
```
./build.sh [PHP_VERSION] [COMPOSER_VERSION]
```

Example:
```
./build.sh 7.2

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
docker push neogenia/php-nginx:$TAG
```

