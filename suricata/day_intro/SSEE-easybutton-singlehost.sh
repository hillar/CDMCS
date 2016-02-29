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

IP=$(ifconfig eth1 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
mkdir /etc/scirius
cat > /etc/scirius/local_settings.py <<DELIM
ELASTICSEARCH_LOGSTASH_TIMESTAMPING = "hourly"
ELASTICSEARCH_2X = True
USE_KIBANA = True
KIBANA_URL = "http://$IP:5601"
KIBANA_INDEX = ".kibana"
KIBANA_VERSION=4
USE_EVEBOX = True
EVEBOX_ADDRESS = "$IP:5636"
USE_SURICATA_STATS = True
USE_LOGSTASH_STATS = True
SURICATA_UNIX_SOCKET = "/var/run/suricata/suricata-command.socket"
DELIM
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

#logstash
ELASTIC="127.0.0.1"
echo "installing logstash on $IP $HOSTNAME setting elasticsearch on $ELASTIC"

#ELASTIC=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
echo 'deb http://packages.elasticsearch.org/logstash/2.2/debian stable main' > /etc/apt/sources.list.d/logstash.list
apt-get update > /dev/null 2>&1
apt-get -y --force-yes install logstash > /dev/null 2>&1
#stealing amsterdam losgstash conf
wget -4 -q https://raw.githubusercontent.com/StamusNetworks/Amsterdam/master/src/config/logstash/conf.d/logstash.conf -O /etc/logstash/conf.d/suricata.conf
#    hosts => elasticsearch
sed -i -e 's,hosts => elasticsearch,hosts => "'${ELASTIC}'"\n index => "logstash-%{+YYYY.MM.dd.HH}",g' /etc/logstash/conf.d/suricata.conf
#fix this hack
chmod 777 /var/log/suricata/eve.json
service logstash start > /dev/null 2>&1

#kibana
KBN=4.4
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add - > /dev/null 2>&1
echo 'deb http://packages.elastic.co/kibana/'${KBN}'/debian stable main' > /etc/apt/sources.list.d/kibana.list
apt-get update > /dev/null 2>&1
apt-get -y install kibana > /dev/null 2>&1
/opt/kibana/bin/kibana plugin -i kibana/timelion > /dev/null 2>&1
#chown -R kibana.kibana /opt/kibana/optimize/
# server.host: "0.0.0.0"
sed -i -e 's,# server.host: "0.0.0.0",server.host: "'${IP}'",g' /opt/kibana/config/kibana.yml
# elasticsearch.url: "http://10.242.11.29:9200"
sed -i -e 's,# elasticsearch.url: "http://localhost:9200",elasticsearch.url: "http://'${ELASTIC}':9200",g' /opt/kibana/config/kibana.yml
#todo fix this
chmod -R 777 /opt/kibana/optimize/
service kibana start > /dev/null 2>&1

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
