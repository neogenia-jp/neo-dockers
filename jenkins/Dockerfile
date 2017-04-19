FROM ubuntu:xenial-20170214

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables
    
# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

RUN ln -s -f /bin/true /usr/bin/chfn

# Install Jenkins
WORKDIR /tmp
RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN echo 'deb http://pkg.jenkins-ci.org/debian binary/' >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update \
     && apt-get -y install default-jre-headless jenkins git \
     && apt-get clean

# Install for docker strage
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y linux-image-extra-$(uname -r) linux-image-extra-virtual

#add jenkins(user) to docker(group)
RUN gpasswd -a jenkins docker

#####################################################
# Time Zone
# RUN echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
RUN \cp -fp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

#####################################################
# ssh config
RUN mkdir /var/lib/jenkins/.ssh
ADD resources/_ssh/config /var/lib/jenkins/.ssh/
ADD resources/_ssh/id_rsa_neogenia_bot /var/lib/jenkins/.ssh/

RUN touch /var/lib/jenkins/.ssh/known_hosts \
     && ssh-keyscan github.com >> /var/lib/jenkins/.ssh/known_hosts \
     && chown -R jenkins /var/lib/jenkins/.ssh/*

#####################################################
# ssh config
RUN mkdir /var/lib/jenkins/.ssl
ADD resources/_ssl/.keystore /var/lib/jenkins/.ssl/

#####################################################
# jenkins setting
COPY resources/jenkins /var/lib/jenkins

RUN chown -R jenkins /var/lib/jenkins/*

#####################################################
# jenkins other setting
COPY resources/jenkins_custom_scripts /var/lib/jenkins_helper

# Run
# Install the modified wrapdocker
ADD resources/wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

WORKDIR /var/lib/jenkins
ADD resources/run.sh /tmp/run.sh
RUN chmod u+x /tmp/run.sh
ENTRYPOINT /tmp/run.sh
