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

ETH=$1
SCIRIUS=$2

ethtool -K $ETH tx off sg off gro off gso off lro off tso off

#suricata
add-apt-repository -y ppa:oisf/suricata-stable
apt-get update
apt-get -y install suricata
service suricata stop
#stealing amsterdam suricata conf
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/config/suricata/suricata.yaml -O /etc/suricata/suricata.yaml
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/config/suricata/threshold.config -O /etc/suricata/threshold.config
