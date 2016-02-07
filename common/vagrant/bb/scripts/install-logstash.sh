#!/bin/bash
#
# this script:
# 1) installs logstash
# 2) sets elastic to $1
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

ELASTIC=$1


# Markus, can you replace logststash with rsyslog
# logstash
cd /tmp
wget -q https://download.elastic.co/logstash/logstash/logstash-all-plugins-2.1.0.tar.gz
cd /opt
tar -xzf /tmp/logstash-all-plugins-2.1.0.tar.gz
#stealing amsterdam losgstash conf
mkdir -p /etc/logstash
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/config/logstash/logstash.conf -O /etc/logstash/logstash.conf
echo "${ELASTIC} elasticsearch" >> /etc/hosts
nohup /opt/logstash-2.1.0/bin/logstash -f /etc/logstash/logstash.conf > /var/log/logstash.log 2>&1 &
sleep 3
tail /var/log/logstash.log
