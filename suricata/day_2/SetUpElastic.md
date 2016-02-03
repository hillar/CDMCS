# set up elasticsearch

* nodata masters for pushers
* data nodes
* nodata nodes for clients


```bash
# args => "#{ip to listen} #{node name} #{cluster name} #{counter} #{unicast host}"

# Java
apt-get -y -qq install openjdk-7-jdk

CLUSTER=yellow-$3
NAME=$2
IP=$1
UNICASTHOSTS=$5

echo "setting up elastic cluster: ${CLUSTER} node: ${NAME} bind: ${IP} unicast host: ${UNICASTHOSTS}"
INSTALL_DIR=/provision
ES=1.7.3

mkdir -p ${INSTALL_DIR}/elasticsearch
cd ${INSTALL_DIR}/elasticsearch
if [ ! -f "elasticsearch-${ES}.deb" ]; then
  echo "Downloading and installing elastic search"
  wget -q https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ES}.deb
  if [ ! -f "elasticsearch-${ES}.deb" ]; then
    echo "$(date) ${NAME} $0[$$]: {elastic: {status:ERROR, msg: missing elasticsearch-${ES}.deb}"
    exit -1
  fi
  dpkg -i elasticsearch-${ES}.deb
  /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
  echo "[elasticsearch]" >> /etc/opt/telegraf/telegraf.conf
  echo 'servers = ["http://'${IP}':9200"]' >> /etc/opt/telegraf/telegraf.conf
  echo "  local = true" >> /etc/opt/telegraf/telegraf.conf
  echo "  cluster_health = false" >> /etc/opt/telegraf/telegraf.conf
  service telegraf restart
else
  service elasticsearch stop
fi

echo "cluster.name: ${CLUSTER}" > /etc/elasticsearch/elasticsearch.yml
echo "node.name: ${NAME} " >> /etc/elasticsearch/elasticsearch.yml
echo "node.max_local_storage_nodes: 1 " >> /etc/elasticsearch/elasticsearch.yml
echo "index.number_of_replicas: 0 " >> /etc/elasticsearch/elasticsearch.yml
echo "index.fielddata.cache: node " >> /etc/elasticsearch/elasticsearch.yml
echo "indices.fielddata.cache.size: 40% " >> /etc/elasticsearch/elasticsearch.yml
echo "http.compression: true " >> /etc/elasticsearch/elasticsearch.yml
echo "script.disable_dynamic: true " >> /etc/elasticsearch/elasticsearch.yml
echo "bootstrap.mlockall: true " >> /etc/elasticsearch/elasticsearch.yml
echo "network.bind_host: ${IP}" >> /etc/elasticsearch/elasticsearch.yml
echo "network.publish_host: ${IP}" >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: {$IP}" >> /etc/elasticsearch/elasticsearch.yml
echo "gateway.type: local" >> /etc/elasticsearch/elasticsearch.yml
echo "gateway.recover_after_nodes: 1" >> /etc/elasticsearch/elasticsearch.yml
echo "gateway.recover_after_time: 5m" >> /etc/elasticsearch/elasticsearch.yml
echo "gateway.expected_nodes: 1" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.minimum_master_nodes: 1" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.ping.multicast.enabled: false" >> /etc/elasticsearch/elasticsearch.yml
echo 'discovery.zen.ping.unicast.hosts: ["'${UNICASTHOSTS}'"]' >> /etc/elasticsearch/elasticsearch.yml

service elasticsearch start
```

----

[next : minions](/suricata/day_2/SetUpMinions.md)
