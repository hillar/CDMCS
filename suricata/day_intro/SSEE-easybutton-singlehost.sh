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

# student:cdmcs hillar$ time vagrant up
# Bringing machine 'Amstelredamme' up with 'virtualbox' provider...
# ==> Amstelredamme: Importing base box 'ubu14'...
# ...
# real	5m20.461s
# user	0m4.858s
# sys	0m1.954s

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

ethtool -K eth0 tx off sg off gro off gso off lro off tso off

# Scirius
# see https://github.com/StamusNetworks/scirius#installation-and-setup
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y wget python-pip python-dev git gcc
cd /tmp/
wget https://github.com/StamusNetworks/scirius/archive/master.tar.gz
mkdir -p /opt/selks/sciriusdata
cd /opt/selks
tar zxf /tmp/master.tar.gz
ln -sf /opt/selks/scirius-master /opt/selks/scirius
cd /opt/selks/scirius
pip install -r requirements.txt
ln -s /etc/scirius/local_settings.py /opt/selks/scirius/scirius/
pip install -U six
pip install urllib3 --upgrade
#stealing from /opt/selks/bin/scirius.sh
cd /opt/selks/scirius/
echo "no" | python manage.py syncdb
python manage.py makemigrations
python manage.py migrate
python manage.py createcachetable my_cache_table
python manage.py addsource "ETOpen Ruleset" https://rules.emergingthreats.net/open/suricata-2.0.7/emerging.rules.tar.gz http sigs
python manage.py addsource "SSLBL abuse.ch" https://sslbl.abuse.ch/blacklist/sslblacklist.rules http sig
python manage.py defaultruleset "Default SELKS ruleset"
python manage.py disablecategory "Default SELKS ruleset" stream-events
python manage.py addsuricata $(hostname) "Suricata on SELKS" /etc/suricata/rules "Default SELKS ruleset"
python manage.py updatesuricata
suricata -T -c /etc/suricata/suricata.yaml
# set u:p  to admin:password
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'password')" | python manage.py shell
python manage.py runserver 0.0.0.0:8000 > /var/log/scirius.log 2>&1 &
service suricata start

#elastic
apt-get install -y openjdk-7-jre-headless
wget -q https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.1.1/elasticsearch-2.1.1.deb
sudo dpkg -i elasticsearch-2.1.1.deb
/usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
#/usr/share/elasticsearch/bin/plugin install elasticsearch/elasticsearch-mapper-attachments/3.1.1
/usr/share/elasticsearch/bin/plugin install delete-by-query
echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
service elasticsearch restart

# Markus, can you replace logststash with rsyslog
# logstash
cd /tmp
wget -q https://download.elastic.co/logstash/logstash/logstash-all-plugins-2.1.0.tar.gz
cd /opt
tar -xzf /tmp/logstash-all-plugins-2.1.0.tar.gz
#stealing amsterdam losgstash conf
mkdir -p /etc/logstash
wget -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/config/logstash/logstash.conf -O /etc/logstash/logstash.conf
echo "127.0.0.1 elasticsearch" >> /etc/hosts
cd /opt/logstash-2.1.0/bin/
./logstash -f /etc/logstash/logstash.conf > /var/log/logstash.log 2>&1 &

#kibana
cd /tmp
wget -q https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz
cd /opt/
tar -xzf /tmp/kibana-4.3.1-linux-x64.tar.gz
ln -sf /opt/kibana-4.3.1-linux-x64 /opt/kibana
/opt/kibana/bin/kibana plugin -i kibana/timelion
#chown -R kibana.kibana /opt/kibana/optimize/
/opt/kibana/bin/kibana > /var/log/kibana.log 2>&1 &

#evebox
apt-get -y install unzip
cd /opt/
wget -q https://bintray.com/artifact/download/jasonish/evebox/evebox-linux-amd64.zip
unzip evebox-linux-amd64.zip
./evebox-linux-amd64/evebox --version
echo "http.cors.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
echo "http.cors.allow-origin: \"/.*/\"" >> /etc/elasticsearch/elasticsearch.yml
service elasticsearch restart
/opt/evebox-linux-amd64/evebox > /var/log/evebox.log 2>&1 &

grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" /etc/suricata/rules/scirius.rules|rev|sort|uniq|rev|while read i; do wget -q -T 1 -t 1 $i; done  &

netstat -lnpte
