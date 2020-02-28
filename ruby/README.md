# Ruby language

Enjoy ruby 2.x environment !

## build

execute build script.

Syntax:
```
./build.sh [RUBY_VERSION] [BUILD_OPTIONS]
```

Example:
```
./build.sh 2.7.0 --with-jmalloc

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
docker push neogenia/ruby:2.x
```

