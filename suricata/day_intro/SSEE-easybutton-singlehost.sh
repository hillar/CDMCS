#!/bin/sh
# SSEE-easybutton-singlehost.sh
# Use this script to create a single instance ubu 14 host for:
# Suricata
# Scirius
# Elasticsearch
# Evebox
#
# for testing !
# you probably don't want to use this for a real deployment.

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

#suricata
add-apt-repository -y ppa:oisf/suricata-stable
apt-get update
apt-get -y install suricata
service suricata stop
#stealing amsterdam suricata conf
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/config/suricata/suricata.yaml -O /etc/suricata/suricata.yaml
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/config/suricata/threshold.config -O /etc/suricata/threshold.config
#suricata -T -c /etc/suricata/suricata.yaml
ethtool -K eth0 tx off sg off gro off gso off lro off tso off

# Scirius
# see https://github.com/StamusNetworks/scirius#installation-and-setup

DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y wget python-pip python-dev git gcc
echo "deb http://packages.stamus-networks.com/debian/ jessie main" >> /etc/apt/sources.list.d/stamus-packages.list
cd /tmp/
wget -O stamus.key -q http://packages.stamus-networks.com/packages.stamus-networks.com.gpg.key
apt-key add stamus.key
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y suricata
#wget https://github.com/StamusNetworks/scirius/archive/scirius-${VERSION}.tar.gz
wget https://github.com/StamusNetworks/scirius/archive/master.tar.gz
mkdir -p /opt/selks/sciriusdata
cd /opt/selks
tar zxf /tmp/master.tar.gz
ln -sf /opt/selks/scirius-master /opt/selks/scirius
cd /opt/selks/scirius
pip install -r requirements.txt
ln -s /etc/scirius/local_settings.py /opt/selks/scirius/scirius/
#stealing amsterdam scirius conf
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/docker/scirius/django/scirius.json -O /opt/selks/scirius/scirius.json
mkdir -p /opt/selks/bin/
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/docker/scirius/django/scirius.sh -O /opt/selks/bin/scirius.sh
chmod ugo+x /opt/selks/bin/scirius.sh
pip install -U six
pip install urllib3 --upgrade


#elastic
apt-get install -y openjdk-7-jre-headless
wget -q https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.1.1/elasticsearch-2.1.1.deb
sudo dpkg -i elasticsearch-2.1.1.deb
service elasticsearch stop
/usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
#/usr/share/elasticsearch/bin/plugin install elasticsearch/elasticsearch-mapper-attachments/3.1.1
/usr/share/elasticsearch/bin/plugin install delete-by-query

#kibana
cd /tmp
wget -q https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz
cd /opt/selks
tar -xzf /tmp/kibana-4.3.1-linux-x64.tar.gz
ln -sf /opt/selks/kibana-4.3.1-linux-x64 /opt/selks/kibana
/opt/selks/kibana/bin/kibana plugin -i kibana/timelion


# Markus, can you replace logststash with rsyslog
# logstash
wget https://download.elastic.co/logstash/logstash/packages/debian/logstash_2.1.1-1_all.deb
dpkg -i logstash_2.1.1-1_all.deb
#stealing amsterdam losgstash conf
wget https://github.com/StamusNetworks/Amsterdam/blob/master/src/config/logstash/logstash.conf


#evebox
apt-get -y install unzip
cd /opt/
wget https://bintray.com/artifact/download/jasonish/evebox/evebox-linux-amd64.zip
unzip evebox-linux-amd64.zip
./evebox-linux-amd64/evebox --version
# ./evebox-linux-amd64/evebox
