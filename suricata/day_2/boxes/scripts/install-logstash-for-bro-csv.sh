#!/bin/bash
#
# this script:
# 1) installs logstash
# 2) sets elastic to $1 in conf.d/bro-*.conf
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi
IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)
ELASTIC=$1
echo "installing logstash on $IP $HOSTNAME setting elasticsearch on $ELASTIC"

#ELASTIC=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
echo 'deb http://packages.elasticsearch.org/logstash/2.2/debian stable main' > /etc/apt/sources.list.d/logstash.list
apt-get update > /dev/null 2>&1
apt-get -y --force-yes install logstash > /dev/null 2>&1
/opt/logstash/bin/plugin install logstash-filter-translate > /dev/null 2>&1
/opt/logstash/bin/plugin  install logstash-filter-de_dot > /dev/null 2>&1
#stealing from Tim Molter
cd /etc/logstash/conf.d/
wget -q https://raw.githubusercontent.com/timmolter/logstash-dfir/master/conf_files/bro/bro-conn_log.conf
wget -q https://raw.githubusercontent.com/timmolter/logstash-dfir/master/conf_files/bro/bro-dns_log.conf
wget -q https://raw.githubusercontent.com/timmolter/logstash-dfir/master/conf_files/bro/bro-files_log.conf
wget -q https://raw.githubusercontent.com/timmolter/logstash-dfir/master/conf_files/bro/bro-http_log.conf
wget -q https://raw.githubusercontent.com/timmolter/logstash-dfir/master/conf_files/bro/bro-notice_log.conf
wget -q https://raw.githubusercontent.com/timmolter/logstash-dfir/master/conf_files/bro/bro-ssh_log.conf
wget -q https://raw.githubusercontent.com/timmolter/logstash-dfir/master/conf_files/bro/bro-ssl_log.conf
wget -q https://raw.githubusercontent.com/timmolter/logstash-dfir/master/conf_files/bro/bro-weird_log.conf
wget -q https://raw.githubusercontent.com/timmolter/logstash-dfir/master/conf_files/bro/bro-x509_log.conf
#  elasticsearch { host => localhost }
sed -i -e 's,host => localhost,hosts => "'${ELASTIC}'"\n index => "logstash-%{+YYYY.MM.dd.HH}",g' /etc/logstash/conf.d/*.conf
sed -i -e '/date/i \ \ \ \ \de_dot{ }' /etc/logstash/conf.d/*.conf
#sed -i -e 's/id.orig_h/id_orig_h/g' -e 's/id.resp_h/id_resp_h/g' -e 's/id.orig_p/id_orig_p/g' -e 's/id.resp_p/id_resp_p/g' /etc/logstash/conf.d/*.conf
#path => "/nsm/bro/logs/current/conn.log"
sed -i -e 's,/nsm/bro/logs/current/,/opt/bro/logs/current/,g' /etc/logstash/conf.d/*.conf


sudo -u logstash /opt/logstash/bin/logstash agent -f /etc/logstash/conf.d --configtest

adduser logstash bro
service logstash start > /dev/null 2>&1
cat > /etc/telegraf/telegraf.d/logstash.conf <<DELIM
[[inputs.procstat]]
  pid_file = "/var/run/logstash.pid"
DELIM
service telegraf restart > /dev/null 2>&1
