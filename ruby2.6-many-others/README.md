# Develop environment suite for Ruby 2.6 web app

Target environment and frameworks are,
- Rails 5.2 or 6.0 (hosting by Puma)
- MySQL Client
- Node.js 14
- yarn
- Typescript 4.0
- Headless Chrome (for Integration Test)

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
docker push neogenia/ruby2.6-many-others
```

