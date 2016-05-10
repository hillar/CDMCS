#!/bin/bash
#
# this script:
# 1) installs grafana
#
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)

echo "installing grafana on ${IP} ${HOSTNAME}"

INSTALL_DIR=/var/cache/wget

#https://grafanarel.s3.amazonaws.com/builds/grafana_3.0.0-beta71462173753_amd64.deb
GRFN="3.0.0-beta71462173753"
mkdir -p ${INSTALL_DIR}
cd ${INSTALL_DIR}
if [ ! -f "grafana_${GRFN}_amd64.deb" ]; then
  wget -N -P /var/cache/wget -4 -q https://grafanarel.s3.amazonaws.com/builds/grafana_${GRFN}_amd64.deb
fi
if [ ! -f "grafana_${GRFN}_amd64.deb" ]; then
  echo "$(date) ${HOSTNAME} $0[$$]: {grafana: {status:WARNING, msg: missing grafana_${GRFN}_amd64.deb}"
  #exit -1
else
  #rm /var/lib/grafana/grafana.db
  apt-get install -y adduser libfontconfig > /dev/null 2>&1
  echo -e "Y"|dpkg -i grafana_${GRFN}_amd64.deb > /dev/null 2>&1
  update-rc.d grafana-server defaults 95 10 > /dev/null 2>&1
  sed -i -e 's,domain = localhost,domain = '${IP}',g' /etc/grafana/grafana.ini
  service grafana-server start > /dev/null 2>&1
  sleep 1
  apt-get -y install sqlite > /dev/null 2>&1
  sqlite3 /var/lib/grafana/grafana.db "INSERT INTO \"data_source\" VALUES(1,1,0,\"influxdb\",\"telegraf\",\"proxy\",\"http://$IP:8086\",\"admin\",\"admin\",\"telegraf\",0,\"\",\"\",1,\"{}\",\"2016-03-07 18:21:44\",\"2016-03-07 18:50:56\",0);"

  #service grafana-server status
  #service telegraf stop  > /dev/null 2>&1
cat > /etc/telegraf/telegraf.d/grafana.conf <<DELIM
[[inputs.procstat]]
  pid_file = "/var/run/grafana-server.pid"
DELIM
  service telegraf restart  > /dev/null 2>&1
  #sleep 1
  #service telegraf status
fi
