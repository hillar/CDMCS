#!/bin/bash
#
# this script
#  installs kibana
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

INSTALL_DIR=/provision
KBN=4.3.1
IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)


mkdir -p ${INSTALL_DIR}/kibana
cd ${INSTALL_DIR}/kibana
if [ ! -f "kibana-${KBN}-linux-x64.tar.gz" ]; then
  wget -4 -q https://download.elastic.co/kibana/kibana/kibana-${KBN}-linux-x64.tar.gz
fi
mkdir /opt
cd /opt
tar -xzf ${INSTALL_DIR}/kibana/kibana-${KBN}-linux-x64.tar.gz
ln -sf /opt/kibana-4.3.1-linux-x64 /opt/kibana
/opt/kibana/bin/kibana plugin -i kibana/timelion
#chown -R kibana.kibana /opt/kibana/optimize/
# server.host: "0.0.0.0"
sed -i -e 's,# server.host: "0.0.0.0",server.host: "'${IP}'",g' /opt/kibana/config/kibana.yml
# elasticsearch.url: "http://10.242.11.29:9200"
sed -i -e 's,# elasticsearch.url: "http://localhost:9200",elasticsearch.url: "http://'${IP}':9200",g' /opt/kibana/config/kibana.yml

nohup /opt/kibana/bin/kibana > /var/log/kibana.log 2>&1 &
