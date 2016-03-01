#!/bin/bash
#
# this script
#  installs kibana
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

KBN=4.4
IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)

ELASTIC=$1
echo "installing kibana$KBN on $IP $HOSTNAME setting elastic to $ELASTIC"



wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add - > /dev/null 2>&1
echo 'deb http://packages.elastic.co/kibana/'${KBN}'/debian stable main' > /etc/apt/sources.list.d/kibana.list
apt-get update > /dev/null 2>&1
apt-get -y install kibana > /dev/null 2>&1
/opt/kibana/bin/kibana plugin -i kibana/timelion > /dev/null 2>&1
#chown -R kibana.kibana /opt/kibana/optimize/
# server.host: "0.0.0.0"
sed -i -e 's,# server.host: "0.0.0.0",server.host: "'${IP}'",g' /opt/kibana/config/kibana.yml
# elasticsearch.url: "http://10.242.11.29:9200"
sed -i -e 's,# elasticsearch.url: "http://localhost:9200",elasticsearch.url: "http://'${ELASTIC}':9200",g' /opt/kibana/config/kibana.yml
chown -R kibana:kibana /opt/kibana/optimize/
service kibana start > /dev/null 2>&1
cat > /etc/telegraf/telegraf.d/kibana.conf <<DELIM
[[inputs.procstat]]
  pid_file = "/var/run/kibana.pid"
DELIM
service telegraf restart  > /dev/null 2>&1
