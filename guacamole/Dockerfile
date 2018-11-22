FROM ubuntu:trusty-20181115

LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# install dependency packeages
RUN apt-get update \
 && apt-get install -y git nginx

# setup FreeRDP-WebConnect and dependencies
RUN git clone https://github.com/FreeRDP/FreeRDP-WebConnect.git \
#RUN git clone https://github.com/DashLt/FreeRDP-WebConnect.git \
 && cd FreeRDP-WebConnect \
# && git merge origin/patch-1 \
 && ./setup-all.sh -f -i -d

# link the wsgate webroot dir to the nginx document root dir
RUN ln -s /root/FreeRDP-WebConnect/wsgate/build/webroot /usr/share/nginx/html/wsgate

CMD ["nginx -g 'daemon off'"]
#CMD ["service nginx start && tail -f /var/log/nginx/*.log"]

EXPOSE 80

