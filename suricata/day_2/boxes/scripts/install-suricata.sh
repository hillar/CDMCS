#!/bin/bash
#
# this script
# 0) sets gro,gso,lro,tso off
# 1) addp oisf ppa
# 2) installs suricata
# 3) sets suricata conf as amsterdam
# 4)


if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)

ETH=$1
echo "installing suricata on $IP $HOSTNAME setting * off on $ETH"
ethtool -K $ETH tx off sg off gro off gso off lro off tso off

#suricata
add-apt-repository -y ppa:oisf/suricata-stable > /dev/null 2>&1
apt-get update > /dev/null 2>&1
apt-get -y install suricata > /dev/null 2>&1
service suricata stop
#stealing amsterdam suricata conf
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/config/suricata/suricata.yaml -O /etc/suricata/suricata.yaml
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/config/suricata/threshold.config -O /etc/suricata/threshold.config

#  - interface: eth0
sed -i -e 's,- interface: eth0,- interface: '${ETH}',g' /etc/suricata/suricata.yaml
#fake scirius rules
#todo: get it from master
touch /etc/suricata/rules/scirius.rules
service suricata start > /dev/null 2>&1
#sleep 2
#service suricata status
cat > /etc/telegraf/telegraf.d/suricata.conf <<DELIM
[[inputs.procstat]]
  pid_file = "/var/run/suricata.pid"
DELIM
service telegraf restart > /dev/null 2>&1
#sleep 1
#service telegraf status
