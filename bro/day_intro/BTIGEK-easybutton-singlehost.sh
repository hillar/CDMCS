#!/bin/bash
# BTIGEK-easybutton-singlehost.sh
# Use this script to create a single instance ubu 14 host for:
# Bro
# Telegraf
# Influxdb
# Grafana
# Elasticsearch
# Kibana
#
# for testing !
# you probably don't want to use this for a real deployment.



if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

ETH=$1
IP=$(ifconfig $ETH 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)
MASTER=$IP
ELASTIC=$IP
NAME=$HOSTNAME
CLUSTER=$HOSTNAME
UNICASTHOSTS=$IP
BIND=$IP

# Telegraf
echo "$(date) installing telegraf on ${IP} ${HOSTNAME} setting influxdb to ${MASTER}"

TLGF=0.10.4.1
INSTALL_DIR=/provision

mkdir -p ${INSTALL_DIR}/telegraf
cd ${INSTALL_DIR}/telegraf
if [ ! -f "telegraf_${TLGF}-1_amd64.deb" ]; then
    wget -4 -q wget http://get.influxdb.org/telegraf/telegraf_${TLGF}-1_amd64.deb > /dev/null 2>&1
fi
if [ ! -f "telegraf_${TLGF}-1_amd64.deb" ]; then
    echo "$(date) ${NAME} $0[$$]: {telegraf: {status:ERROR, msg: missing telegraf_${TLGF}_amd64.deb}"
    exit -1
else
  rm -rf /var/log/telegraf
  rm -rf /etc/telegraf
  apt-get -y remove --purge telegraf > /dev/null 2>&1
  #echo -e "Y"|
  dpkg -i telegraf_${TLGF}-1_amd64.deb > /dev/null 2>&1

cat > /etc/telegraf/telegraf.conf <<DELIM
[agent]
  interval = "1s"
  round_interval = true
  metric_buffer_limit = 10000
  flush_buffer_when_full = true
  collection_jitter = "0s"
  flush_interval = "60s"
  flush_jitter = "3s"
  debug = false
  quiet = false
[[outputs.influxdb]]
  urls = ["http://$MASTER:8086"] # required
  database = "telegraf" # required
  precision = "s"
DELIM
cat > /etc/telegraf/telegraf.d/common.conf <<DELIM
[[inputs.mem]]
[[inputs.cpu]]
[[inputs.disk]]
[[inputs.diskio]]
[[inputs.net]]
[[inputs.netstat]]
DELIM
cat > /etc/telegraf/telegraf.d/telegraf.conf <<DELIM
[[inputs.procstat]]
  pid_file = "/var/run/telegraf/telegraf.pid"
DELIM
  service telegraf restart  > /dev/null 2>&1
  #sleep 1
  #service telegraf status
fi

# influxdb
echo "$(date) installing influxdb on ${IP} ${HOSTNAME} setting bind to ${BIND}..."

INSTALL_DIR=/provision

INFLX="0.10.1"

mkdir -p ${INSTALL_DIR}/influxdb
cd ${INSTALL_DIR}/influxdb
if [ ! -f "influxdb_${INFLX}-1_amd64.deb" ]; then
   wget -q https://s3.amazonaws.com/influxdb/influxdb_${INFLX}-1_amd64.deb > /dev/null 2>&1
fi
if [ ! -f "influxdb_${INFLX}-1_amd64.deb" ]; then
  echo "$(date) ${NAME} $0[$$]: {influxdb: {status:ERROR, msg: missing influxdb_${INFLX}-1_amd64.deb}"
  exit -1
else
  echo -e "Y"|dpkg -i influxdb_${INFLX}-1_amd64.deb > /dev/null 2>&1
  service influxdb start > /dev/null 2>&1
  sleep 1
  service influxdb status
  #prepare for telegraf

  service telegraf stop > /dev/null 2>&1
  curl -s -G http://localhost:8086/query --data-urlencode "q=DROP DATABASE telegraf"
  curl -s -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE telegraf"
  curl -s -G http://localhost:8086/query --data-urlencode "q=CREATE RETENTION POLICY one_day_only ON telegraf DURATION 1d REPLICATION 1 DEFAULT"
  #sed -i -e 's,localhost,'${METRICS_SERVER}',g' /etc/influxdb/influxdb.conf
