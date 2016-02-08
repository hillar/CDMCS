#!/bin/bash
#
# this script
# 1) installs elasticsearch as
#  a) master no data
#  b) client no data
#  c) dana no http
# 2) set unicast hosts
# 3) sets cluster
# 4) add elasticsearch to telegraf config
#


if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

IP=$1
NAME=$2
CLUSTER=$3
COUNTER=$4
UNICASTHOSTS=$5
TYPE=$6 #master,client or data(default)

echo "adding new node to cluster: ${CLUSTER} node: ${NAME} bind: ${IP} unicast host: ${UNICASTHOSTS}"

INSTALL_DIR=/provision

ES=2.2.0

mkdir -p ${INSTALL_DIR}/elasticsearch
cd ${INSTALL_DIR}/elasticsearch
if [ ! -f "elasticsearch-${ES}.deb" ]; then
  wget -q https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ES}.deb
fi
if [ ! -f "elasticsearch-${ES}.deb" ]; then
    echo "$(date) ${NAME} $0[$$]: {elastic: {status:ERROR, msg: missing elasticsearch-${ES}.deb}"
    exit -1
else
  echo -e "Y" | dpkg -i elasticsearch-${ES}.deb 2>&1 > /dev/null
  service elasticsearch stop
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
  if [ "$TYPE" == "master" ];
  then
    echo "node.master: true" >> /etc/elasticsearch/elasticsearch.yml
    echo "node.data: false" >> /etc/elasticsearch/elasticsearch.yml
    echo "http.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
  else
      if [ "$TYPE" == "client" ];
      then
        echo "node.master: false" >> /etc/elasticsearch/elasticsearch.yml
        echo "node.data: false" >> /etc/elasticsearch/elasticsearch.yml
        echo "http.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
      else
        # defaults to data node
        echo "node.master: false" >> /etc/elasticsearch/elasticsearch.yml
        echo "node.data: true" >> /etc/elasticsearch/elasticsearch.yml
        echo "http.enabled: false" >> /etc/elasticsearch/elasticsearch.yml
      fi
  fi
  service elasticsearch start

  echo "[elasticsearch]" >> /etc/telegraf/telegraf.conf
  echo 'servers = ["http://'${IP}':9200"]' >> /etc/telegraf/telegraf.conf
  echo "  local = true" >> /etc/telegraf/telegraf.conf
  echo "  cluster_health = false" >> /etc/telegraf/telegraf.conf
  service telegraf restart
fi

netstat -ntlpe
