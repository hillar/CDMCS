#partially working -- needs some changes 
#updated for ubuntu 16.04
#grafana needs to addressed
#ETH does not always resolve to same name each time - need to review
#!/bin/bash
# BTIGEK-easybutton-singlehost.sh
# Use this script to create a single instance ubuntu 16.04 host for:
# Bro
# Telegraf
# Influxdb
# Grafana
# Elasticsearch
# Kibana
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

ETH = $1
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

TLGF=1.2.1
INSTALL_DIR=/provision

mkdir -p ${INSTALL_DIR}/telegraf
cd ${INSTALL_DIR}/telegraf
if [ ! -f "telegraf_${TLGF}_amd64.deb" ]; then
    wget -4 -q wget https://dl.influxdata.com/telegraf/releases/telegraf_${TLGF}_amd64.deb  > /dev/null 2>&1
fi
if [ ! -f "telegraf_${TLGF}_amd64.deb" ]; then
    echo "$(date) ${NAME} $0[$$]: {telegraf: {status:ERROR, msg: missing telegraf_${TLGF}_amd64.deb}"
    exit -1
else
  rm -rf /var/log/telegraf
  rm -rf /etc/telegraf
  apt-get -y remove --purge telegraf > /dev/null 2>&1
  #echo -e "Y"|
  dpkg -i telegraf_${TLGF}_amd64.deb > /dev/null 2>&1

cat > /etc/telegraf/telegraf.conf <<EOL
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
EOL
cat > /etc/telegraf/telegraf.d/common.conf <<EOL
[[inputs.mem]]
[[inputs.cpu]]
[[inputs.disk]]
[[inputs.diskio]]
[[inputs.net]]
[[inputs.netstat]]
[[inputs.system]]
EOL
cat > /etc/telegraf/telegraf.d/telegraf.conf <<EOL
[[inputs.procstat]]
  pid_file = "/var/run/telegraf/telegraf.pid"
EOL
  service telegraf restart  > /dev/null 2>&1
  #sleep 1
  #service telegraf status
fi

# influxdb
echo "$(date) installing influxdb on ${IP} ${HOSTNAME} setting bind to ${BIND}..."

INSTALL_DIR=/provision

INFLX="1.2.0"

mkdir -p ${INSTALL_DIR}/influxdb
cd ${INSTALL_DIR}/influxdb
if [ ! -f "influxdb_${INFLX}_amd64.deb" ]; then
   wget -q https://dl.influxdata.com/influxdb/releases/influxdb_${INFLX}_amd64.deb  > /dev/null 2>&1
fi
if [ ! -f "influxdb_${INFLX}_amd64.deb" ]; then
  echo "$(date) ${NAME} $0[$$]: {influxdb: {status:ERROR, msg: missing influxdb_${INFLX}-1_amd64.deb}"
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
cat > /etc/telegraf/telegraf.d/influxdb.conf <<EOL
[[inputs.influxdb]]
  urls = ["http://127.0.0.1:8086/debug/vars"]
[[inputs.procstat]]
  pid_file = "/var/run/influxdb/influxd.pid"
EOL
  service telegraf start > /dev/null  2>&1
  sleep 1
  service telegraf status
fi



# Bro

BROPREF="$(echo $IP|cut -f1,2,3 -d".").0/24"
echo "$(date) installing bro"
wget -qO - http://download.opensuse.org/repositories/network:bro/xUbuntu_15.10/Release.key | apt-key add - > /dev/null 2>&1
apt-key add — < Release.key
echo 'deb http://download.opensuse.org/repositories/network:/bro/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/bro.list
apt-get update > /dev/null 2>&1
apt-get -y --force-yes install bro > /dev/null 2>&1
#interface=eth0
sed -i -e 's,interface=eth0,interface='"$ETH"',g' /opt/bro/etc/node.cfg
echo "$BROPREF      Private IP space" > /opt/bro/etc/networks.cfg

/opt/bro/bin/broctl deploy > /dev/null 2>&1
/opt/bro/bin/broctl status

cat > /etc/telegraf/telegraf.d/bro.conf <<EOL
[[inputs.procstat]]
  exe = "bro"
EOL


#Java
apt-get install -y openjdk-8-jre-headless > /dev/null 2>&1

# elasticsearch
echo "$(date) installing elasticsearch cluster: ${CLUSTER} node: ${NAME} bind: ${IP} unicast host: ${UNICASTHOSTS}"
INSTALL_DIR=/provision
ES=5.2.1
mkdir -p ${INSTALL_DIR}/elasticsearch
cd ${INSTALL_DIR}/elasticsearch
if [ ! -f "elasticsearch-${ES}.deb" ]; then
  wget -4 -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES}.deb > /dev/null 2>&1
fi
if [ ! -f "elasticsearch-${ES}.deb" ]; then
    echo "$(date) ${NAME} $0[$$]: {elastic: {status:ERROR, msg: missing elasticsearch-${ES}.deb}"
    exit -1
