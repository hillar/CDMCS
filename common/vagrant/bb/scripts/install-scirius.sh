#!/bin/bash
#
# this script
# 1) installs scirius
# 2) add 1..n Suricata's
#
if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

SURICATA=$1
IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)

# Scirius
# see https://github.com/StamusNetworks/scirius#installation-and-setup
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y wget python-pip python-dev git gcc
cd /tmp/
wget -q https://github.com/StamusNetworks/scirius/archive/master.tar.gz
mkdir -p /opt/selks/sciriusdata
cd /opt/selks
tar zxf /tmp/master.tar.gz
ln -sf /opt/selks/scirius-master /opt/selks/scirius
cd /opt/selks/scirius
pip install -r requirements.txt
ln -s /etc/scirius/local_settings.py /opt/selks/scirius/scirius/
pip install -U six
pip install urllib3 --upgrade
mkdir -p /etc/suricata/rules
cat > /opt/selks/scirius/scirius/settings.py <<DELIM
"""
Django settings for scirius project.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.6/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
from distutils.version import LooseVersion
from django import get_version
import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.6/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'p8o5%vq))8h2li08c%k3id(wwo*u(^dbdmx2tv#t(tb2pr9@n-'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True

ALLOWED_HOSTS = []

# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django_tables2',
    'bootstrap3',
    'rules',
    'suricata',
    'accounts',
)

if LooseVersion(get_version()) < LooseVersion('1.7'):
    INSTALLED_APPS += ('south', )

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'scirius.loginrequired.LoginRequiredMiddleware',
    'scirius.utils.TimezoneMiddleware',
)

TEMPLATE_CONTEXT_PROCESSORS = (
    'django.core.context_processors.request',
    'django.contrib.auth.context_processors.auth',
    'django.template.context_processors.tz',
)

ROOT_URLCONF = 'scirius.urls'

WSGI_APPLICATION = 'scirius.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.db.DatabaseCache',
        'LOCATION': 'my_cache_table',
    }
}

# Internationalization
# https://docs.djangoproject.com/en/1.6/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True

SESSION_SERIALIZER = 'django.contrib.sessions.serializers.PickleSerializer'

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.6/howto/static-files/

STATIC_URL = '/static/'

# Suricata binary
SURICATA_BINARY = "suricata"

# Elastic search

USE_ELASTICSEARCH = True
#ELASTICSEARCH_ADDRESS = "127.0.0.1:9200"
ELASTICSEARCH_ADDRESS = "${IP}:9200"
# You can use a star to avoid timestamping expansion for example 'logstash-*'
ELASTICSEARCH_LOGSTASH_INDEX = "logstash-"
# You can change following value if you have different indexes for stats and alerts
ELASTICSEARCH_LOGSTASH_ALERT_INDEX = ELASTICSEARCH_LOGSTASH_INDEX
# use hourly, daily to indicate the logstash index building recurrence
ELASTICSEARCH_LOGSTASH_TIMESTAMPING = "hourly"
# use Elasticsearch 2.x
ELASTICSEARCH_2X = True

# Kibana
USE_KIBANA = True
# Use django as a reverse proxy for kibana request
# This will allow you to use scirius authentication to control
# access to Kibana
KIBANA_PROXY = True
# Kibana URL
KIBANA_URL = "http://FIXME:9292"
# Kibana index name
KIBANA_INDEX = "kibana-int"
# Kibana version
KIBANA_VERSION=4
# Number of dashboards to display
KIBANA_DASHBOARDS_COUNT = 20

USE_EVEBOX = True
EVEBOX_ADDRESS = "${IP}:5636"

# Suricata is configured to write stats to EVE
USE_SURICATA_STATS = True
# Logstash is generating metrics on eve events
USE_LOGSTASH_STATS = True

# Set value to path to suricata unix socket to use suricatasc
# based info
SURICATA_UNIX_SOCKET = None
#SURICATA_UNIX_SOCKET = "/var/run/suricata/suricata-command.socket"

# Influxdb
USE_INFLUXDB = False
INFLUXDB_HOST = "localhost"
INFLUXDB_PORT = 8086
INFLUXDB_USER = "grafana"
INFLUXDB_PASSWORD = "grafana"
INFLUXDB_DATABASE = "scirius"

# Proxy parameters
# Set USE_PROXY to True to use a proxy to fetch ruleset update.
# PROXY_PARAMS contains the proxy parameters.
# If user is set in PROXY_PARAMS then basic authentication will
# be used.
USE_PROXY = False
PROXY_PARAMS = { 'http': "http://proxy:3128", 'https': "http://proxy:3128" }
# For basic authentication you can use
# PROXY_PARAMS = { 'http': "http://user:pass@proxy:3128", 'https': "http://user:pass@proxy:3128" }

GIT_SOURCES_BASE_DIRECTORY = os.path.join(BASE_DIR, 'git-sources/')

# Ruleset generator framework
RULESET_MIDDLEWARE = 'suricata'

LOGIN_URL = '/accounts/login/'

try:
    from local_settings import *
except:
    pass

if KIBANA_PROXY:
    INSTALLED_APPS += ( 'revproxy',)

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
python manage.py addsuricata $SURICATA "Suricata on SELKS" /etc/suricata/rules "Default SELKS ruleset"
python manage.py updatesuricata
suricata -T -c /etc/suricata/suricata.yaml
# set u:p  to admin:password
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'admin')" | python manage.py shell
python manage.py runserver 0.0.0.0:7000 > /var/log/scirius.log 2>&1 &
cd /etc/suricata/rules/
#python -m SimpleHTTPServer > /var/log/scirius_rules.log 2>&1 &
