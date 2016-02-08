#!/bin/bash
#
# this script:
# 1) installs logstash
# 2) sets elastic to $1 in conf.d/suricata.conf
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

ELASTIC=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')


# Markus, can you replace logststash with rsyslog, but still keep the "good" tempalte, so scirius can still get data
# logstash
echo 'deb http://packages.elasticsearch.org/logstash/2.2/debian stable main' > /etc/apt/sources.list.d/logstash.list
apt-get update > /dev/null 2>&1
apt-get -y --force-yes install logstash > /dev/null 2>&1

#stealing amsterdam losgstash conf
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/config/logstash/logstash.conf -O /etc/logstash/conf.d/suricata.conf
#    hosts => elasticsearch
sed -i -e 's,hosts => elasticsearch,hosts => "'${ELASTIC}'"\n index => "logstash-%{+YYYY.MM.dd.HH}",g' /etc/logstash/conf.d/suricata.conf
#fix this hack
chmod 777 /var/log/suricata/eve.json
service logstash start