else
  echo -e "Y" | dpkg -i elasticsearch-${ES}.deb  > /dev/null 2>&1
  service elasticsearch stop > /dev/null 2>&1
  /usr/share/elasticsearch/bin/elasticsearch-plugin install mobz/elasticsearch-head 2>&1 > /dev/null
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
sed -i -e 's,host => localhost,hosts => "'${ELASTIC}'"\n index => "bro-%{+YYYY.MM.dd.HH}",g' /etc/logstash/conf.d/*.conf
sed -i -e '/date/i \ \ \ \ \de_dot{ }' /etc/logstash/conf.d/*.conf
#sed -i -e 's/id.orig_h/id_orig_h/g' -e 's/id.resp_h/id_resp_h/g' -e 's/id.orig_p/id_orig_p/g' -e 's/id.resp_p/id_resp_p/g' /etc/logstash/conf.d/*.conf
#path => "/nsm/bro/logs/current/conn.log"
sed -i -e 's,/nsm/bro/logs/current/,/opt/bro/logs/current/,g' /etc/logstash/conf.d/*.conf
# filter {
#  de_dot {
#  }
#}
#ls bro-*.conf | while read conf; do echo "filter { de_dot {}}" >> $conf; done


sudo -u logstash /opt/logstash/bin/logstash agent -f /etc/logstash/conf.d --configtest

adduser logstash bro
service logstash start > /dev/null 2>&1
cat > /etc/telegraf/telegraf.d/logstash.conf <<EOL
[[inputs.procstat]]
  pid_file = "/var/run/logstash.pid"
EOL
service telegraf restart > /dev/null 2>&1

# Grafana
echo "$(date) installing grafana on ${IP} ${HOSTNAME}"

INSTALL_DIR=/provision
GRFN="4.1.2-1486989747"
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
  sleep 1
  service grafana-server status
  #service telegraf stop  > /dev/null 2>&1
cat > /etc/telegraf/telegraf.d/grafana.conf <<EOL
[[inputs.procstat]]
  pid_file = "/var/run/grafana-server.pid"
EOL
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
  service telegraf status
  service grafana-server stop
  cd /var/lib/grafana
  #rm grafana.db
  #tar -xzf grafana.tar.gz
  service grafana-server start
  # todo: fix perms
  #chmod 777 /var/run/grafana-server.pid

fi

#Kibana
KBN=5.2.1
ELASTIC=$IP
echo "$(date) installing kibana $KBN on $IP $HOSTNAME setting elastic to $ELASTIC"
#APT Install
#wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - > /dev/null 2>&1
#echo 'deb http://artifacts.elastic.co/packages/'${KBN}'.x/apt stable main' > /etc/apt/sources.list.d/kibana.list
#apt-get update > /dev/null 2>&1
#apt-get -y install kibana > /dev/null 2>&1
# Manual Deb Install
mkdir -p ${INSTALL_DIR}/kibana
cd ${INSTALL_DIR}/kibana
if [ ! -f "kibana-${KBN}-amd64.deb" ]; then
  wget -4 -q https://artifacts.elastic.co/downloads/kibana/kibana-${KBN}-amd64.deb > /dev/null 2>&1
fi
if [ ! -f "kibana-${KBN}-amd64.deb" ]; then
  echo "$(date) ${HOSTNAME} $0[$$]: {kibana: {status:WARNING, msg: missing kibana-${KBN}-amd64.deb}"
  #exit -1
else
  echo -e "Y"|dpkg -i kibana-${KBN}-amd64.deb > /dev/null 2>&1
  /opt/kibana/bin/kibana plugin -i kibana/timelion > /dev/null 2>&1
  chown -R kibana.kibana /opt/kibana/optimize/
# server.host: "0.0.0.0"
  sed -i -e 's,# server.host: "0.0.0.0",server.host: "'${IP}'",g' /opt/kibana/config/kibana.yml
# elasticsearch.url: "http://10.242.11.29:9200"
  sed -i -e 's,# elasticsearch.url: "http://localhost:9200",elasticsearch.url: "http://'${ELASTIC}':9200",g' /opt/kibana/config/kibana.yml
  chown -R kibana.kibana /opt/kibana/optimize/
  service kibana start > /dev/null 2>&1
  cat > /etc/telegraf/telegraf.d/kibana.conf <<EOL
[[inputs.procstat]]
  pid_file = "/var/run/kibana.pid"
EOL
  service telegraf restart  > /dev/null 2>&1

  echo "$(date) done installing"
fi

#to have some traffic
mkdir -p /opt/test
cd /opt/test/
wget -4 -q https://rules.emergingthreats.net/open/suricata-1.3-enhanced/emerging.rules.tar.gz
tar -xzf emerging.rules.tar.gz
cd rules/
grep -E -h -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" *.rules|rev|sort|uniq|rev|while read i; do wget -q -T 1 -t 1 $i; done
echo "$(date) ********Completed********"
