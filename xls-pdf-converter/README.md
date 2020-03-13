#  Convert xls or xlsx to pdf !

## usage

build & run container.
```sh
./build.sh
docker run -ti -e LISTEN_PORT=2222 -p2222:2222 -d neogenia/xls-pdf-converter

```

send excel file to container.
then receive converted pdf file.
```sh
nc 127.0.0.1 2222 < /path/to/input.xls > /path/to/output.pdf
nc 127.0.0.1 2222 < /path/to/input.xlsx > /path/to/output2.pdf
```


## push to DockerHub

```
# login
# - login to DockerHub using your DockerID and password.
# - require parmission for neogenia organization.
docker login

# push
docker push neogenia/xls-pdf-converter
```

