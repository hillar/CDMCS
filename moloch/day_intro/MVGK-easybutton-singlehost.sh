#!/bin/bash
# MVGK-easybutton-singlehost.sh
# Use this script to create a single instance ubu 14 host for:
# Moloch
# VSRoom
# Telegraf
# Influxdb
# Grafana
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

echo "adding new node to cluster: ${CLUSTER} node: ${NAME} bind: ${IP} unicast host: ${UNICASTHOSTS} type: ${TYPE}"

INSTALL_DIR=/provision

ES=2.3.2

mkdir -p ${INSTALL_DIR}/elasticsearch
cd ${INSTALL_DIR}/elasticsearch
if [ ! -f "elasticsearch-${ES}.deb" ]; then
  wget -4 -q https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ES}.deb
fi
if [ ! -f "elasticsearch-${ES}.deb" ]; then
    echo "$(date) ${NAME} $0[$$]: {elastic: {status:ERROR, msg: missing elasticsearch-${ES}.deb}"
    exit -1
else
  echo -e "Y" | dpkg -i elasticsearch-${ES}.deb  > /dev/null 2>&1
  service elasticsearch stop > /dev/null 2>&1
  /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head 2>&1 > /dev/null
  echo "# generated ${date} by $0" > /etc/elasticsearch/elasticsearch.yml

  echo "path.data: /srv" >> /etc/elasticsearch/elasticsearch.yml
  echo "cluster.name: ${CLUSTER}" >> /etc/elasticsearch/elasticsearch.yml
  echo "node.name: ${NAME} " >> /etc/elasticsearch/elasticsearch.yml
  echo "node.max_local_storage_nodes: 1 " >> /etc/elasticsearch/elasticsearch.yml
  echo "index.number_of_replicas: 0 " >> /etc/elasticsearch/elasticsearch.yml
  echo "index.fielddata.cache: node " >> /etc/elasticsearch/elasticsearch.yml
  echo "indices.fielddata.cache.size: 40% " >> /etc/elasticsearch/elasticsearch.yml
  echo "http.compression: true " >> /etc/elasticsearch/elasticsearch.yml
  echo "bootstrap.mlockall: true " >> /etc/elasticsearch/elasticsearch.yml
  echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
  echo "# split brain here ;( " >> /etc/elasticsearch/elasticsearch.yml
  echo "discovery.zen.minimum_master_nodes: 1" >> /etc/elasticsearch/elasticsearch.yml
  echo "discovery.zen.ping.multicast.enabled: false" >> /etc/elasticsearch/elasticsearch.yml
  echo 'discovery.zen.ping.unicast.hosts: ['${UNICASTHOSTS}']' >> /etc/elasticsearch/elasticsearch.yml

  echo "node.master: true" >> /etc/elasticsearch/elasticsearch.yml
  echo "node.data: true" >> /etc/elasticsearch/elasticsearch.yml
  echo "http.enabled: true" >> /etc/elasticsearch/elasticsearch.yml

  service elasticsearch start

echo "installing Moloch + .... on $IP"

#https://github.com/aol/moloch/archive/master.tar.gz
#https://github.com/aol/moloch/archive/v0.12.2.tar.gz


#MLCH="v0.12.22
MLCH="master"
INSTALL_DIR=/provision

mkdir -p ${INSTALL_DIR}/moloch
cd ${INSTALL_DIR}/moloch
if [ ! -f "${MLCH}.tar.gz" ]; then
    wget -4 -q wget https://github.com/aol/moloch/archive/${MLCH}.tar.gz
fi
if [ ! -f "${MLCH}.tar.gz" ]; then
    echo "$(date) ${NAME} $0[$$]: {moloch: {status:ERROR, msg: missing {MLCH}.tar.gz}"
    exit -1
else
  if [ ! -d "moloch-${MLCH}" ]; then
    tar -xzf ${MLCH}.tar.gz
  fi
  cd "moloch-${MLCH}"
  #sed passwordSecret
  apt-get update -qq
  sed -i -e 's,passwordSecret,#passwordSecret,g'  single-host/etc/config.ini.template
  echo -en "\n\n\n\n\n\n\n\nINIT\nINIT\n" | ./easybutton-singlehost.sh
  sleep 1
fi

#VSRoom
VSRM="default"
mkdir -p ${INSTALL_DIR}/vsroom
cd ${INSTALL_DIR}/vsroom
if [ ! -f "${VSRM}.tar.gz" ]; then
  wget -q -4 https://bitbucket.org/hillar/vsroom-experiments/get/${VSRM}.tar.gz
