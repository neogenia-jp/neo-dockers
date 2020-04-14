#  Convert Excel files (xls or xlsx) to pdf/jpg/png !

## usage

build & run container.
```sh
./build.sh
docker run -ti -e LISTEN_PORT=2222 -p2222:2222 -d neogenia/excel-converter

```

send excel file to container.
then receive converted pdf file.
```sh
nc 127.0.0.1 2222 < /path/to/input.xls > /path/to/output.pdf
nc 127.0.0.1 2223 < /path/to/input.xlsx > /path/to/output2.jpg
nc 127.0.0.1 2224 < /path/to/input.xlsx > /path/to/output2.png
```


## push to DockerHub

```
# login
# - login to DockerHub using your DockerID and password.
# - require parmission for neogenia organization.
docker login

# push
docker push neogenia/excel-converter
```