cat > /etc/telegraf/telegraf.d/influxdb.conf <<DELIM
[[inputs.influxdb]]
  urls = ["http://127.0.0.1:8086/debug/vars"]
[[inputs.procstat]]
  pid_file = "/var/run/influxdb/influxd.pid"
DELIM
  service telegraf start > /dev/null  2>&1
  sleep 1
  service telegraf status
fi



# Bro

echo "$(date) installing bro"
echo 'deb http://download.opensuse.org/repositories/network:/bro/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/bro.list
apt-get update > /dev/null 2>&1
apt-get -y --force-yes install bro > /dev/null 2>&1
#interface=eth0
sed -i -e 's,interface=eth0,interface='"$ETH"',g' /opt/bro/etc/node.cfg
echo "192.168.10.0/24      Private IP space" > /opt/bro/etc/networks.cfg

/opt/bro/bin/broctl deploy > /dev/null 2>&1
/opt/bro/bin/broctl status

#Java
apt-get install -y openjdk-7-jre-headless

# elasticsearch
echo "$(date) installing elasticsearch cluster: ${CLUSTER} node: ${NAME} bind: ${IP} unicast host: ${UNICASTHOSTS}"
INSTALL_DIR=/provision
ES=2.2.0
mkdir -p ${INSTALL_DIR}/elasticsearch
cd ${INSTALL_DIR}/elasticsearch
if [ ! -f "elasticsearch-${ES}.deb" ]; then
  wget -4 -q https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ES}.deb > /dev/null 2>&1
fi
if [ ! -f "elasticsearch-${ES}.deb" ]; then
    echo "$(date) ${NAME} $0[$$]: {elastic: {status:ERROR, msg: missing elasticsearch-${ES}.deb}"
    exit -1
else
  echo -e "Y" | dpkg -i elasticsearch-${ES}.deb  > /dev/null 2>&1
  service elasticsearch stop > /dev/null 2>&1
  /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head 2>&1 > /dev/null
  echo "# generated ${date} by $0" > /etc/elasticsearch/elasticsearch.yml
  echo "cluster.name: ${CLUSTER}" >> /etc/elasticsearch/elasticsearch.yml
  echo "node.name: ${NAME} " >> /etc/elasticsearch/elasticsearch.yml
  echo "node.max_local_storage_nodes: 1 " >> /etc/elasticsearch/elasticsearch.yml
  echo "index.number_of_replicas: 0 " >> /etc/elasticsearch/elasticsearch.yml
  echo "index.fielddata.cache: node " >> /etc/elasticsearch/elasticsearch.yml
  echo "indices.fielddata.cache.size: 40% " >> /etc/elasticsearch/elasticsearch.yml
  echo "http.compression: true " >> /etc/elasticsearch/elasticsearch.yml
  echo "bootstrap.mlockall: true " >> /etc/elasticsearch/elasticsearch.yml
  echo "network.host: ${IP}" >> /etc/elasticsearch/elasticsearch.yml
  echo "# split brain here ;( " >> /etc/elasticsearch/elasticsearch.yml
  echo "discovery.zen.minimum_master_nodes: 1" >> /etc/elasticsearch/elasticsearch.yml
  echo "discovery.zen.ping.multicast.enabled: false" >> /etc/elasticsearch/elasticsearch.yml
  echo 'discovery.zen.ping.unicast.hosts: ['${UNICASTHOSTS}']' >> /etc/elasticsearch/elasticsearch.yml
  echo "node.master: true" >> /etc/elasticsearch/elasticsearch.yml
  echo "node.data: true" >> /etc/elasticsearch/elasticsearch.yml
  echo "http.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
  service elasticsearch start
fi
# logstash
echo "$(date) installing logstash on $IP $HOSTNAME setting elasticsearch on $ELASTIC"

