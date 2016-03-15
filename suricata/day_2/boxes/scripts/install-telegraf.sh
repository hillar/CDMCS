#!/bin/bash
#
# this script:
# 1) installs telegraf
# 2) sets influxdb to $1
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

MASTER=$1
IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)

echo "installing telegraf on ${IP} ${HOSTNAME} setting influxdb to ${MASTER}"

TLGF=0.10.4.1
INSTALL_DIR=/provision

mkdir -p ${INSTALL_DIR}/telegraf
cd ${INSTALL_DIR}/telegraf
if [ ! -f "telegraf_${TLGF}-1_amd64.deb" ]; then
    wget -4 -q wget http://get.influxdb.org/telegraf/telegraf_${TLGF}-1_amd64.deb
fi
if [ ! -f "telegraf_${TLGF}-1_amd64.deb" ]; then
    echo "$(date) ${NAME} $0[$$]: {telegraf: {status:ERROR, msg: missing telegraf_${TLGF}_amd64.deb}"
    exit -1
else
  rm -rf /var/log/telegraf
  rm -rf /etc/telegraf
  apt-get -y remove --purge telegraf > /dev/null 2>&1
  #echo -e "Y"|
  dpkg -i telegraf_${TLGF}-1_amd64.deb > /dev/null 2>&1

cat > /etc/telegraf/telegraf.conf <<DELIM
[agent]
  interval = "1s"
  round_interval = true
  metric_buffer_limit = 10000
  flush_buffer_when_full = true
  collection_jitter = "0s"
  flush_interval = "60s"
  flush_jitter = "3s"
  debug = false
  quiet = false
[[outputs.influxdb]]
  urls = ["http://$MASTER:8086"] # required
  database = "telegraf" # required
  precision = "s"
DELIM
cat > /etc/telegraf/telegraf.d/common.conf <<DELIM
[[inputs.mem]]
[[inputs.cpu]]
[[inputs.disk]]
[[inputs.diskio]]
[[inputs.net]]
[[inputs.netstat]]
[[inputs.system]]
DELIM
cat > /etc/telegraf/telegraf.d/telegraf.conf <<DELIM
[[inputs.procstat]]
  pid_file = "/var/run/telegraf/telegraf.pid"
DELIM
  service telegraf restart  > /dev/null 2>&1
  #sleep 1
  #service telegraf status
fi
