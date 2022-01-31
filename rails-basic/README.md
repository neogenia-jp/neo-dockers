# Develop environment suite for Ruby on Rails web app

Target environment and frameworks are,
- Rails 6.x (hosting by Puma)
- Typescript
- MySQL
- Capybara + Headless Chrome (Testing framework)

## build

```
./build.sh [ruby_version_string]

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
docker push neogenia/rails-basic
```
