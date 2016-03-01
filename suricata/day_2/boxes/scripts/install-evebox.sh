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

apt-get -y install unzip > /dev/null 2>&1
cd /opt/
wget -4 -q https://bintray.com/artifact/download/jasonish/evebox/evebox-linux-amd64.zip
unzip -o evebox-linux-amd64.zip
/opt/evebox-linux-amd64/evebox --version
echo "http.cors.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
echo "http.cors.allow-origin: \"/.*/\"" >> /etc/elasticsearch/elasticsearch.yml
service elasticsearch restart > /dev/null 2>&1

ln -s /opt/evebox-linux-amd64 /opt/evebox
ln -s /opt/evebox-linux-amd64/evebox /opt/evebox-linux-amd64/evebox-server
adduser --system evebox > /dev/null 2>&1

cat > /etc/default/evebox-server <<DELIM
LOG_DIR=/var/log/evebox
DELIM
wget -4 -q https://raw.githubusercontent.com/hillar/CDMCS/master/suricata/day_2/boxes/scripts/evebox-server  -O /etc/init.d/evebox-server
chmod +x /etc/init.d/evebox-server

update-rc.d evebox-server defaults 95 10 > /dev/null 2>&1

service evebox-server start > /dev/null 2>&1


cat > /etc/telegraf/telegraf.d/evebox.conf <<DELIM
[[inputs.procstat]]
  pid_file = "/var/run/evebox-server.pid"
DELIM
service telegraf restart > /dev/null 2>&1
