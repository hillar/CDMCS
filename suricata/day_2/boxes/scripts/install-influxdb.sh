#!/bin/bash
#
# this script:
# 1) installs influxdb
# 2) sets influxdb to $1
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

BIND=$1
IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)

echo "installing influxdb on ${IP} ${HOSTNAME} setting bind to ${BIND}..."

INSTALL_DIR=/var/cache/wget



#https://dl.influxdata.com/influxdb/releases/influxdb_0.13.0~rc2_amd64.deb
INFLX="0.13.0~rc2"

mkdir -p ${INSTALL_DIR}
cd ${INSTALL_DIR}
if [ ! -f "influxdb_${INFLX}_amd64.deb" ]; then
   wget -N -P /var/cache/wget -4 -q https://dl.influxdata.com/influxdb/releases/influxdb_${INFLX}_amd64.deb
fi
if [ ! -f "influxdb_${INFLX}_amd64.deb" ]; then
  echo "$(date) ${NAME} $0[$$]: {influxdb: {status:ERROR, msg: missing influxdb_${INFLX}_amd64.deb}"
  exit -1
else
  echo -e "Y"|dpkg -i influxdb_${INFLX}_amd64.deb > /dev/null 2>&1
  service influxdb start > /dev/null 2>&1
  sleep 1
  service influxdb status
  #prepare for telegraf

  service telegraf stop > /dev/null 2>&1
  curl -s -XPOST http://localhost:8086/query --data-urlencode "q=DROP DATABASE telegraf"
  curl -s -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE telegraf"
  curl -s -XPOST http://localhost:8086/query --data-urlencode "q=CREATE RETENTION POLICY one_day_only ON telegraf DURATION 1d REPLICATION 1 DEFAULT"
  #sed -i -e 's,localhost,'${METRICS_SERVER}',g' /etc/influxdb/influxdb.conf
cat > /etc/telegraf/telegraf.d/influxdb.conf <<DELIM
[[inputs.influxdb]]
  urls = ["http://127.0.0.1:8086/debug/vars"]
[[inputs.procstat]]
  pid_file = "/var/run/influxdb/influxd.pid"
DELIM
  service telegraf start > /dev/null  2>&1
  sleep 1
  service telegraf status
fi
