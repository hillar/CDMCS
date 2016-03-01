#!/bin/bash

ELASTICIP=$1
EVEBOXIP=$2
KIBANAIP=$3

#cd /opt
#wget https://github.com/inliniac/suricata/archive/master.tar.gz
#tar -xzf master.tar.gz
#cd suricata-master/scripts/suricatasc/
#python setup.py intall
#suricata
add-apt-repository -y ppa:oisf/suricata-stable > /dev/null 2>&1
apt-get update > /dev/null 2>&1
apt-get -y install suricata > /dev/null 2>&1
service suricata stop

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
mkdir /etc/scirius
cat > /etc/scirius/local_settings.py <<DELIM
ELASTICSEARCH_ADDRESS = "$ELASTICIP:9200"
ELASTICSEARCH_LOGSTASH_TIMESTAMPING = "hourly"
ELASTICSEARCH_2X = True
USE_KIBANA = True
KIBANA_URL = "http://$KIBANAIP:5601"
KIBANA_INDEX = ".kibana"
KIBANA_VERSION=4
USE_EVEBOX = True
EVEBOX_ADDRESS = "$EVEBOXIP:5636"
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
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'admin')" | python manage.py shell
python manage.py runserver 0.0.0.0:8000 > /var/log/scirius.log 2>&1 &
