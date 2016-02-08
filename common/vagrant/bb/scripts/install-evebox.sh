#!/bin/bash
#
# this script:
# 1) installs evebox
#
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

ELASTIC=$1

IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)

echo "installing evebox on ${IP} ${HOSTNAME} sets elasticsearch to ${ELASTIC} ..."

apt-get -y install unzip
cd /opt/
wget -4 -q https://bintray.com/artifact/download/jasonish/evebox/evebox-linux-amd64.zip
unzip evebox-linux-amd64.zip
/opt/evebox-linux-amd64/evebox --version
echo "http.cors.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
echo "http.cors.allow-origin: \"/.*/\"" >> /etc/elasticsearch/elasticsearch.yml
service elasticsearch restart
#/opt/evebox-linux-amd64/evebox > /var/log/evebox.log 2>&1 &