#ELASTIC=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
echo 'deb http://packages.elasticsearch.org/logstash/2.2/debian stable main' > /etc/apt/sources.list.d/logstash.list
apt-get update > /dev/null 2>&1
apt-get -y --force-yes install logstash > /dev/null 2>&1
/opt/logstash/bin/plugin install logstash-filter-translate > /dev/null 2>&1
/opt/logstash/bin/plugin  install logstash-filter-de_dot
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
sed -i -e 's,host => localhost,hosts => "'${ELASTIC}'"\n index => "bro-%{+YYYY.MM.dd.HH}",g' /etc/logstash/conf.d/*.conf
sed -i -e '/date/i \ \ \ \ \de_dot{ }' /etc/logstash/conf.d/*.conf
sed -i -e 's/id.orig_h/id_orig_h/g' -e 's/id.resp_h/id_resp_h/g' -e 's/id.orig_p/id_orig_p/g' -e 's/id.resp_p/id_resp_p/g' /etc/logstash/conf.d/*.conf
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

# Grafana
echo "$(date) installing grafana on ${IP} ${HOSTNAME}"

INSTALL_DIR=/provision
GRFN="2.6.0"
mkdir -p ${INSTALL_DIR}/grafana
cd ${INSTALL_DIR}/grafana
if [ ! -f "grafana_${GRFN}_amd64.deb" ]; then
  wget -4 -q https://grafanarel.s3.amazonaws.com/builds/grafana_${GRFN}_amd64.deb > /dev/null 2>&1
fi
if [ ! -f "grafana_${GRFN}_amd64.deb" ]; then
  echo "$(date) ${HOSTNAME} $0[$$]: {grafana: {status:WARNING, msg: missing grafana_${GRFN}_amd64.deb}"
  #exit -1
else
  apt-get install -y adduser libfontconfig > /dev/null 2>&1
  echo -e "Y"|dpkg -i grafana_${GRFN}_amd64.deb > /dev/null 2>&1
  update-rc.d grafana-server defaults 95 10 > /dev/null 2>&1
  sed -i -e 's,domain = localhost,domain = '${IP}',g' /etc/grafana/grafana.ini
  service grafana-server start > /dev/null 2>&1
  #sleep 1
  #service grafana-server status
  #service telegraf stop  > /dev/null 2>&1
cat > /etc/telegraf/telegraf.d/grafana.conf <<DELIM
[[inputs.procstat]]
  pid_file = "/var/run/grafana-server.pid"
DELIM
  service telegraf restart  > /dev/null 2>&1
  #sleep 1
  #service telegraf status
fi

#Kibana
KBN=4.4
ELASTIC=$IP
echo "$(date) installing kibana$KBN on $IP $HOSTNAME setting elastic to $ELASTIC"
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add - > /dev/null 2>&1
echo 'deb http://packages.elastic.co/kibana/'${KBN}'/debian stable main' > /etc/apt/sources.list.d/kibana.list
apt-get update > /dev/null 2>&1
apt-get -y install kibana > /dev/null 2>&1
/opt/kibana/bin/kibana plugin -i kibana/timelion > /dev/null 2>&1
chown -R kibana.kibana /opt/kibana/optimize/
# server.host: "0.0.0.0"
sed -i -e 's,# server.host: "0.0.0.0",server.host: "'${IP}'",g' /opt/kibana/config/kibana.yml
# elasticsearch.url: "http://10.242.11.29:9200"
sed -i -e 's,# elasticsearch.url: "http://localhost:9200",elasticsearch.url: "http://'${ELASTIC}':9200",g' /opt/kibana/config/kibana.yml
chown -R kibana:kibana /opt/kibana/optimize/
service kibana start > /dev/null 2>&1
cat > /etc/telegraf/telegraf.d/kibana.conf <<DELIM
[[inputs.procstat]]
  pid_file = "/var/run/kibana.pid"
DELIM
service telegraf restart  > /dev/null 2>&1

echo "$(date) done installing"

#to have some traffic
mkdir -p /opt/test
cd /opt/test/
wget -4 -q https://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz
tar -xzf emerging.rules.tar.gz
cd rules/
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" *.rules|rev|sort|uniq|rev|while read i; do wget -q -T 1 -t 1 $i; done
