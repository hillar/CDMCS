#!/bin/bash
echo "$0 got params: $1 $2 $3 $4"

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
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'admin')" | python manage.py shell
python manage.py runserver 0.0.0.0:8000 > /var/log/scirius.log 2>&1 &
