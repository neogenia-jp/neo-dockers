# Develop environment suite for Ruby 2.5 web app

Target environment and frameworks are,
- Rails 5.x (hosting by Puma)
- Typescript
- Semantic UI
- MySQL
- Capybara + PhantomJS (Testing framework)

## build

```
./build.sh

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
docker push neogenia/ruby2.5-many-others
```