fi
if [ ! -f "${VSRM}.tar.gz" ]; then
  echo "$(date) ${NAME} $0[$$]: {vsroom: {status:Warning, msg: missing {VSRM}.tar.gz}"
else
  rm -rf hillar-vsroom-experiments-*
  tar -xzf default.tar.gz
  vsrdefault=$(ls | grep "hillar-vsroom-experiments-")
  cd $vsrdefault/vsr/
  cp -r javascript /data/moloch/viewer/public/vsroom
  echo "to see moloch sessions in vsroom open in browser https://192.168.11.112:8005/vsroom/overview/index.html?moloch=1"
fi

# Telegraf
echo "$(date) installing telegraf on ${IP} ${HOSTNAME} setting influxdb to ${MASTER}"

TLGF=0.12.1
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
[[inputs.system]]
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
#wget https://dl.influxdata.com/influxdb/releases/influxdb_0.13.0~rc1_amd64.deb
INFLX="0.13.0~rc1"

mkdir -p ${INSTALL_DIR}/influxdb
cd ${INSTALL_DIR}/influxdb
if [ ! -f "influxdb_${INFLX}_amd64.deb" ]; then
   wget -q https://dl.influxdata.com/influxdb/releases/influxdb_${INFLX}_amd64.deb > /dev/null 2>&1
fi
if [ ! -f "influxdb_${INFLX}_amd64.deb" ]; then
  echo "$(date) ${NAME} $0[$$]: {influxdb: {status:ERROR, msg: missing influxdb_${INFLX}_amd64.deb}"
  exit -1
else
  echo -e "Y"|dpkg -i influxdb_${INFLX}_amd64.deb > /dev/null 2>&1
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


# Grafana
echo "$(date) installing grafana on ${IP} ${HOSTNAME}"

INSTALL_DIR=/provision
#https://grafanarel.s3.amazonaws.com/builds/grafana_3.0.0-beta71462173753_amd64.deb
GRFN="3.0.0-beta71462173753"
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
  #apt-get -y install sqlite > /dev/null 2>&1
  #sqlite3 /var/lib/grafana/grafana.db "INSERT INTO \"data_source\" VALUES(1,1,0,\"influxdb\",\"telegraf\",\"proxy\",\"http://192.168.11.112:8086\",\"admin\",\"admin\",\"telegraf\",0,\"\",\"\",1,\"{}\",\"2016-03-07 18:21:44\",\"2016-03-07 18:50:56\",0);"
  # sqlite3 /var/lib/grafana/grafana.db "INSERT INTO \"api_key\" VALUES(1,1,'kala','e704c6e5d7ce57589d2277e945ddd3d4153c4b736bbf2c2fd1461b7c833843026d42671a73542ae54fc408f913487054ef8b','Admin','2016-03-08 08:04:10','2016-03-08 08:04:10');"
  # see http://docs.grafana.org/reference/http_api/
  # {"k":"w0irgUoSXRXxAoLDJK749RhVHE2ZbAXN","n":"","brodello":1}
  # https://github.com/grafana/grafana/blob/bddcc6491a8e80124ab88eb1973bb9aabc0b36be/pkg/components/apikeygen/apikeygen.go#L32
  # https://github.com/grafana/grafana/blob/bddcc6491a8e80124ab88eb1973bb9aabc0b36be/pkg/util/encoding.go#L32
  # newPasswd := PBKDF2([]byte(password), []byte(salt), 10000, 50, sha256.New)
  #openssl enc -pbkdf2 -pass pass:"90093846f2dd7687da8e81d0afadd60b655cd8131c1f92586acf42edf6185e04528ad457c423184b7ee560aff1d925aed492" -S "aa" -md sha256 -c 10000 -dklen 50
  #curl -H "Content-Type: application/json" -H "Authorization: Bearer eyJrIjoiT29KbTV1aXRHWHRnM2dJdmNzc0dxeUdmMkdiNWpya2kiLCJuIjoia2FsYSIsImlkIjoxfQ==" http://192.168.11.112:3000//api/dashboards/db -d @p.json
  #sleep 1
  #service telegraf status
  service grafana-server stop
  cd /var/lib/grafana
  wget -4 -q https://raw.githubusercontent.com/hillar/CDMCS/master/bro/day_intro/brodello/grafana.tar.gz > /dev/null 2>&1
  rm grafana.db
  tar -xzf grafana.tar.gz
  service grafana-server start
  # todo: fix perms
  chmod 777 /var/run/grafana-server.pid

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
