#!/bin/bash

/usr/local/bin/wrapdocker &
java -DJENKINS_HOME=/var/lib/jenkins \
 -Dorg.apache.commons.jelly.tags.fmt.timeZone=Asia/Tokyo \
 -Dfile.encoding=UTF-8 \
 -jar /usr/share/jenkins/jenkins.war \
 --webroot=/var/cache/jenkins/war \
 --httpPort=-1 \
 --httpsPort=8443 \
 --httpsKeyStore=/var/lib/jenkins/.ssl/.keystore \
 --httpsKeyStorePassword=ne0gen1a-ssl-keystore 
